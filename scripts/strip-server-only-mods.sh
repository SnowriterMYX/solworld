#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat <<'EOF'
Usage:
  scripts/strip-server-only-mods.sh [--dry-run] [INSTANCE_DIR|MODS_DIR]

Examples:
  scripts/strip-server-only-mods.sh /home/user/.minecraftx/instances/Solworld-0.1.0.51
  scripts/strip-server-only-mods.sh /home/user/.minecraftx/instances/Solworld-0.1.0.51/mods
  scripts/strip-server-only-mods.sh --dry-run /home/user/.minecraftx/instances/Solworld-0.1.0.51
EOF
}

dry_run=0
target_arg=""

for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=1 ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -n "$target_arg" ]]; then
        echo "Error: too many target paths." >&2
        usage
        exit 1
      fi
      target_arg="$arg"
      ;;
  esac
done

if [[ -z "$target_arg" ]]; then
  target_arg="."
fi

if [[ -d "$target_arg/mods" ]]; then
  mods_dir="$target_arg/mods"
elif [[ -d "$target_arg" && "$(basename "$target_arg")" == "mods" ]]; then
  mods_dir="$target_arg"
else
  echo "Error: could not find mods directory under '$target_arg'." >&2
  exit 1
fi

mapfile -t server_filenames < <(
  awk 'BEGIN{FS="= "} FNR==1{server=0;fn=""}
    /^side = "server"/ {server=1}
    /^filename = / {gsub(/"/,"",$2); fn=$2}
    ENDFILE {if(server && fn!="") print fn}
  ' "$ROOT_DIR"/mods/*.pw.toml | sort -u
)

if [[ ${#server_filenames[@]} -eq 0 ]]; then
  echo "No side=server entries found in $ROOT_DIR/mods/*.pw.toml"
  exit 0
fi

disabled_dir="$mods_dir/_server_only_disabled"
if [[ $dry_run -eq 0 ]]; then
  mkdir -p "$disabled_dir"
fi

moved=0
for filename in "${server_filenames[@]}"; do
  src="$mods_dir/$filename"
  if [[ -f "$src" ]]; then
    if [[ $dry_run -eq 1 ]]; then
      echo "[dry-run] would move: $src -> $disabled_dir/"
    else
      mv -f "$src" "$disabled_dir/"
      echo "moved: $filename"
    fi
    moved=$((moved + 1))
  fi
done

if [[ $dry_run -eq 1 ]]; then
  echo "[dry-run] total matches: $moved"
else
  echo "done: moved $moved file(s) to $disabled_dir"
fi
