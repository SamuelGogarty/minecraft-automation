#!/bin/bash

HOSTNAME=""
TIMESTAMP=$(date +%y-%m-%d-%H)

runbackup(){
screen -S minecraft -p 0 -X stuff "`printf "say saving-world\r"`"; #sleep 5
screen -S minecraft -p 0 -X stuff "`printf "save-all\r"`"; #sleep 5
screen -S minecraft -p 0 -X stuff "`printf "save-off\r"`"; #sleep 5
tar cvf /root/minecraft-backups/foo"$TIMESTAMP".tar /root/minecraft/world/
screen -S minecraft -p 0 -X stuff "`printf "save-on\r"`"; #sleep 5



}
usage() {
cat << EOF
"$0": What this program does

usage: $0 [OPTIONS]
 -h  Show this message
 -t  test but do not take any action if called alone, take an inventory for each client to the log dir and output some statistics.
 -s  Take a snapshot of all attached volumes for all detected clients
 -v  Verbose Mode, now with even more output! will list a warning if attached volumes do not have at least X snapshots
 -d  Delete all but X most recent snapshots for each volume listed by above action
 -l  Choose log name
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




if [[ -z "$@" ]]; then usage
fi

while getopts "tl:k:sd:hvc:a:e:" OPTION
do
        case $OPTION in
                t ) test=true;;
                l ) LOG="$OPTARG" ;;
                k ) KEYDIR="$OPTARG" ;;
                s ) snapshot=true ;;
                d ) numbertokeep="$OPTARG"
                del=true 
                ;;
                v) verbose=true;;
                c ) client="$OPTARG";;
                a ) azones="$OPTARG";;
                e ) excludelist="$OPTARG";;
                h ) usage; exit;;
                \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
        esac
done

runbackup

scp /root/minecraft-backups/foo"$TIMESTAMP".tar kaiser@192.168.0.205:/home/kaiser/minecraft-backups
