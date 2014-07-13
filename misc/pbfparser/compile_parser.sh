#!/bin/bash

OSMOSIS_CLASSPATH=~/opt/osmosis/lib/default/protobuf-java-2.4.1.jar:~/opt/osmosis/lib/default/osmosis-osm-binary-0.43.1.jar
CLASSPATH=$OSMOSIS_CLASSPATH:../../brouter-map-creator/target/brouter-map-creator-0.9.9-SNAPSHOT.jar:../../brouter-util/target/brouter-util-0.9.9-SNAPSHOT.jar

javac -d . -cp $CLASSPATH BPbfFieldDecoder.java BPbfBlobDecoder.java OsmParser.java
