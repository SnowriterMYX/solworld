#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$ROOT_DIR/automodpack/host-modpack/main/mods"
DRY_RUN=0
CLEAN_STALE=1

usage() {
  cat <<'EOF'
Usage:
  scripts/sync-automodpack-client-mods.sh [--dry-run] [--no-clean]

Options:
  --dry-run   Only print planned actions, do not download or delete files.
  --no-clean  Keep stale jars in target directory.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --no-clean)
      CLEAN_STALE=0
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

if [[ $DRY_RUN -eq 0 ]]; then
  mkdir -p "$TARGET_DIR"
else
  echo "[dry-run] target: $TARGET_DIR"
fi

lower() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

compute_hash() {
  local file="$1"
  local format="$2"
  local value=""

  case "$format" in
    sha1)
      if has_cmd sha1sum; then
        value="$(sha1sum "$file" | awk '{print $1}')"
      elif has_cmd shasum; then
        value="$(shasum -a 1 "$file" | awk '{print $1}')"
      else
        return 2
      fi
      ;;
    sha256)
      if has_cmd sha256sum; then
        value="$(sha256sum "$file" | awk '{print $1}')"
      elif has_cmd shasum; then
        value="$(shasum -a 256 "$file" | awk '{print $1}')"
      else
        return 2
      fi
      ;;
    sha512)
      if has_cmd sha512sum; then
        value="$(sha512sum "$file" | awk '{print $1}')"
      elif has_cmd shasum; then
        value="$(shasum -a 512 "$file" | awk '{print $1}')"
      else
        return 2
      fi
      ;;
    md5)
      if has_cmd md5sum; then
        value="$(md5sum "$file" | awk '{print $1}')"
      elif has_cmd md5; then
        value="$(md5 -q "$file")"
      else
        return 2
      fi
      ;;
    *)
      return 1
      ;;
  esac

  echo "$value"
}

can_verify_hash_format() {
  local format="$1"
  case "$format" in
    sha1)
      has_cmd sha1sum || has_cmd shasum
      ;;
    sha256)
      has_cmd sha256sum || has_cmd shasum
      ;;
    sha512)
      has_cmd sha512sum || has_cmd shasum
      ;;
    md5)
      has_cmd md5sum || has_cmd md5
      ;;
    *)
      return 1
      ;;
  esac
}

verify_hash() {
  local file="$1"
  local format expected actual
  format="$(lower "$2")"
  expected="$(lower "$3")"

  if [[ -z "$expected" ]]; then
    return 1
  fi

  if ! actual="$(compute_hash "$file" "$format")"; then
    return 1
  fi

  [[ "$(lower "$actual")" == "$expected" ]]
}

download_to() {
  local url="$1"
  local dest="$2"
  if has_cmd curl; then
    curl -fsSL --retry 3 --retry-delay 2 -o "$dest" "$url"
  elif has_cmd wget; then
    wget -q -O "$dest" "$url"
  else
    echo "Error: neither curl nor wget is available." >&2
    return 1
  fi
}

meta_files=()
while IFS= read -r f; do
  meta_files+=("$f")
done < <(rg -l 'side = "client"' "$ROOT_DIR/mods/"*.pw.toml | sort || true)

if [[ ${#meta_files[@]} -eq 0 ]]; then
  echo "No side=client entries found in $ROOT_DIR/mods/*.pw.toml"
  exit 0
fi

declare -A expected_url=()
declare -A expected_hash=()
declare -A expected_hash_format=()

for meta in "${meta_files[@]}"; do
  filename="$(awk -F'"' '/^filename = "/ {print $2; exit}' "$meta")"
  url="$(awk -F'"' '/^url = "/ {print $2; exit}' "$meta")"
  hash_format="$(awk -F'"' '/^hash-format = "/ {print tolower($2); exit}' "$meta")"
  hash_value="$(awk -F'"' '/^hash = "/ {print tolower($2); exit}' "$meta")"

  if [[ -z "$filename" || -z "$url" ]]; then
    echo "Error: incomplete client metadata in $meta" >&2
    exit 1
  fi

  expected_url["$filename"]="$url"
  expected_hash["$filename"]="$hash_value"
  expected_hash_format["$filename"]="$hash_format"
done

synced_count=0
downloaded_count=0
skipped_count=0

for meta in "${meta_files[@]}"; do
  filename="$(awk -F'"' '/^filename = "/ {print $2; exit}' "$meta")"
  url="${expected_url[$filename]}"
  hash_format="${expected_hash_format[$filename]}"
  hash_value="${expected_hash[$filename]}"
  dest="$TARGET_DIR/$filename"
  tmp="$dest.tmp"
  hash_check_enabled=0
  if can_verify_hash_format "$hash_format"; then
    hash_check_enabled=1
  fi

  needs_download=1
  if [[ -f "$dest" ]]; then
    if [[ $hash_check_enabled -eq 1 ]] && verify_hash "$dest" "$hash_format" "$hash_value"; then
      needs_download=0
      skipped_count=$((skipped_count + 1))
    elif [[ $hash_check_enabled -eq 0 ]]; then
      echo "warn: unsupported hash-format '$hash_format' for $filename, keeping existing file"
      needs_download=0
      skipped_count=$((skipped_count + 1))
    else
      echo "hash mismatch, re-fetch: $filename"
    fi
  fi

  if [[ $needs_download -eq 1 ]]; then
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "[dry-run] download $filename"
      downloaded_count=$((downloaded_count + 1))
    else
      download_to "$url" "$tmp"
      if [[ $hash_check_enabled -eq 1 ]]; then
        if ! verify_hash "$tmp" "$hash_format" "$hash_value"; then
          rm -f "$tmp"
          echo "Error: hash verification failed for $filename" >&2
          exit 1
        fi
      else
        echo "warn: skip hash verify for $filename (hash-format: $hash_format)"
      fi
      mv -f "$tmp" "$dest"
      downloaded_count=$((downloaded_count + 1))
      echo "synced: $filename"
    fi
  fi
  synced_count=$((synced_count + 1))
done

cleaned_count=0
if [[ $CLEAN_STALE -eq 1 ]]; then
  while IFS= read -r existing; do
    base="$(basename "$existing")"
    if [[ -z "${expected_url[$base]+x}" ]]; then
      if [[ $DRY_RUN -eq 1 ]]; then
        echo "[dry-run] delete stale $base"
      else
        rm -f "$existing"
        echo "deleted stale: $base"
      fi
      cleaned_count=$((cleaned_count + 1))
    fi
  done < <(find "$TARGET_DIR" -maxdepth 1 -type f -name '*.jar' -print 2>/dev/null | sort)
fi

echo "client-only mods processed: $synced_count"
echo "downloaded/updated: $downloaded_count"
echo "already up-to-date: $skipped_count"
if [[ $CLEAN_STALE -eq 1 ]]; then
  echo "stale deleted: $cleaned_count"
fi
