#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_dir="$root_dir/_backups"
mkdir -p "$backup_dir"

ts="$(date -u +"%Y%m%dT%H%M%SZ")"
archive="$backup_dir/kak-config-$ts.tar.gz"

# Backup everything in the config dir except the backups directory itself.
tar -czf "$archive" --exclude "./_backups" -C "$root_dir" .

printf 'Backup created: %s\n' "$archive"
