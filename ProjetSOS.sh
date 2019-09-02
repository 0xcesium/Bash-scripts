#!/bin/bash

#####################################################################################################################
# Script V1 23/07/2012; V2 25/07/2012; V3 30/07/2012; V4 31/07/2012; V5 31/07/2012
#####################################################################################################################

#Initialisation des variables

REF_appli="/home/projetsos/REF_appli.txt"
Sonde="Q64*******:if12" #Nom de la sonde
Rep_Fileout_temp="/home/projetsos/Fileout_temp/"
Rep_Fileout="/home/projetsos/Fileout/"
Start_date=`date --date='1 days ago' +'%Y-%m-%d %H:%M:%S'`
End_date=`date +'%Y-%m-%d %H:%M:%S'`
fichier_log="/home/projetsos/ScriptSOS.log"
LOGSOS="/home/projetsos/TMPSOS.log"

echo "\\n\\nLancement du programme $0 - `date +'%Y-%m-%d %H:%M:%S'`" >>$fichier_log

#exec 1>>$fichier_log
#exec 2>>&1

# Verification de l'existence du fichier REF_appli
if [ -f $REF_appli ]
then
        echo "le fichier REF_appli EXISTE"
else
        echo "le fichier REF_appli N'EXISTE PAS"
        exit
fi

# Nettoyage du directory de sortie temp
if [ -d $Rep_Fileout_temp ]
then
        rm -rf $Rep_Fileout_temp
fi

mkdir $Rep_Fileout_temp

# Nettoyage du directory de sortie
if [ -d $Rep_Fileout ]
then
        rm -rf $Rep_Fileout
fi

mkdir $Rep_Fileout

# Traitement du fichier Ref
cat $REF_appli | while read appli
do
        echo $appli
        /opt/NetScout/rtm/cde/scripts/conv/cde_all_al_convs.sh -vt "App" -app $appli -st $Start_date -et $End_date -me $Sonde -of csv 
		-fn $appli.csv -fp $Rep_Fileout_temp > $fichier_log
        if [ `grep "Row Count" $fichier_log | wc -l` -gt 0 ]
        then
                tail -n +2 $Rep_Fileout_temp$appli.csv | while read line
                do
                        echo $line | cut -d ',' -f 1 | cut -d ':' -f 4 | cut -d '-' -f 1 >> $Rep_Fileout$appli.csv
                done
        fi
done
