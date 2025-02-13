#!/usr/bin/env bash

set -eo pipefail

# set up EULA:
if [ "$EULA" != "true" ]; then
  echo "Set EULA to true to accept the Minecraft EULA."
  exit 1
fi

echo "eula=$EULA" > eula.txt
if [ ! -f "server.properties" ]; then
  cp /server/server.properties server.properties

  # set up rcon:
  PASSWORD=$(openssl rand -hex 16)
  echo "rcon.password=$PASSWORD" >> server.properties
fi

# load optimized java args
if [ -z "$JAVA_ARGS" ]; then
  # aikar defaults (Server G1GC)
  if [ "$JAVA_VERSION" -ge 11 ]; then
    JAVA_ARGS="-XX:+UseG1GC -XX:MaxGCPauseMillis=130 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=28 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=20 -XX:G1MixedGCCountTarget=3 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=0 -XX:SurvivorRatio=32 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5"
    if [ "$JAVA_VERSION" -lt 21 ]; then
      JAVA_ARGS="$JAVA_ARGS -XX:G1ConcRSHotCardLimit=16"
    fi
    if [ "$JAVA_VERSION" -lt 20 ]; then
      JAVA_ARGS="$JAVA_ARGS -XX:G1ConcRefinementServiceIntervalMillis=150"
    fi
  fi
fi

# extra flags (memory)
if [ -z "$JAVA_ARGS_EXTRA" ]; then
  JAVA_ARGS="$JAVA_ARGS_EXTRA $JAVA_ARGS"
else
  JAVA_ARGS="-Xms256M -Xmx4G $JAVA_ARGS"
fi

grep "rcon.password" server.properties || true

exec java $JAVA_ARGS -jar /server/server.jar nogui "${@}"
