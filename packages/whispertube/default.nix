{
  pkgs,
  defaultOutputDir ? "$HOME/Downloads/subtitles",
  defaultModelDir ? "$HOME/.cache/whisper-models",
  model ? "large-v3",
}:

pkgs.writeShellApplication rec {
  name = "whispertube";

  runtimeInputs = with pkgs; [
    yt-dlp
    ffmpeg
    whisper-cpp-vulkan
    curl
  ];

  text = ''
    set -euo pipefail

    IFS=$'\n\t'

    if [[ "''${DEBUG-}" =~ ^1|yes|true$ ]]; then
        set -x
    fi
    # GPU Compatibility for RX 7800 XT
    export HSA_OVERRIDE_GFX_VERSION=11.0.0

    if [[ $# -eq 0 ]]; then
      echo "Usage: ${name} <youtube-url> [language_code]"
      exit 1
    fi

    OUTPUT_DIR="''${OUTPUT_DIR:-${defaultOutputDir}}"
    MODEL_DIR="''${MODEL_DIR:-${defaultModelDir}}"
    MODEL_PATH="$MODEL_DIR/ggml-${model}.bin"

    LANG="''${2:-auto}"
    MAX_LEN=90

    mkdir -p "$OUTPUT_DIR"
    mkdir -p "$MODEL_DIR"

    if [[ ! -f "$MODEL_PATH" ]]; then
      echo "downloading model ${model}..."
      curl -L "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-${model}.bin" -o "$MODEL_PATH"
    fi

    WORK_DIR=$(mktemp -d -p /tmp ytsubs.XXXXXXXXXX)
    readonly WORK_DIR

    trap 'rm -rf "$WORK_DIR"' EXIT

    cd "$WORK_DIR"

    echo "downloading audio..."
    TITLE=$(yt-dlp --get-title "$1")
    RAW_WAV="audio_raw.wav"

    # yt-dlp -x --audio-format wav --audio-quality 0 -o "$RAW_WAV" "$1"
    if [[ "$LANG" == "auto" ]]; then
        # Just get the default best audio
        YT_FORMAT="bestaudio"
    else
        # Try to match the language code, fallback to best audio
        YT_FORMAT="ba[language*='$LANG']/wa[language*='$LANG']/w[language*='$LANG']/worstaudio/worst"
    fi
    yt-dlp -f "$YT_FORMAT" -x --audio-format wav --audio-quality 0 -o "$RAW_WAV" "$1"

    echo "optimizing audio for whisper..."
    PROC_WAV="audio_proc.wav"
    ffmpeg -i "$RAW_WAV" -ar 16000 -ac 1 -c:a pcm_s16le "$PROC_WAV" -y

    echo "transcribing..."
    whisper-cli --model "$MODEL_PATH" \
      --file "$PROC_WAV" \
      --language "$LANG" \
      --split-on-word \
      --max-context 0 \
      --no-fallback \
      --suppress-nst \
      --beam-size 8 \
      --output-srt \
      --max-len "$MAX_LEN"

    FINAL_SRT_NAME="''${TITLE}.srt"
    mv "''${PROC_WAV}.srt" "$OUTPUT_DIR/$FINAL_SRT_NAME"

    echo "subtitles saved to: $OUTPUT_DIR/$FINAL_SRT_NAME"
  '';
}
