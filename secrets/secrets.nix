let
  keys = import ../keys.nix;
in
{
  "restic/password".publicKeys = keys.dan ++ [ keys.kronos ];
  "restic/paperless-b2-env".publicKeys = keys.dan ++ [ keys.kronos ];
  "restic/ssh_key".publicKeys = keys.dan ++ [ keys.kronos ];

  "CLOUDFLARE_DNS_API_TOKEN".publicKeys = keys.dan ++ [ keys.kronos ];

  "password-hash".publicKeys = keys.dan ++ [ keys.kronos ];

  "pocket-id/encryption_key".publicKeys = keys.dan ++ [ keys.kronos ];

  "linkding/env".publicKeys = keys.dan ++ [ keys.kronos ];
}
