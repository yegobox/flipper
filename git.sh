#!/bin/bash

cd ./open-sources && cd cli_dialog &&  git checkout master  && git add .   &&  git commit -am "clean-up" && git push origin master
cd .. && cd dart_console &&  git checkout main  && git add .   && git commit -am "clean-up" && git push origin main
cd .. && cd flutter.widgets &&  git checkout main  && git add . && git commit -am "clean-up" && git push origin main
cd .. && cd qr.flutter &&  git checkout main  && git add . && git commit -am "clean-up" && git push origin main
cd .. && cd receipt &&  git checkout main  && git add .   && git commit -am "clean-up" && git push origin main
cd .. && cd kds &&  git checkout master  && git add . && git commit -am "clean-up" && git push origin master
cd .. && cd qr_code_scanner &&  git checkout master  && git add . && git commit -am "clean-up" && git push origin master

cd .. && cd flutter_list_drag_and_drop && git stash &&  git checkout main  && git add .  && git commit -am "clean-up" && git push origin main


cd .. && cd flutter_slidable && git stash &&  git checkout dev  && git add .  && git commit -am "clean-up" && git push origin dev
cd .. && cd flutter_datetime_picker &&  git checkout master  && git add .  && git commit -am "clean-up" && git push origin master
cd .. && cd flutter_luban && git stash   &&  git checkout master  && git add .  && git commit -am "clean-up" && git push origin master
cd .. && cd flipper-turbo  &&  git checkout uat  && git add .  && git commit -am "clean-up" && git push origin uat
cd .. && cd dart_pdf  &&  git checkout fix  && git add .  && git commit -am "clean-up" && git push origin fix
cd .. && cd form_bloc    &&  git checkout master  && git add .  && git commit -am "clean-up" && git push origin master
