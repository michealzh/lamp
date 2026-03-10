

# 基于刚推上去的 GitHub master 创建本地追踪分支
git fetch github
git checkout -b github-sync github/master
git checkout master

# 1. 切到同步分支，拉取 GitHub 最新状态
git checkout github-sync
git pull github master
# 2. 把 master 上的所有变更压缩成"一次待提交的修改"
git merge --squash master
# 3. 用干净的 commit message 提交
git commit -m "release: 简要描述本次变更"
# 4. 推送（fast-forward，无需 --force）
git push github github-sync:master
# 5. 切回内部 master 继续工作
git checkout master


git merge --squash 的作用是把 master 上所有新增的内部 commits 合并成一个"文件差异"暂存起来，你自己写 commit message，GitHub 上只会看到这一条记录，内部的提交历史完全不可见。
