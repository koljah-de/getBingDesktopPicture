#!/bin/bash
# Get the Bing Desktop daily picture and set it as background.

#If bing.com is not reachable, exit with failure
if [ ! $(curl -s --head www.bing.com | head -n1 | cut -d ' ' -f2) ]; then
    exit 1
fi

#Create the required folder structure in the home directory 
mkdir -v -p ~/Pictures/bing
cd ~/Pictures/bing

#Get the Bing Desktop picture
if [ $(curl -s --head "http://az517271.vo.msecnd.net/TodayImageService.svc/HPImageArchive?mkt=en-ww&idx=0" | head -n1 | cut -d ' ' -f2) -eq 200 ]; then
    varPicURL="$(curl -s "http://az517271.vo.msecnd.net/TodayImageService.svc/HPImageArchive?mkt=en-ww&idx=0" | tr "<" "\n" | grep fullImageUrl | tr ">" "\n" | tr ' ' "\n" | grep jpg | cut -d "_" -f1,2)_1920x1080.jpg"
    varPicName="$(curl -s "http://az517271.vo.msecnd.net/TodayImageService.svc/HPImageArchive?mkt=en-ww&idx=0" | tr "<" "\n" | grep fullImageUrl | tr ">" "\n" | tr ' ' "\n" | tr "/" "\n" | grep jpg | cut -d "_" -f1,2)_1920x1080.jpg"

    if [[ ! "$varPicName" == "_1920x1080.jpg" && ! -f $varPicName ]]; then
        if [ $(curl -s --head $varPicURL | head -n1 | cut -d ' ' -f2) -eq 200 ]; then
            wget -nv $varPicURL
        fi
    fi

    #Set background image
    if [[ ! "$varPicName" == "_1920x1080.jpg" && -f $varPicName ]]; then
        gsettings set org.cinnamon.desktop.background picture-uri  "file://$(pwd)/$varPicName"
    fi
fi

#Get the past pictures
if [ $(curl -s --head "http://az517271.vo.msecnd.net/TodayImageService.svc/HPImageArchive?mkt=en-ww&idx=0" | head -n1 | cut -d ' ' -f2) -eq 200 ]; then
    for j in $(seq 999); do
        varPicURL="$(curl -s "http://az517271.vo.msecnd.net/TodayImageService.svc/HPImageArchive?mkt=en-ww&idx=${j}" | tr "<" "\n" | grep fullImageUrl | tr ">" "\n" | tr ' ' "\n" | grep jpg | cut -d "_" -f1,2)_1920x1080.jpg"
        varPicName="$(curl -s "http://az517271.vo.msecnd.net/TodayImageService.svc/HPImageArchive?mkt=en-ww&idx=${j}" | tr "<" "\n" | grep fullImageUrl | tr ">" "\n" | tr ' ' "\n" | tr "/" "\n" | grep jpg | cut -d "_" -f1,2)_1920x1080.jpg"
        if [[ "$varPicPre" == "$varPicName" || "$varPicName" == "_1920x1080.jpg" ]]; then
            break
        fi
        if [[ ! "$varPicName" == "_1920x1080.jpg" && ! -f $varPicName ]]; then
            if [ $(curl -s --head $varPicURL | head -n1 | cut -d ' ' -f2) -eq 200 ]; then
                wget -nv $varPicURL
            fi
        fi
        varPicPre=$varPicName
    done
fi

exit 0