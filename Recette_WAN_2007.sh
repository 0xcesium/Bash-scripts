#!/bin/bash
# - V3:25/05/2016
#
chmod +x */Recette_WAN_2007_1.sh
echo "Saisissez l'adresse IP:"
read IP
#
echo "Test du PING:"
ping -c 5 $IP
if [ $? = 0 ]
then
        printf '\033[44m PING OK !\033[0m\n'
        echo "Test SNMP:"
        snmpget -v2c -c CLIENT $IP system.sysName.0
        if [ $? = 0 ]
        then
                printf '\033[44m SNMP OK !\033[0m\n'

                echo "Test TELNET:"
                (echo open $IP
                sleep 2
                echo AdmPR
                sleep 2
                echo otarbsrp
                sleep 2
                echo sh ip int brief
                echo " "
                sleep 2
                echo ping ip
                echo 10.6.64.4
                echo " "
                echo " "
                echo " "
                echo y
                echo $IP
                echo " "
                echo " "
                echo " "
                echo " "
                echo " "
                echo " "

                sleep 5

                echo " "
                echo exit

                sleep 5
                ) | telnet

        else
                printf '\033[41m SNMP NOK !, fin des tests\033[0m\n'
        fi
else
        printf '\033[41m PING NOK !, fin des tests\033[0m\n'
fi
