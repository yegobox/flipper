#!/bin/bash


# echo -e "\033[32mPulling in the latest changes...\033[0m"
echo -e "\033[32mPulling in the latest changes...\033[0m"
pv -q -B "Fetching..." -l 100

cd ./open-sources && cd flutter.widgets && git checkout main && git pull origin main
cd .. && cd qr.flutter && git checkout main && git pull origin main
cd .. && cd receipt && git checkout main && git pull origin main


cd .. && cd flutter_slidable && git stash && git checkout dev && git pull origin dev
# cd .. && cd flipper-turbo && git checkout uat && git pull origin uat
cd .. && cd form_bloc && git stash && git checkout master && git pull origin master
