rec {
  dan-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXOCJeBh3kzaOMH5gwKiXASVPsvR0L819me5Kasdi7+";
  dan-mbp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG9P2/XJxMMoeS3rwpaJ0OXckAa6p//1sDsYmv2cKV/M"; # macbook
  dan-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJogjY+bM9NDHMnN8Iq5oN7abewBGPdN46z8FGb2BRu3";

  kronos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIP+5lDeQUQLd9jriFQLqpWjSpkn1kAk2QfzSINut7cR";

  backup = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBv9iHztDz+28HUUBcwGPugwPAjuNtcXQOy+MzgNx2/x";

  dan = [
    dan-user
    dan-pc
    dan-mbp
  ];
}
