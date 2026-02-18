#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

usage() {
  cat <<'EOF'
Usage:
  scripts/export-mrpack.sh [--output FILE] [--packwiz-bin PATH]

Examples:
  scripts/export-mrpack.sh
  scripts/export-mrpack.sh --output output/Solworld-custom.mrpack
  scripts/export-mrpack.sh --packwiz-bin ~/go/bin/packwiz
EOF
}

output=""
packwiz_bin="${PACKWIZ_BIN:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output)
      shift
      if [[ $# -eq 0 ]]; then
        echo "Error: missing value for --output" >&2
        exit 1
      fi
      output="$1"
      ;;
    --packwiz-bin)
      shift
      if [[ $# -eq 0 ]]; then
        echo "Error: missing value for --packwiz-bin" >&2
        exit 1
      fi
      packwiz_bin="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown argument '$1'" >&2
      usage
      exit 1
      ;;
  esac
  shift
done

if [[ -z "$packwiz_bin" ]]; then
  if command -v packwiz >/dev/null 2>&1; then
    packwiz_bin="packwiz"
  elif [[ -x "$HOME/go/bin/packwiz" ]]; then
    packwiz_bin="$HOME/go/bin/packwiz"
  else
    echo "Error: packwiz binary not found. Install packwiz or use --packwiz-bin." >&2
    exit 1
  fi
fi

if [[ -z "$output" ]]; then
  version="$(awk -F'"' '/^version = / {print $2; exit}' pack.toml)"
  if [[ -z "$version" ]]; then
    echo "Error: cannot read version from pack.toml" >&2
    exit 1
  fi
  output="output/Solworld-${version}.mrpack"
fi

output_dir="$(dirname "$output")"
if [[ "$output_dir" != "." ]]; then
  mkdir -p "$output_dir"
fi

# Keep metadata URLs from both Modrinth and CurseForge in the manifest.
"$packwiz_bin" modrinth export --restrictDomains=false -o "$output"

echo "Exported: $output"
