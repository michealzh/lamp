- [通过git bisect定位何时引入错误](http://www.ruanyifeng.com/blog/2018/12/git-bisect.html)
- git shortlog -sn 分析提交记录
- [git branch | grep -ve " master$" | xargs git branch -D](https://coderwall.com/p/x3jmig/remove-all-your-local-git-branches-but-keep-master)
- git reset HEAD . --> git add 撤销
- 忽略文件chmod的变更
```shell
git status 提示:
# git diff old mode 100644 new mode 100755

修改:
git config --add core.filemode false
```
