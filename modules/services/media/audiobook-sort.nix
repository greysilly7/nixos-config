_: {
  den.aspects.media._.audiobook-sort = {
    nixos =
      { pkgs, lib, ... }:
      let
        audiobookSort = pkgs.writeShellApplication {
          name = "sort-audiobooks";
          runtimeInputs = [ pkgs.findutils ];
          text = ''
            SRC="/mnt/pool/arr/downloads"
            STAGE="/mnt/pool/arr/staging"

            [ -d "$SRC" ] || { echo "ERROR: SRC does not exist: $SRC" >&2; exit 1; }

            mkdir -p "$STAGE"/{audiobooks,ebooks,comics,docs,review}

            shopt -s nocaseglob nullglob

            n=0
            for item in "$SRC"/*; do
              base=$(basename "$item")
              [[ "$base" == *.\!qB ]] && continue
              [[ "$base" == *.sh ]] && continue

              if [ -d "$item" ]; then
                if find "$item" \( -iname '*.m4b' -o -iname '*.mp3' \) -print -quit | grep -q .; then
                  dest="audiobooks"
                elif find "$item" -iname '*.epub' -print -quit | grep -q .; then
                  dest="ebooks"
                elif find "$item" \( -iname '*.cbz' -o -iname '*.cbr' \) -print -quit | grep -q .; then
                  dest="comics"
                elif find "$item" \( -iname '*.pdf' -o -iname '*.djvu' \) -print -quit | grep -q .; then
                  dest="docs"
                else
                  dest="review"
                fi
              else
                case "$item" in
                  *.m4b|*.mp3)  dest="audiobooks" ;;
                  *.epub)       dest="ebooks" ;;
                  *.cbz|*.cbr)  dest="comics" ;;
                  *.pdf|*.djvu) dest="docs" ;;
                  *)            dest="review" ;;
                esac
              fi

              ln -sf "$item" "$STAGE/$dest/$base"
              n=$((n+1))
            done

            echo "Symlinked $n items."
          '';
        };
      in
      {
        systemd.services.audiobook-sort = {
          description = "Sort new audiobooks into library";
          after = [ "zfs-mount.service" ];
          serviceConfig = {
            Type = "oneshot";
            User = "media";
            Group = "media";
            ExecStart = "${audiobookSort}/bin/sort-audiobooks";
          };
        };

        systemd.services.audiobook-sort.serviceConfig.ExecStartPre = lib.mkAfter [
          "+${pkgs.coreutils}/bin/mkdir -p /mnt/pool/arr/staging"
          "+${pkgs.coreutils}/bin/chown --no-dereference -R media:media /mnt/pool/arr/staging"
        ];

        systemd.timers.audiobook-sort = {
          description = "Periodically sort new audiobooks";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "5m";
            OnUnitActiveSec = "15m";
            Persistent = true;
          };
        };
      };
  };
}
