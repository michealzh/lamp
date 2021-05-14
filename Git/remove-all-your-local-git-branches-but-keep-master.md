## see
- https://coderwall.com/p/x3jmig/remove-all-your-local-git-branches-but-keep-master
- https://stackoverflow.com/questions/10610327/delete-all-local-git-branches

```shell
git branch | grep -v "master" | xargs git branch -D 


```
