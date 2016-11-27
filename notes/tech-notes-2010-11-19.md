# tech-notes-2010-11-19

mac系统中用brew管理命令行软件非常方便，安装方式如：

brew search xxx
搜索是否有某软件

brew install xxx
安装某软件

brew uninstall xxx
卸载某软件

brew info xxx
查看某软件的信息

brew list 
查看本机已安装的所有软件列表

如果需要对brew本身进行更新，请使用
brew update

brew cleanup && brew update
清理brew缓存并更新brew

经过一段时间后，brew安装的很多软件可能都已经有了更新，那么可以使用
brew upgrade
升级所有已经安装的组件

brew upgrade xxx
升级制定的软件

** brew doctor很有用，帮我们检查brew本身还存在哪些问题 **

brew missing
查找missing的依赖

brew在本地会缓存很多东西，比如未下载成功的一些软件，可以使用brew cleanup清理

用brew安装（install）或升级（upgrade）后都会自动执行brew link（在/usr/local/bin中添加软链接，链接到最新的版本），如果提示brew link失败会在命令行有提示（失败的原因可能是权限或其他某种原因造成的）

命令的提示如：

```
Error: The `brew link` step did not complete successfully
The formula built, but is not symlinked into /usr/local
Could not symlink bin/bsondump
Target /usr/local/bin/bsondump
is a symlink belonging to mongodb. You can unlink it:
  brew unlink mongodb

To force the link and overwrite all conflicting files:
  brew link --overwrite mongodb

To list all files that would be deleted:
  brew link --overwrite --dry-run mongodb

Possible conflicting files are:
/usr/local/bin/bsondump -> /usr/local/Cellar/mongodb/3.0.3/bin/bsondump
/usr/local/bin/mongo -> /usr/local/Cellar/mongodb/3.0.3/bin/mongo
```

错误信息写的很明确，我们可以使用
brew unlink mongodb来取消link

也可以以覆盖方式强制重新link
brew link --overwrite mongodb

若果执行看到覆盖强制link做了哪些事（而不是真正做）可以使用
brew link --overwrite --dry-run mongodb

---

还有一些不是命令行的工具，比如：evernote，qq，google-chrome等，可以使用brew cask安装
brew cask install evernote
这样evernote就会被直接安装到Applications中。不需要我们平时拖拽的方式安装

---

目前本机安装的软件有如下：
brew list

```
ktgus-mac:~ ktgu$ brew list
apr     gettext     lrzsz       openssl@1.1 tomcat7
apr-util    git     lua     pcre        unixodbc
autoconf    go      makedepend  pkg-config  wget
automake    gradle      maven       protobuf    wxmac
brew-cask   jenkins     mongodb     readline    xz
cask        jpeg        mysql       redis
dos2unix    libpng      nexus       scons
emacs       libtiff     nginx       sqlite
gdbm        libtool     openssl     subversion
```

列表中的mysql，jenkins，nexus，mongodb等其实都是可以用服务的方式来管理，可以用brew cask安装一个很使用的面板工具：LaunchRocket

brew cask install LaunchRocket

安装成功后可以打开LaunchRocket，就会弹出一个管理面板，在面板中点击“Scan HomeBrew"就可以将brew安装的可以用服务的形式管理的软件都列出来，在本机上列出的软件有：
jenkins, mysql, nexus, redis, emacs, mongodb, nginx

这个面板工具也是挺方便的，面板的方式很直观，如果不用LaunchRocket其实启动停止各种服务也是很方便的：

直接输入jenkins，然后在浏览器中键入：http://localhost:8080 验证是否成功

mysqld启动mysql服务器，然后使用mysql命令连接，如果成功就会进入mysql终端环境

nexus start或nexus console（具体用法：Usage: /usr/local/bin/nexus { console | start | stop | restart | status | dump }）
启动后也是在浏览器中验证：http://localhost:8081/nexus/

redis-server启动redis服务器，然后用redis-cli连接服务器

mongod启动mongodb的服务器，但在本机启动碰到一个问题：

1， /data/db这个目录没有，所以要先去创建好才能启动mongod
2. 启动失败，是因为权限的问题，使用：sudo mongod启动即可

---


使用option + command + d打开或关闭任务栏的自动隐藏

---





