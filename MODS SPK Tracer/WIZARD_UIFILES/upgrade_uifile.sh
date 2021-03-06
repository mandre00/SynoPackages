#!/bin/sh
exec 4<&1
exec 5<&2

exec 2>&1 
exec 1>>/var/log/SpkTracer.log

echo "<center><pre>********************************"
echo "***                          ***"
echo "***   UPGRADE INSTALLATION   ***"
echo "***                          ***"
echo "********************************</pre></center>"

NAME=`basename $0`

echo "<b>'$NAME'</b> called at $(date)" 
echo ""

echo ""
declare -xp | grep " SYNOPKG" | sed 's/declare -x //'
echo ""
declare -xp | grep " SYNO" | grep -v " SYNOPKG" | sed 's/declare -x //'
echo ""

: '
declare -xp | grep -v " SYNO" | sed 's/declare -x //'
echo ""
'

WIZARD=$(cat << 'EOF'
[{
    "step_title": "'#NAME' Wizard Tracer for #MODEL",
    "items": [{}]
}]
EOF
)

WIZARD="${WIZARD/\#NAME/$NAME}"
WIZARD="${WIZARD//\\/\\\\}"
WIZARD="${WIZARD//\"/\\\"}"

SCRIPT=$(cat << 'EOF'
<?php
$ini_array = parse_ini_file("/etc.defaults/synoinfo.conf");
$name=$ini_array["upnpmodelname"];
echo str_replace("#MODEL", "$name", "#WIZARD");
?>
EOF
)

SCRIPT="${SCRIPT/\#WIZARD/$WIZARD}"

echo $SCRIPT
echo ""

echo $SCRIPT > /tmp/wizard.php
php -n /tmp/wizard.php > $SYNOPKG_TEMP_LOGFILE
rm /tmp/wizard.php


echo "-------------------------------------------------------------"
exec 1<&4
exec 2<&5

exit 0