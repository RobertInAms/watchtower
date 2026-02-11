#!/usr/bin/env bash
set -euo pipefail

crond -f &
CRON_PID=$!

# On stop, kill cron and exit immediately
_term() {
  kill -TERM "$CRON_PID" 2>/dev/null || true
  wait "$CRON_PID" 2>/dev/null || true
  exit 0
}
trap _term TERM INT

# Keep PID 1 alive waiting on cron
wait "$CRON_PID"

