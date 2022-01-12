#!/bin/bash 

#vars
FUD="/home/foundry/foundryuserdata/"
BACKUPS="/home/foundry/fvtt-files/backups"

#stop foundry
pm2 stop foundry

#tar backup
tar -czvf $BACKUPS/FUD-"$(date +\%Y-\%m-\%d)".tar.gz $FUD
CURRENT="$BACKUPS/FUD-"$(date +\%Y-\%m-\%d)".tar.gz"

#cp to s3
aws s3 cp $CURRENT s3://foundry-cts-vtt-assets/backups/

#delete oldcurrent, move new current 
rm $BACKUPS/current/*
mv $CURRENT $BACKUPS/current/

#start foundry again
pm2 start foundry