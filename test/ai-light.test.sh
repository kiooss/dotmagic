#!/bin/sh
# ai-light test suite. Run: sh test/ai-light.test.sh
#
# No framework, no deps. Each test gets a fresh AI_LIGHT_DIR so claims from one
# test can never leak into the next.
set -u

root=$(cd "$(dirname "$0")/.." && pwd)
ai_light="$root/bin/ai-light"
fails=0

check() { # check <desc> <expected> <actual>
  if [ "$2" = "$3" ]; then
    printf 'ok   %s\n' "$1"
  else
    printf 'FAIL %s\n       expected: [%s]\n       actual:   [%s]\n' "$1" "$2" "$3"
    fails=$((fails + 1))
  fi
}

fresh() { # start a test with an empty state dir
  AI_LIGHT_DIR=$(mktemp -d)
  export AI_LIGHT_DIR
}

winner() { "$ai_light" status | sed -n 's/^winner: //p'; }

# --- state store ---------------------------------------------------------

fresh
"$ai_light" set working --source a
check 'set writes a claim file' 'working 60 normal' \
  "$(cut -d' ' -f1-3 "$AI_LIGHT_DIR/a")"

fresh
"$ai_light" set thinking --source a --ttl 5 --priority alert
check 'set records ttl and priority' 'thinking 5 alert' \
  "$(cut -d' ' -f1-3 "$AI_LIGHT_DIR/a")"

fresh
"$ai_light" set working
check 'source defaults to "default"' 'working' \
  "$(cut -d' ' -f1 "$AI_LIGHT_DIR/default")"

fresh
"$ai_light" set working --source a
"$ai_light" clear --source a
check 'clear removes the claim file' 'gone' \
  "$([ -e "$AI_LIGHT_DIR/a" ] && echo present || echo gone)"

fresh
"$ai_light" set working --source a
"$ai_light" set off --source a
check 'off is equivalent to clear' 'gone' \
  "$([ -e "$AI_LIGHT_DIR/a" ] && echo present || echo gone)"

fresh
"$ai_light" set bogus --source a 2>/dev/null
check 'invalid state exits 2' '2' "$?"
check 'invalid state writes nothing' 'gone' \
  "$([ -e "$AI_LIGHT_DIR/a" ] && echo present || echo gone)"

fresh
"$ai_light" set working --source a
check 'status lists the source' 'source a working normal 60' \
  "$("$ai_light" status | grep '^source ')"

# --- summary -------------------------------------------------------------

if [ "$fails" -gt 0 ]; then
  printf '\n%s test(s) failed\n' "$fails"
  exit 1
fi
printf '\nall tests passed\n'
