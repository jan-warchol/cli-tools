#!/bin/bash

# this is for saving list of my all files, to make recovery easier

date=$(date +"-%Y-%m-%d")
name="filelist"

cd $ALL_MY_STUFF
find | grep -v "\./\.") | sort >> zasoby/$name$date

