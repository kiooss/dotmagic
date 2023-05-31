#!/usr/bin/env bash

DEFAULT_PATTERN='Completed (500|4[0-9]{2})'
: "${ERROR_PATTERN:=$DEFAULT_PATTERN}"
echo "$ERROR_PATTERN"

for f in "$@"; do
  echo "👉Processing $f ..."
  if [[ $f == *.gz ]]; then
    gunzip -c "$f" | grep -aE "$ERROR_PATTERN" | awk '{ match($0, /\[\w{8}-\w{4}-\w{4}-\w{4}-\w{12}\]/); print substr($0, RSTART, RLENGTH) }' | tr -d '[]' | xargs -I {} sh -c "gunzip -c $f | grep -aE {}"
  else
    grep -aE "$ERROR_PATTERN" "$f" | awk '{ match($0, /\[\w{8}-\w{4}-\w{4}-\w{4}-\w{12}\]/); print substr($0, RSTART, RLENGTH) }' | tr -d '[]' | xargs -I {} grep -aE '{}' "$f"
  fi
done
