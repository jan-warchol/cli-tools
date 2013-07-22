#!/bin/bash

# this is for saving list of my all files, to make recovery easier

date=$(date +"-%Y-%m-%d")
name="filelist"

cd ~/
find | sort >> Desktop/moje/$name$date

