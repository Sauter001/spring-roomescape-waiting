#!/bin/bash
set -e

SERVER_HOME="$HOME/spring-roomescape-waiting"
PID_FILE="$SERVER_HOME/app.pid"

if [ ! -d "$SERVER_HOME" ]; then
  git clone https://github.com/Sauter001/spring-roomescape-waiting "$SERVER_HOME"
fi
cd "$SERVER_HOME" || exit
git checkout sauter001
git pull origin sauter001

./gradlew clean
./gradlew bootJar

if [ -f "$PID_FILE" ]; then
  kill "$(cat "$PID_FILE")" 2>/dev/null
fi
cd "$HOME" || exit
nohup java -jar "$SERVER_HOME"/build/libs/spring-roomescape-waiting-0.0.1-SNAPSHOT.jar > output.log /dev/null 2>&1 &
echo $! > "$SERVER_HOME"/app.pid
