#!/bin/bash 

# Script der Community Freifunk-Donau-Ries.de
# zur Erstellung der Firmware-Images
# für mehrere Hardware-Architekturen
# für mehrere Domänen
# 
###############################################################################################
# Buildscript zur Erstellung der Images
# 
# Dieses Script holt die passende Gluon-Version von GitHub und überträgt die Gluon-Konfiguration
#
###############################################################################################
 
# Bei Ausführung auf dem Buildserver ist die Variable $WORKSPACE gesetzt 
# andernfalls wird das aktuelle Verzeichnis verwendet  

if [ "x$WORKSPACE" = "x" ]; then
        WORKSPACE=`pwd`
fi

# Konstanten-Belegungen nachvolgender Variablen
SITE_REPO=""
GLUON_COMMIT="v2016.1.4"
BUILD_NUMBER="0.9.9"
BUILD_STRING=$GLUON_COMMIT"+"$BUILD_NUMBER
#echo $BUILD_STRING
DEV_CHAN="stable"
#DEV-CHAN="experiemtal"
TASKANZAHL="-j5"
#TASKANZAHL="-j1"
VERBOSITY="V=s"
#VERBOSITY=""

#Zu bauende  Domanen
#nach Domaenenliste
#https://docs.google.com/spreadsheets/d/1KiK__g-mgvkGOdIDcqCmA2Km_lTHLivv-61mxl2TuKM/edit?usp=sharing

#DOM01="Domaene01"
#DOM02="Domaene02"
DOM03="Domaene03"
#DOM04="Domaene04"
#DOM05="Domaene05"
#DOM06="Domaene06"
#DOM07="Domaene07"
#DOM08="Domaene08"
#DOM09="Domaene09"
#DOM10="Domaene10"
#DOM11="Domaene11"

#zu bauende Arhcitekturen
ARCH1="ar71xx-generic"
#ARCH2="ar71xx-nand"
#ARCH3="mpc85xx-generic"
#ARCH4="x86-generic"
#ARCH5="x86-kvm_guest"
#ARCH6="x86-64"
#ARCH7="x86-xen_domu"
#ARCH8=""

# Verzeichnis für Gluon-Repo erstellen und initialisieren

if [ ! -d "$WORKSPACE/gluon" ]; then
#  git clone https://github.com/freifunk-gluon/gluon.git $WORKSPACE/gluon -b $GLUON_COMMIT
  git clone https://github.com/freifunk-gluon/gluon.git $WORKSPACE/gluon 
fi

# Gluon Repo aktualisieren 

cd $WORKSPACE/gluon
git fetch 
git checkout $GLUON_COMMIT

# Dateien in das Gluon-Repo kopieren
# In der site.conf werden hierbei Umgebungsvariablen durch die aktuellen Werte ersetzt

if [ -d $WORKSPACE/gluon/site  ]; then
  rm -r $WORKSPACE/gluon/site
fi

mkdir $WORKSPACE/gluon/site 

for Domaene in $DOM01 $DOM02 $DOM03 $DOM04 $DOM05 $DOM06 $DOM07 $DOM08 $DOM09 $DOM10 $DOM11 
  do
    # git checkout $Domaene 
    # mkdir -p /var/www/html/$3/versions/v$2
    # letzterBefehlErfolgreich;
    # cd $WORKSPACE
    # sh ./prepare.sh $1
    # letzterBefehlErfolgreich;

   for Arch in $ARCH1 $ARCH2 $ARCH3 $ARCH4 $ARCH5 $ARCH6 $ARCH7 $ARCH8
      do
#make update GLUON_RELEASE=$1+$2 GLUON_TARGET=$3 $4 $5 $6 $7 $8 $9
#make clean GLUON_RELEASE=$1+$2 GLUON_TARGET=$3 $4 $5 $6 $7 $8 $9

#make GLUON_RELEASE=$1+$2 GLUON_TARGET=$3 GLUON_BRANCH=stable $4 $5 $6 $7 $8 $9   

cd $WORKSPACE
sh ./compile.sh $1 $2 ar71xx-generic GLUON_IMAGEDIR=/var/www/html/$Domaene/versions/v$BUILD_NUMBER $4 $5 $6 $7 $8 $9


     echo $Domaene $Arch
    done
done

echo site-builder

