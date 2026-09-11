#!/usr/bin/env bash
# Lance le frontend (ng serve) et le backend (node app.js) en dev, en arriere-plan.
# Usage: ./dev-start.sh [start|stop|status]

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
LOG_DIR="$ROOT_DIR/.dev-logs"
FRONTEND_LOG="$LOG_DIR/frontend.log"
BACKEND_LOG="$LOG_DIR/backend.log"
FRONTEND_PID_FILE="$LOG_DIR/frontend.pid"
BACKEND_PID_FILE="$LOG_DIR/backend.pid"

mkdir -p "$LOG_DIR"

is_running() {
  local pid_file="$1"
  [[ -f "$pid_file" ]] && kill -0 "$(cat "$pid_file")" 2>/dev/null
}

start() {
  if is_running "$FRONTEND_PID_FILE"; then
    echo "Frontend deja lance (pid $(cat "$FRONTEND_PID_FILE"))"
  else
    echo "Generation des traductions i18n (xlf -> json)..."
    (cd "$ROOT_DIR" && node src/postbuild.mjs > "$LOG_DIR/postbuild.log" 2>&1) || true

    echo "Demarrage du frontend (ng serve, port 4310)..."
    (cd "$ROOT_DIR" && nohup npx ng serve --host 0.0.0.0 --port 4310 --disable-host-check > "$FRONTEND_LOG" 2>&1 &
     echo $! > "$FRONTEND_PID_FILE")
  fi

  if is_running "$BACKEND_PID_FILE"; then
    echo "Backend deja lance (pid $(cat "$BACKEND_PID_FILE"))"
  else
    echo "Demarrage du backend (node app.js, mode dev)..."
    (cd "$BACKEND_DIR" && YTDL_MODE=dev nohup node app.js > "$BACKEND_LOG" 2>&1 &
     echo $! > "$BACKEND_PID_FILE")
  fi

  echo "Logs: $FRONTEND_LOG / $BACKEND_LOG"
  echo "Frontend: http://192.168.32.202:4310/"
}

stop() {
  for pid_file in "$FRONTEND_PID_FILE" "$BACKEND_PID_FILE"; do
    if is_running "$pid_file"; then
      kill "$(cat "$pid_file")"
      rm -f "$pid_file"
    fi
  done
  echo "Serveurs arretes."
}

status() {
  if is_running "$FRONTEND_PID_FILE"; then
    echo "Frontend: UP (pid $(cat "$FRONTEND_PID_FILE"))"
  else
    echo "Frontend: DOWN"
  fi
  if is_running "$BACKEND_PID_FILE"; then
    echo "Backend: UP (pid $(cat "$BACKEND_PID_FILE"))"
  else
    echo "Backend: DOWN"
  fi
}

case "${1:-start}" in
  start) start ;;
  stop) stop ;;
  status) status ;;
  *) echo "Usage: $0 [start|stop|status]"; exit 1 ;;
esac
