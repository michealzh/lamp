
### [Mac brew安装的vim关闭兼容模式后delete键失效](http://cenalulu.github.io/linux/why-my-backspace-not-work-in-vim/)

- ⌘+l 光标切换到浏览器地址栏
- [mac 时间同步](https://shipengliang.com/software-exp/mac-os%E6%97%B6%E9%97%B4%E4%B8%8D%E5%90%8C%E6%AD%A5%E9%97%AE%E9%A2%98%E5%A6%82%E4%BD%95%E8%A7%A3%E5%86%B3.html)
- 重置dock图标数据库
```shell
rm ~/Library/Application\ Support/Dock/*.db && killall Dock
```
- 重置 Launchpad 图标数据库
```shell
defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock
```
- Apple xcode/Command Line Tools download
```
https://developer.apple.com/download/more/
```
- 不可恢复的错误。securityagent无法创建所要求的机制teamviewerauthplugin:start
```shell
rm /Volumes/用户名/var/db/auth.db
# 例如 
rm /Volumes/Zhangsan/var/db/auth.db
```
