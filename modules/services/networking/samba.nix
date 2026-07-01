_: {
  den.aspects.samba = {
    nixos = _: {
      # make shares visible for windows/mac clients
      services.samba-wsdd = {
        enable = true;
        openFirewall = true;
      };

      services.samba = {
        enable = true;
        openFirewall = true;
        settings = {
          global = {
            "workgroup" = "WORKGROUP";
            "server string" = "smbnix";
            "netbios name" = "smbnix";
            "security" = "user";
            # "use sendfile" = "yes";
            # "max protocol" = "smb3";
            # Note: localhost is the ipv6 localhost ::1
            "hosts allow" = "192.168. 10. 127.0.0.1 localhost";
            "hosts deny" = "0.0.0.0/0";
            "guest account" = "nobody";
            "map to guest" = "bad user";
          };
          public = {
            "path" = "/mnt/pool/public";
            "browseable" = "yes";
            "read only" = "no";
            "guest ok" = "yes";
            "create mask" = "0644";
            "directory mask" = "0755";
            "force user" = "nobody";
            "force group" = "nogroup";
          };
          mactimemachine = {
            "path" = "/mnt/pool/mactimemachine";
            "browseable" = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "create mask" = "0600";
            "directory mask" = "0700";
            "valid users" = "tm";
            "force user" = "tm";
            "vfs objects" = "catia fruit streams_xattr";
            "fruit:aapl" = "yes";
            "fruit:time machine" = "yes";
          };
        };
      };

      # Ensure the directories exist with correct permissions
      systemd.tmpfiles.rules = [
        "d /mnt/pool/public 0755 nobody nogroup -"
        "d /mnt/pool/mactimemachine 0700 tm users -"
      ];
    };
  };
}
