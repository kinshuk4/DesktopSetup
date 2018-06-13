#!/usr/bin/env bash
currDir=$(PWD)

mackup backup
cp -r ~/Library/Preferences/* ~/Lyf/Syncs/Dropbox/AppsMisc/Apps4Mac/Preferences/
cp -r ~/.ssh/* ~/Lyf/Syncs/Dropbox/AppsMisc/Apps4Mac/.ssh/

cd ~/lyf/syncs/Dropbox/AppsMisc/Apps4Mac/conda_envs

source activate carnd-term1
conda env export > carnd-term1.yml

source activate zmen
conda env export > zmen.yml

source activate per2
conda env export > per2.yml


timestamp=`date "+%Y%m%d-%H%M%S"`

cd ~/lyf/syncs/Dropbox/AppsMisc/Apps4Mac/history
cat `printf %s $HISTFILE`  > "history_$timestamp.txt"

cd $currDir

#checklist
#Export Itunes Playlists
#Export developed apps
#Api Keys if Any
#check no change to commit in github
#tabs backup in firefox, opera, chrome