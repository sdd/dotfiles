#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

printf 'Reset will DELETE downloaded content and leave only persistent config.\n'
printf 'Continue? [y/N] '
read -r reply
if [ "$reply" != "y" ] && [ "$reply" != "Y" ]; then
  printf 'Aborted.\n'
  exit 1
fi

# Always keep these items.
keep=(
  "_backups"
  "autoload"
  "kakrc"
  "kak-lsp.toml"
  "DEVELOPMENT_PLAN.md"
  "kak-backup.sh"
  "kak-restore.sh"
  "kak-reset.sh"
)

# Build a find expression to keep the whitelist, delete everything else.
find_expr=("!" "-name" "${keep[0]}")
for name in "${keep[@]:1}"; do
  find_expr+=("!" "-name" "$name")
done

find "$root_dir" -mindepth 1 -maxdepth 1 "${find_expr[@]}" -exec rm -rf {} +

printf 'Reset complete.\n'
