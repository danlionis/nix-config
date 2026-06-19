let
  keys = import ../keys.nix;
in
{
  "restic/password".publicKeys = keys.users ++ keys.dan-pc ++ [ keys.kronos ];
  "restic/paperless-b2-env".publicKeys = keys.users ++ keys.dan-pc ++ [ keys.kronos ];
  "restic/ssh_key".publicKeys = keys.users ++ keys.dan-pc ++ [ keys.kronos ];

  "CLOUDFLARE_DNS_API_TOKEN".publicKeys = keys.users ++ [ keys.kronos ];

  "password-hash".publicKeys = keys.all;

  "pocket-id/encryption_key".publicKeys = keys.users ++ [ keys.kronos ];

  "linkding/env".publicKeys = keys.users ++ [ keys.kronos ];

  "beszel/kronos".publicKeys = keys.users ++ [ keys.kronos ];
  "beszel/dan-pc".publicKeys = keys.users;
  "beszel/work".publicKeys = keys.users;
}
