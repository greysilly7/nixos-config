#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <flake> <target-host>"
    exit 1
fi

flake="$1"
target="$2"

temp=$(mktemp -d)

cleanup() {
    rm -rf "$temp"
}

trap cleanup EXIT

# Create SSH directory
install -d -m 755 "$temp/etc/ssh"

# Generate host keys
ssh_key_types=("rsa" "ecdsa" "ed25519")

for key_type in "${ssh_key_types[@]}"; do
    key_file="$temp/etc/ssh/ssh_host_${key_type}_key"
    ssh-keygen -t "$key_type" -f "$key_file" -N "" -q

    chmod 600 "$key_file"
    chmod 644 "${key_file}.pub"
done

echo "Generated SSH host keys in $temp/etc/ssh:"
ls -l "$temp/etc/ssh"

nix-shell -p ssh-to-age --run "cat $temp/etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age"

# Give me time to update sops
read -p "Press Enter to continue" </dev/tty

nix run github:nix-community/nixos-anywhere -- \
    --extra-files "$temp/etc/ssh" \
    --flake "$flake" \
    --target-host "$target" \
