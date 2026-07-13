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

# Install a fake curl on PATH for the WHOLE suite, before the first test runs.
# This has to happen up front: `set` and `clear` push to the device, so a stub
# installed halfway down the file means every test above it drives the real
# light on the LAN and eats a network timeout per call.
#
# It logs each request's URL, and exits 22 (curl's HTTP-error code) when
# CURL_SHOULD_FAIL is set, so the rejected-update path is exercised too.
#
# When CURL_SLOW is set it also dawdles, and records how many requests were in
# flight at once — which is how the concurrency test checks that the lock really
# serialises pushes. (Racing two callers and hoping to observe a stale write is
# not a test; the interleaving that loses the race only happens sometimes. The
# number of simultaneous requests, by contrast, is decided by the lock and not
# by luck.)
stubdir=$(mktemp -d)
cat >"$stubdir/curl" <<'STUB'
#!/bin/sh
for arg in "$@"; do
  case "$arg" in http*) printf '%s\n' "$arg" >>"$CURL_LOG" ;; esac
done
if [ -n "${CURL_SLOW:-}" ]; then
  mkdir -p "$CURL_INFLIGHT" 2>/dev/null
  touch "$CURL_INFLIGHT/$$"
  ls "$CURL_INFLIGHT" | wc -l | tr -d ' ' >>"$CURL_PEAK"
  sleep 0.3
  rm -f "$CURL_INFLIGHT/$$"
fi
[ -n "${CURL_SHOULD_FAIL:-}" ] && exit 22
exit 0
STUB
chmod +x "$stubdir/curl"
PATH="$stubdir:$PATH"
export PATH
CURL_LOG=$(mktemp)
export CURL_LOG

fresh() { # start a test with an empty state dir and a clean request log
  AI_LIGHT_DIR=$(mktemp -d)
  export AI_LIGHT_DIR
  : >"$CURL_LOG"
  unset CURL_SHOULD_FAIL
  unset CURL_SLOW
}

winner() { "$ai_light" status | sed -n 's/^winner: //p'; }

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
"$ai_light" set working --source a
check 'a new winner is pushed to the light' \
  'http://192.168.2.24/state?value=working' "$(cat "$CURL_LOG")"

fresh
AI_LIGHT_HOST=10.0.0.9 "$ai_light" set ready --source a
check 'AI_LIGHT_HOST overrides the device address' \
  'http://10.0.0.9/state?value=ready' "$(cat "$CURL_LOG")"

fresh
"$ai_light" set working --source a
"$ai_light" set working --source a
"$ai_light" set working --source b
check 'an unchanged winner is not re-pushed' '1' "$(requests)"

fresh
"$ai_light" set working --source a
"$ai_light" set error --source b
check 'a changed winner is pushed again' '2' "$(requests)"

fresh
"$ai_light" set working --source a
"$ai_light" clear --source a
check 'clearing the last source pushes off' \
  'http://192.168.2.24/state?value=off' "$(sed -n 2p "$CURL_LOG")"

fresh
CURL_SHOULD_FAIL=1 "$ai_light" set working --source a
check 'a failed push exits 0 anyway' '0' "$?"
"$ai_light" set working --source a
check 'a failed push is retried on the next call' '2' "$(requests)"

# --- ttl validation ------------------------------------------------------

fresh
"$ai_light" set working --source a --ttl nope 2>/dev/null
check 'a non-numeric ttl is a usage error' '2' "$?"
check 'a non-numeric ttl writes no claim' 'gone' \
  "$([ -e "$AI_LIGHT_DIR/a" ] && echo present || echo gone)"

fresh
"$ai_light" set working --source a --ttl 0 2>/dev/null
check 'a zero ttl is a usage error' '2' "$?"

fresh
"$ai_light" set working --source a --ttl -5 2>/dev/null
check 'a negative ttl is a usage error' '2' "$?"

# --- rejected updates ----------------------------------------------------

# curl exits 0 on a 4xx/5xx body unless --fail is passed, so without it a
# rejected update would be recorded in .last as applied and never retried.
fresh
CURL_SHOULD_FAIL=1 "$ai_light" set working --source a
check 'a rejected update is not recorded in .last' 'absent' \
  "$([ -s "$AI_LIGHT_DIR/.last" ] && echo present || echo absent)"

# --- concurrency ---------------------------------------------------------

# Unsynchronised writers let a stale winner land on the device after a newer one,
# and shredded .last into values that are not states at all (observed: "errorng").
# The lock's guarantee is mutual exclusion, so assert exactly that: no two pushes
# may be in flight at once. Without the lock this peaks at the number of callers.
fresh
CURL_INFLIGHT=$(mktemp -d)
CURL_PEAK=$(mktemp)
rmdir "$CURL_INFLIGHT"
export CURL_INFLIGHT CURL_PEAK CURL_SLOW=1

i=0
while [ "$i" -lt 6 ]; do
  "$ai_light" set error --source "s$i" &
  i=$((i + 1))
done
wait
unset CURL_SLOW

check 'the lock serialises pushes (never two in flight)' '1' \
  "$(sort -rn "$CURL_PEAK" | head -1)"
check 'concurrent pushes leave .last a real state' 'error' \
  "$(cat "$AI_LIGHT_DIR/.last" 2>/dev/null)"
check 'concurrent pushes agree with the arbiter' 'error' "$(winner)"

# --- summary -------------------------------------------------------------

if [ "$fails" -gt 0 ]; then
  printf '\n%s test(s) failed\n' "$fails"
  exit 1
fi
printf '\nall tests passed\n'
