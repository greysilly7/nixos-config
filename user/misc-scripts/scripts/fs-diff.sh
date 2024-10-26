#!/usr/bin/env bash
# fs-diff.sh
set -euo pipefail

# Create and mount the directory
sudo mkdir -p /mnt
sudo mount /dev/mapper/crypted /mnt -o subvol=/

# Find the latest transaction ID for the subvolume
OLD_TRANSID=$(sudo btrfs subvolume find-new /mnt/root-blank 9999999)
OLD_TRANSID=${OLD_TRANSID#transid marker was }

# Find new changes in the subvolume since the last transaction ID
sudo btrfs subvolume find-new "/mnt/root" "$OLD_TRANSID" |
sed '$d' |  # Remove the last line
cut -f17- -d' ' |  # Extract the path
sort |  # Sort the paths
uniq |  # Remove duplicates
while read path; do
  path="/$path"
  if [ -L "$path" ]; then
    : # The path is a symbolic link, so is probably handled by NixOS already
  elif [ -d "$path" ]; then
    : # The path is a directory, ignore
  else
    echo "$path"  # Print the path
  fi
done

# Unmount the directory
sudo umount /mnt