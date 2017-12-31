#!/usr/local/bin/bash

HOSTNAME=""
TIMESTAMP=$(date +%y-%m-%d-%H)

runbackup(){


echo "screen -S minecraft -p 0 -X stuff "`printf "say "$MESSAGE"\r"`""
echo "screen -S minecraft -p 0 -X stuff "\`printf "save-all\r"\`""
echo "screen -S minecraft -p 0 -X stuff "`printf "save-off\r"`""

echo "tar cvf $LD/"$TIMESTAMP".tar "$LOCAL_DIRECTORY""

echo "screen -S minecraft -p 0 -X stuff "`printf "save-on\r"`""

if  [[ -n $DEST_HOST ]];
then 
echo "scp $LD/"$TIMESTAMP".tar kaiser@"$DEST_HOST":/home/kaiser/minecraft-backups"
fi

}
usage() {
cat << EOF
"$0": What this program does

usage: $0 [OPTIONS]
 -h  dest hostfor backup
 -m  Prints shutdown message in-game
 -s  Take a snapshot of all attached volumes for all detected clients
 -v  Verbose Mode, now with even more output! will list a warning if attached volumes do not have at least X snapshots
 -d  Specify local directory
 -l  Choose LD
 -k  Choose key dir
 -c  Specify which detected accounts you with to run the script against. 
 -a  Specify which avaliablility zones you wish to run the script against.
 -e  Specify a file with a new line delimited list of instances whose volumes should be exclude from being snapshotted
Example Snapshot mode  :$0  -s -l $LOGDIR -k $KEYDIR
Example Delete mode saving the 15 most recent snapshots  :$0  -d 15
Example Test keeping 15 snapshots for client enovance verbose mode: $0 -t -d 15 -c enovance -v
Example Test Snapshoting all attached volumes except those listed in /tmp/exclude: $0 -t -s -e /tmp/exclude
EOF

exit 1

}

DEFAULT_PATH () {
MESSAGE=
LOCAL_DIRECTORY=
LD=

runbackup
}



if [[ -z "$@" ]]; then usage
fi

while getopts "m:k:s:d:h:c:a:e:l:" OPTION
do
        case $OPTION in
               
                m ) MESSAGE="$OPTARG" ;;
		k ) DEFAULT_PATH ;;
                d ) LOCAL_DIRECTORY="$OPTARG" ;;
                s ) SOURCE_DIRECTORY="$OPTARG" ;;
                h ) DEST_HOST="$OPTARG";;
                l ) LD="$OPTARG";;
                e ) excludelist="$OPTARG";;
                \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
        esac
done

runbackup


