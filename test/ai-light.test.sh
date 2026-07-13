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

# A fake curl on PATH: logs each invocation's URL, and fails when
# CURL_SHOULD_FAIL is set, so we can test the retry behaviour.
stub_curl() {
  stubdir=$(mktemp -d)
  cat >"$stubdir/curl" <<'STUB'
#!/bin/sh
for arg in "$@"; do
  case "$arg" in http*) printf '%s\n' "$arg" >>"$CURL_LOG" ;; esac
done
[ -n "${CURL_SHOULD_FAIL:-}" ] && exit 7
exit 0
STUB
  chmod +x "$stubdir/curl"
  PATH="$stubdir:$PATH"
  export PATH
  CURL_LOG=$(mktemp)
  export CURL_LOG
  unset CURL_SHOULD_FAIL
}

requests() { wc -l <"$CURL_LOG" | tr -d ' '; }

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

# --- arbitration ---------------------------------------------------------

fresh
check 'no sources means off' 'off' "$(winner)"

fresh
"$ai_light" set thinking --source a
check 'a single source wins' 'thinking' "$(winner)"

fresh
"$ai_light" set working --source a
"$ai_light" set waiting --source b
check 'higher urgency wins within a tier' 'waiting' "$(winner)"

fresh
"$ai_light" set thinking --source a
"$ai_light" set error --source b
check 'error outranks everything in its tier' 'error' "$(winner)"

fresh
"$ai_light" set waiting --source a
"$ai_light" set working --source b --priority alert
check 'alert beats a more urgent normal claim' 'working' "$(winner)"

fresh
"$ai_light" set working --source a --priority alert
"$ai_light" set thinking --source b --priority alert
check 'urgency still decides inside the alert tier' 'working' "$(winner)"

fresh
printf 'working 60 normal %s\n' "$(($(date +%s) - 61))" >"$AI_LIGHT_DIR/stale"
check 'expired claims are ignored' 'off' "$(winner)"

fresh
printf 'working 60 normal %s\n' "$(($(date +%s) - 61))" >"$AI_LIGHT_DIR/stale"
"$ai_light" set thinking --source live
check 'an expired claim cannot mask a live one' 'thinking' "$(winner)"

fresh
"$ai_light" set working --source a
"$ai_light" set off --source a
check 'off retires the source' 'off' "$(winner)"

# --- transport -----------------------------------------------------------

fresh
stub_curl
"$ai_light" set working --source a
check 'a new winner is pushed to the light' \
  'http://192.168.2.24/state?value=working' "$(cat "$CURL_LOG")"

fresh
stub_curl
AI_LIGHT_HOST=10.0.0.9 "$ai_light" set ready --source a
check 'AI_LIGHT_HOST overrides the device address' \
  'http://10.0.0.9/state?value=ready' "$(cat "$CURL_LOG")"

fresh
stub_curl
"$ai_light" set working --source a
"$ai_light" set working --source a
"$ai_light" set working --source b
check 'an unchanged winner is not re-pushed' '1' "$(requests)"

fresh
stub_curl
"$ai_light" set working --source a
"$ai_light" set error --source b
check 'a changed winner is pushed again' '2' "$(requests)"

fresh
stub_curl
"$ai_light" set working --source a
"$ai_light" clear --source a
check 'clearing the last source pushes off' \
  'http://192.168.2.24/state?value=off' "$(sed -n 2p "$CURL_LOG")"

fresh
stub_curl
CURL_SHOULD_FAIL=1 "$ai_light" set working --source a
check 'a failed push exits 0 anyway' '0' "$?"
"$ai_light" set working --source a
check 'a failed push is retried on the next call' '2' "$(requests)"

# --- summary -------------------------------------------------------------

if [ "$fails" -gt 0 ]; then
  printf '\n%s test(s) failed\n' "$fails"
  exit 1
fi
printf '\nall tests passed\n'
