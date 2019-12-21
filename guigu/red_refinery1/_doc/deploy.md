部署
====

## 准备工作

### 安装组件

基于 Ubuntu 18.04 LTS

升级一下系统到最新版本

```
sudo apt update
sudo apt upgrade
sudo apt autoremove
```

安装准备工作需要的基本组件

`sudo apt install build-essentials vim curl git wget`

重启一下

`sudo init 6`

装 RVM

```
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s stable
```

装 Ruby

`rvm install 2.6.5 && rvm use 2.6.5 --default`

装 Rails

`gem install bundler rails pry`

如果上一步长期卡住没动静或者你明确知道处在国内访问境外网络不通畅的环境（比如使用国内的云服务商），设置使用 RubyChina 的代理，然后重试上一步（安装 Rails）

```
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem sources -l
bundle config mirror.https://rubygems.org https://gems.ruby-china.com
```

装 NodeJS

```
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
```

装 Yarn

```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/source
sudo apt-get update && sudo apt-get install yarn
```

装 PostgreSQL

```
sudo apt install postgresql libpq-dev
```

### 准备 SSH key

流程参考 <https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent>

```
ssh-keygen -t rsa -b 4096 -C "deploy"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

在 GitHub 上，进入 Repo 页面

Settings -> Deploy Keys -> Add deploy key

右上角，`Add deploy key`，将生成的 `.ssh/id_rsa.pub` 内容复制进去，提交

### 准备部署目录

假设部署到 `~/sites/red_refinery`

```
cd ~
mkdir -p sites/red_refinery
```

### 准备数据库

进入 PG 的控制台

`sudo -u postgres psql`

注意将用户名、密码按需要修改，不要直接复制

```
CREATE USER dbuser WITH PASSWORD 'password';
CREATE DATABASE red_refinery OWNER dbuser;
GRANT ALL PRIVILEGES ON DATABASE red_refinery to dbuser;
```

操作成功后 `Ctrl-C` 退出

### 更新项目的部署配置

`config/deploy.rb`

确认 `repo_url` 指定的项目的 Git 网址正确无误

`config/deploy/production.rb`

修改第 8 行左右 `server` 的 `IP 地址` 和 `user` 为部署机的正确的 IP 地址和部署用户名

修改第 36 行左右 `set :deploy_to` 的路径为上文 `准备部署目录` 创建的目录的路径（绝对路径）

### 测试部署

在本地项目目录下执行

`cap production deploy:check`

第一次执行会失败，原因是提示缺少配置文件，

（如果是其他错误则检查是不是把开发机的 SSH 公钥添加到服务器的部署用户、
服务器的部署用户是否按上文添加到 GitHub repo 的 Deploy keys、
服务器能否访问到 GitHub、是否有网络问题等）

复制项目目录的 `config` 下的下列文件到 `~/sites/red_refinery/shared/config` 目录：
 
- `database.yml`
- `settings.local.yml`
- `mailer.yml`
- `credentials.yml.enc`
- `master.key`
- `storage.yml`

使用上文创建的数据库和用户名，更新 `database.yml` 的 `production` 部分。

其他文件根据需要编辑

再次运行 `cap production deploy:check`，此时命令不应该再报错

注：国内的云主机访问 GitHub 都或多或少有概率抽风，一般稍等即可

### 部署

测试部署通过后，使用

`cap production deploy`

即可部署项目

#### 编译 `mruby`

第一次部署成功后，进入部署目录 `cd ~/sites/red_refinery/current` 编译 `mruby`

```
rails script_core:engine:build
rails script_core:engine:compile_lib
```

#### 常见操作

停止 Web 服务

`cap production puma:stop`

重启 Web 服务

`cap production puma:restart`

回滚到上一版（紧急撤版使用，平时不推荐）

`cap production deploy:rollback`

### 配置 Nginx

安装

`sudo apt install nginx`

项目的 `_misc/nginx/red_refinery.conf` 为参考配置，
（需要 `sudo` 权限）复制到 `/etc/nginx/site-enabled/` 目录，根据实际情况编辑，

然后通过

`sudo nginx -t`

检查配置是否正确

然后重启 Nginx

`sudo service nginx restart`

即可生效

#### 更新 Web 服务的端口配置

编辑 `~/sites/red_refinery/shared/puma.rb` 结尾追加 `port 3000` 匹配 Nginx 的配置。

关闭、启动 Web 服务 `cap production puma:stop && cap production puma:start`

然后在浏览器访问网址检查是否通了，如果没通检查日志 `/var/log/nginx/red_refinery.error.log` 来排障
