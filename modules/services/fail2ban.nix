_: {
  den.aspects.fail2ban = {
    nixos = _: {
      services.fail2ban = {
        enable = true;
        maxretry = 5;
        bantime = "1h";
        bantime-increment = {
          enable = true;
          maxtime = "168h";
          factor = "4";
        };

        jails = {
          # SSH brute-force protection (uses built-in sshd filter)
          sshd = {
            settings = {
              enabled = true;
              port = "ssh";
              filter = "sshd[mode=aggressive]";
              maxretry = 3;
              findtime = "10m";
              bantime = "1h";
            };
          };

          # Caddy HTTP auth failures and suspicious probes
          caddy-status = {
            settings = {
              enabled = true;
              port = "http,https";
              filter = "caddy-status";
              logpath = "/var/log/caddy/access*.log";
              maxretry = 10;
              findtime = "10m";
              bantime = "30m";
            };
          };

          # Vaultwarden login failures
          vaultwarden = {
            settings = {
              enabled = true;
              port = "http,https";
              filter = "vaultwarden";
              logpath = "/var/lib/vaultwarden/vaultwarden.log";
              maxretry = 5;
              findtime = "10m";
              bantime = "1h";
            };
          };
        };
      };

      # Caddy filter: catch 401/403/404 floods (scanners and brute-forcers)
      environment.etc."fail2ban/filter.d/caddy-status.conf".text = ''
        [Definition]
        failregex = ^.*"client_ip":"<HOST>".*"status":(401|403|404).*$
        ignoreregex =
      '';

      # Vaultwarden filter: catch failed login attempts
      environment.etc."fail2ban/filter.d/vaultwarden.conf".text = ''
        [Definition]
        failregex = ^.*Username or password is incorrect\. Try again\. IP: <HOST>\..*$
        ignoreregex =
      '';

      # Caddy needs to log to a file for fail2ban to parse
      services.caddy.logFormat = ''
        output file /var/log/caddy/access.log {
          roll_size 10MiB
          roll_keep 5
        }
      '';

      systemd.tmpfiles.rules = [
        "d /var/log/caddy 0755 caddy caddy -"
      ];

      # Enable vaultwarden file logging for fail2ban
      services.vaultwarden.config.LOG_FILE = "/var/lib/vaultwarden/vaultwarden.log";
      services.vaultwarden.config.LOG_LEVEL = "warn";
    };
  };
}
