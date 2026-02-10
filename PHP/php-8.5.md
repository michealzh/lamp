

# 添加 PHP 扩展的 tap
brew tap shivammathur/extensions

# 安装 redis 扩展
brew install shivammathur/extensions/redis@8.5

# 验证
php -m | grep redis
