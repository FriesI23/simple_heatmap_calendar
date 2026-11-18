#!/usr/bin/env bash
set -euo pipefail
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
command -v img2webp >/dev/null || { echo 'img2webp (WebP tools) is required.' >&2; exit 1; }
for scenario in playground interaction; do
  frames=("$repo_dir/build/example-demos/$scenario/"*.png)
  img2webp -min_size -loop 0 -lossy -q 65 -m 6 -d 83 \
    "${frames[@]}" -o "$repo_dir/screenshots/$scenario.webp"
done
