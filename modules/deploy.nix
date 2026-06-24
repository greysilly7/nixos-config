_: {
  perSystem =
    { pkgs, ... }:
    {
      packages.deploy = pkgs.writeShellApplication {
        name = "deploy";
        runtimeInputs = [
          pkgs.nixos-rebuild
          pkgs.openssh
          pkgs.git
        ];
        text = ''
          # syntax: bash

          # Default values
          target_user="greysilly7"
          target_host=""
          target_ip=""
          target_port=""
          use_sudo=1

          # Helper to print help
          show_help() {
            echo "Usage: nix run .#deploy -- <hostname> [options]"
            echo ""
            echo "Options:"
            echo "  -u, --user <user>      Target SSH user (default: greysilly7)"
            echo "  -i, --ip <ip>          Explicit Tailscale IP or hostname to connect to"
            echo "  -p, --port <port>      Explicit SSH port to connect to"
            echo "  --no-sudo              Do not use sudo/ask-sudo-password"
            echo "  -h, --help             Show this help message"
            echo ""
            echo "Example:"
            echo "  nix run .#deploy -- greyserver -i 100.75.106.126 -p 59191"
          }

          if [ $# -eq 0 ]; then
            show_help
            exit 1
          fi

          # First argument is the hostname if it doesn't start with -
          if [[ "$1" != -* ]]; then
            target_host="$1"
            shift
          fi

          while [[ $# -gt 0 ]]; do
            case $1 in
              -u|--user)
                target_user="$2"
                shift 2
                ;;
              -i|--ip)
                target_ip="$2"
                shift 2
                ;;
              -p|--port)
                target_port="$2"
                shift 2
                ;;
              --no-sudo)
                use_sudo=0
                shift
                ;;
              -h|--help)
                show_help
                exit 0
                ;;
              *)
                if [ -z "$target_host" ]; then
                  target_host="$1"
                  shift
                else
                  echo "Unknown option: $1"
                  show_help
                  exit 1
                fi
                ;;
            esac
          done

          if [ -z "$target_host" ]; then
            echo "Error: Target hostname is required."
            show_help
            exit 1
          fi

          # Resolve target IP/address via Tailscale if not explicitly provided
          if [ -z "$target_ip" ]; then
            # Try to check Tailscale status if available on macOS
            TS_CLI="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
            if [ -x "$TS_CLI" ]; then
              echo "[-] Querying Tailscale for $target_host..."
              # Match hostname in tailscale status
              found_ip=$("$TS_CLI" status | awk -v host="$target_host" 'tolower($2) == tolower(host) {print $1; exit}')
              if [ -n "$found_ip" ]; then
                target_ip="$found_ip"
                echo "[+] Found Tailscale IP: $target_ip"
              else
                echo "[-] Could not find explicit match in Tailscale status, defaulting to hostname '$target_host'"
                target_ip="$target_host"
              fi
            else
              target_ip="$target_host"
            fi
          fi

          deploy_target="$target_user@$target_ip"
          echo "[+] Deploying flake .#$target_host to $deploy_target..."

          if [ -n "$target_port" ]; then
            export NIX_SSHOPTS="-p $target_port"
            echo "[+] Using SSH port: $target_port"
          fi

          rebuild_args=(
            switch
            --flake ".#$target_host"
            --target-host "$deploy_target"
            --build-host "$deploy_target"
          )

          if [ "$use_sudo" -eq 1 ]; then
            rebuild_args+=(--sudo --ask-sudo-password)
          fi

          echo "[+] Running nixos-rebuild ''${rebuild_args[*]}"
          exec nixos-rebuild "''${rebuild_args[@]}"
        '';
      };
    };
}
