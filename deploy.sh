#!/bin/bash
set -e

SERVER_HOME="$HOME/spring-roomescape-waiting"
PID_FILE="$SERVER_HOME/app.pid"

if [ ! -f ".env" ]; then
  echo ".env file required"
  exit
fi

if [ ! -d "$SERVER_HOME" ]; then
  echo "[git clone]"
  git clone https://github.com/Sauter001/spring-roomescape-waiting "$SERVER_HOME"
fi
cd "$SERVER_HOME" || exit
git checkout sauter001
git pull origin sauter001
cp ./deploy.sh ~

./gradlew clean
./gradlew bootJar

echo "[Terminate running spring process]"
if [ -f "$PID_FILE" ]; then
  kill "$(cat "$PID_FILE")" || true
fi

echo "[Rebooting...]"
cd "$HOME" || exit
mkdir -p ~/logs/
nohup java -jar "$SERVER_HOME"/build/libs/spring-roomescape-waiting-0.0.1-SNAPSHOT.jar > ~/logs/output.log 2>&1 &
echo $! > "$SERVER_HOME"/app.pid
