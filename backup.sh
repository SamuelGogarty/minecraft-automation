#!/bin/bash

HOSTNAME=""
TIMESTAMP=$(date +%y-%m-%d-%H)

runbackup(){


echo "screen -S minecraft -p 0 -X stuff "`printf "say "$MESSAGE"\r"`""
screen -S minecraft -p 0 -X stuff "`printf "say "$MESSAGE"\r"`"
echo "screen -S minecraft -p 0 -X stuff "`printf "save-all\r"`""
screen -S minecraft -p 0 -X stuff "`printf "save-all\r"`"
echo "screen -S minecraft -p 0 -X stuff "`printf "save-off\r"`""
screen -S minecraft -p 0 -X stuff "`printf "save-off\r"`"

echo "tar cvf $LD/"$TIMESTAMP".tar "$SAVE_DIRECTORY""
tar cvf $LD/"$TIMESTAMP".tar "$SAVE_DIRECTORY"

echo "screen -S minecraft -p 0 -X stuff "`printf "save-on\r"`""
screen -S minecraft -p 0 -X stuff "`printf "save-on\r"`"

if  [[ -n $DEST_HOST ]];
then 
echo "scp $LD/"$TIMESTAMP".tar "$USER"@"$DEST_HOST":/home/kaiser/minecraft-backups"
fi

}
usage() {
cat << EOF
"$0": What this program does

usage: $0 [OPTIONS]
 -u  specify user in control of minecraft server
 -h  dest hostfor backup
 -m  Prints shutdown message in-game
 -d  Specify local directory	
 -l  Choose LD
 -k  Use ansible defaults
EOF

exit 1

#mkdir -p /home/minecraft/minecraft-server/backups

}

DEFAULT_PATH () {
MESSAGE="saving world..."
SAVE_DIRECTORY=/home/minecraft/minecraft-server/world
LD=/home/minecraft/minecraft-server/backups
USER=minecraft

runbackup
}



if [[ -z "$@" ]]; then usage
fi

USER=minecraft

while getopts "m:ks:d:h:c:a:e:l:u:" OPTION
do
        case $OPTION in
                
		u ) USER="$OPTARG" ;;        
                m ) MESSAGE="$OPTARG" ;;
		k ) DEFAULT_PATH ;;
                d ) SAVE_DIRECTORY="$OPTARG" ;;
                s ) SOURCE_DIRECTORY="$OPTARG" ;;
                h ) DEST_HOST="$OPTARG";;
                l ) LD="$OPTARG";;
                e ) excludelist="$OPTARG";;
                \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
        esac
done

runbackup


