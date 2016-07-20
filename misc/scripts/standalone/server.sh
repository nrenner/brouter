#!/bin/sh

# BRouter standalone server
# java -cp brouter.jar btools.brouter.RouteServer <segmentdir> <profile-map> <customprofiledir> <port> <maxthreads>

# maxRunningTime is the request timeout in seconds, set to 0 to disable timeout
JAVA_OPTS="-Xmx128M -Xms128M -Xmn8M -DmaxRunningTime=300"
BROUTER_PATH="$(dirname $0)/.."
CLASSPATH="$BROUTER_PATH"/brouter.jar

java $JAVA_OPTS -cp "$CLASSPATH" btools.server.RouteServer "$BROUTER_PATH"/segments4 "$BROUTER_PATH"/profiles2 "$BROUTER_PATH"/customprofiles 17777 1
