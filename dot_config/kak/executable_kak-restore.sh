#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_dir="$root_dir/_backups"
archive="${1:-}"

if [ -z "$archive" ]; then
  archive="$(ls -1t "$backup_dir"/kak-config-*.tar.gz 2>/dev/null | head -n 1 || true)"
fi

if [ -z "$archive" ] || [ ! -f "$archive" ]; then
  printf 'No backup archive found.\n' >&2
  exit 1
fi

printf 'Restore will DELETE current config (except _backups) and extract:\n  %s\n' "$archive"
printf 'Continue? [y/N] '
read -r reply
if [ "$reply" != "y" ] && [ "$reply" != "Y" ]; then
  printf 'Aborted.\n'
  exit 1
fi

# Optional safety backup before restore.
if [ "${NO_BACKUP:-}" != "1" ]; then
  "$root_dir/kak-backup.sh" >/dev/null
fi

# Wipe current contents except the backups dir, then restore.
find "$root_dir" -mindepth 1 -maxdepth 1 ! -name "_backups" -exec rm -rf {} +

tar -xzf "$archive" -C "$root_dir"

printf 'Restore complete.\n'
