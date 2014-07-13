#!/bin/bash
set -e

#PBF=planet-latest.osm.pbf
PBF=osm/tuebingen-regbez-latest.osm.pbf

#wget -N http://planet.openstreetmap.org/pbf/$PBF

SRTM=../srtm/arc-ascii
BROUTER=../../..
JAVA=/usr/lib/jvm/java-1.7.0-openjdk-amd64/bin/java
CP=$BROUTER/brouter-map-creator/target/brouter-map-creator-0.9.9-SNAPSHOT.jar:$BROUTER/brouter-expressions/target/brouter-expressions-0.9.9-SNAPSHOT.jar:$BROUTER/brouter-util/target/brouter-util-0.9.9-SNAPSHOT.jar
CLASSPATH_OSMOSIS=~/opt/osmosis/lib/default/protobuf-java-2.4.1.jar:~/opt/osmosis/lib/default/osmosis-osm-binary-0.43.1.jar
CP_PBF=$CLASSPATH_OSMOSIS:$BROUTER/misc/pbfparser:${CP}
#OPTS="-Ddeletetmpfiles=true -DuseDenseMaps=true"
OPTS="-Ddeletetmpfiles=false -DuseDenseMaps=true"

PROFILES=$BROUTER/misc/profiles2

mkdir -p tmp
cd tmp
mkdir -p nodetiles
$JAVA -Xmx256m -Xms256m -Xmn32m -cp ${CP_PBF} btools.mapcreator.OsmCutter $PROFILES/lookups.dat nodetiles ways.dat cycleways.dat ../$PBF

mkdir -p ftiles
$JAVA -Xmx512M -Xms512M -Xmn32M -cp ${CP} ${OPTS} btools.mapcreator.NodeFilter nodetiles ways.dat ftiles

mkdir -p waytiles
$JAVA -Xmx2600M -Xms2600M -Xmn32M -cp ${CP} ${OPTS} btools.mapcreator.WayCutter ftiles ways.dat waytiles cycleways.dat

mkdir -p waytiles55
$JAVA -Xmx2600M -Xms2600M -Xmn32M -cp ${CP} ${OPTS} btools.mapcreator.WayCutter5 ftiles waytiles waytiles55 bordernids.dat

mkdir -p nodes55
$JAVA -Xmx128M -Xms128M -Xmn32M -cp ${CP} ${OPTS} btools.mapcreator.NodeCutter ftiles nodes55

mkdir -p unodes55
$JAVA -Xmx2600M -Xms2600M -Xmn32M -cp ${CP} ${OPTS} btools.mapcreator.PosUnifier nodes55 unodes55 bordernids.dat bordernodes.dat $SRTM

mkdir -p segments
mkdir -p segments/carsubset

$JAVA -Xmx2600M -Xms2600M -Xmn32M -cp ${CP} ${OPTS} btools.mapcreator.WayLinker unodes55 waytiles55 bordernodes.dat $PROFILES/lookups.dat $PROFILES/all.brf segments rd5

cd ..
#rm -rf segments
#mv tmp/segments segments
#rm -rf tmp
