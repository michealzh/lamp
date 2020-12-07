### 重命名分支名称

- [Ref Stackoverflow](https://stackoverflow.com/questions/30590083/how-do-i-rename-both-a-git-local-and-remote-branch-name)

Rename Local Branch,

My current branch is master

1. git branch -m master_renamed #master_renamed is new name of master

Delete remote branch,

2. git push origin --delete master #origin is remote_name

Push renamed branch into remote,

3. git push origin master_renamed

