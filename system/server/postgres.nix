{lib, ...}: {
  services.postgresql = {
    enable = true; # Enable PostgreSQL service
    ensureDatabases = ["spacebar"]; # Ensure the "spacebar" database exists
    ensureUsers = [
      {
        name = "spacebar"; # Ensure the "spacebar" user exists
        ensureDBOwnership = true; # Ensure the user owns the database
      }
    ];
    enableTCPIP = true; # Enable TCP/IP connections

    # Authentication configuration
    authentication = lib.mkOverride 10 ''
      # type  database  DBuser  origin-address  auth-method
      # Local connections
      local   all       all     trust
      # IPv4 connections
      host    all       all     127.0.0.1/32    trust
      # IPv6 connections
      host    all       all     ::1/128         trust
    '';

    # Ident map configuration
    identMap = ''
      # ArbitraryMapName  systemUser  DBUser
      superuser_map      root        postgres
      superuser_map      postgres    postgres
      # Let other names login as themselves
      superuser_map      /^(.*)$     \1
    '';
  };
}
