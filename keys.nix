rec {
  dan-pc-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXOCJeBh3kzaOMH5gwKiXASVPsvR0L819me5Kasdi7+";
  dan-pc-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJogjY+bM9NDHMnN8Iq5oN7abewBGPdN46z8FGb2BRu3";

  dan-mbp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG9P2/XJxMMoeS3rwpaJ0OXckAa6p//1sDsYmv2cKV/M"; # macbook

  kronos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIP+5lDeQUQLd9jriFQLqpWjSpkn1kAk2QfzSINut7cR";

  backup = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBv9iHztDz+28HUUBcwGPugwPAjuNtcXQOy+MzgNx2/x";

  work-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINXOhKDErZLoBH52A5xOLZwubxA5PTVcOuoKlyUoDvSQ";
  work-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDTx9e0NlwJrQEtSlnJ5Uhe1MgKlBFbLXb1fL4uNX9Hb";

  users = [
    dan-pc-user
    work-user
  ];

  dan-pc = [
    dan-pc-host
    dan-pc-user
  ];

  work = [
    work-user
    work-host
  ];

  servers = [ kronos ];

  all = dan-pc ++ work ++ servers;
}
