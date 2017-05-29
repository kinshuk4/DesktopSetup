REPONAME="AndroidCapstone"
mv author_fixer.sh ../$REPONAME && cd ../$REPONAME
./author_fixer.sh && git push --force --tags origin 'refs/heads/*'