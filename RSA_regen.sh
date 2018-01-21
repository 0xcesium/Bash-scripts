#!/bin/bash
# - V3:27/05/2016
#
# Variable fondamentale : entrée
#
toSupp=$1
#
lKH=~/.ssh/known_hosts
nblKH=`wc -l $lKH | cut -d ' ' -f 1`
#
# Fonctions :
#
# usage ()      : Descriptif du script
# traitement()  : Suppression / ajout d'une clef chiffrée privée R.S.A.
#
usage() {
#
cat <<EOT

         ___
        /_!_\ : A UTILISER AVEC PRECAUTION.

        Raison d'être:

    -   Ce script permet de mettre à jour une clef RSA redondante dans
        le fichier '~/.ssh/known_hosts'.
    -   Cette clef correspond au fingerprint (clef privée issue du chiffrement asymétrique RSA) d'un
        équipement distant permettant une synchronisation unique et sécurisée
        entre un utilisateur et ledit équipement.
    -   Les clefs sont toujours chiffrées avec l'algorithme R.S.A..
    -   SSH ne peut effectuer de connexion si un nettoyage n'a pas été fait.

        Usage:

        1)      Après avoir tenté une connexion à l'équipement, une érreur
                survient et affiche la ligne où la redondance de clef a été reconnue,
                toujours dans le fichier '~/.ssh/known_hosts'.
                Noter cette ligne.
        2)      Utiliser ce numéro de ligne comme argument à ce script.

        Exemple:

        1       $ ssh <username>@<equipement>
        2       $ rebond@XROLMWBIMFQ:~$ ssh user@CLM-0288
                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
                Someone could be eavesdropping on you right now (man-in-the-middle attack)!
                It is also possible that a host key has just been changed.
                The fingerprint for the RSA key sent by the remote host is
                5a:91:34:63:54:a0:90:18:ed:18:24:ff:4a:3d:63:15.
                Please contact your system administrator.
                Add correct host key in /home/rebond/.ssh/known_hosts to get rid of this message
        >>>>>>  Offending RSA key in /home/rebond/.ssh/known_hosts:1418
                RSA host key for clm-0288 has changed and you have requested strict checking.
                Host key verification failed.
        3       $ regulrsa 1418
        4       $ La ligne a été supprimée.
        5       $ --> Connexion à l'équipement :
        6       $ ------------------------------
        7       $ Equipement (nom d'hote ou IP) :
        8       $ [...]
        9       $ Login :
        10      $ [...]

____________________________________________________________________________________________________

        Options:

        $ regulrsa [-h | --help]                Imprime cette description.
        ---
        $ regulrsa <num-ligne>                  Traite la ligne indiquée.


EOT
#
}
#
traitement() {
# Test si le numéro de ligne indiqué ne dépasse pas le total de lignes du fichier known_hosts
        if [ $toSupp -gt $nblKH ]
        then
                 printf "\33[44mLa ligne n'a pas été trouvée.\33[0m\n"
                 exit 0
        else
# Suppression de la ligne indiquée
                sed -i "$toSuppd" $lKH
                echo -e "\033[41mLa ligne a été supprimée.\033[0m"
# Nouvelle connexion SSH à l'équipement pour éditer le fichier known_hosts
                echo -e "--> Connexion à l'équipement : \n------------------------------"
                echo "Equipement (nom d'hote ou IP) : "; read equipement
                echo "Login : "; read login
                sleep 1
                echo -e "(i) Faites 'yes' puis 'yes' afin de renouveller les clefs dans le fichier contenair.\n"
                sleep 1
                ssh "$login"@"$equipement"
        fi
#
}
#
[ $# -eq 0 -o $# -gt 1 ] && set -- '--help'
#
case "$1" in

        -h|--help)
                usage;
                exit 0
                ;;

        [1-9] | [0-9][0-9] | [0-9][0-9][0-9] | [0-9][0-9][0-9][0-9])
                traitement;
                exit 0
                ;;

        *)
                printf "\33[44m'$1': Option inconnue.\33[0m" >&2
                usage >&2
                exit 0
                ;;

esac
