# Linux基础文件
>关于linux的基础知识

****

## 一、开机关机、在线求组与指定下达方式

### 1、开机启动相关

[Ctrl] + [Alt] + [F1] ~ [F6] ：文字接口登入 tty1 ~ tty6 终端机； 

[Ctrl] + [Alt] + [F7] ：图形接口桌面。

启动图形接口：startx

启动环境变更： 修改/etc/inittab文件的Run level为5/3

注销系统：exit

设置系统语言：LANG=en

###2、基础指令操作

日期指令：date

- 默认时间：date
- 年/月/日：date +%Y/%m/%d
- 时/分：date +%H:%M

显示日历的指令：cal

- 目前本年本月的日历：cal
- 整年日历：cal 2016
- 某年月的日历： cal 8 2016

计算器：bc，离开计算器quit

### 3、几个重要热键

[tab]：命令补全

[ctrl+c]：指令中断

[ctrl+d]：相当于exit，文字界面退出

###4、在线求助

寻求帮助：man/info

获取更多信息：man -f

指定不同数据帮助文档： man 1/7

whatis [指令或者是数据] 相当于man -f

apropos [指令或者是数据] 相当于man -k

### 5、正确关机方法

将数据同步写入硬盘中的指令： sync 

惯用的关机指令： shutdown 

    -t sec ： -t 后面加秒数，亦即『过几秒后关机』的意思   
    -k ： 不要真的关机，只是发送警告讯息出去！   
    -r ： 在将系统的服务停掉之后就重新开机   
    -h ： 将系统的服务停掉后，立即关机。   
    -n ： 不经过 init 程序，直接以 shutdown 的功能来关机   
    -f ： 关机并开机之后，强制略过 fsck 的磁盘检查   
    -F ： 系统重新开机之后，强制进行 fsck 的磁盘检查   
    -c ： 取消已经在进行的 shutdown 指令内容。   

重新开机，关机： reboot, halt, poweroff 

## 二、Linux 的档案属性与目录配置

### 1、使用者与群组

拥有者-群组-其他人

###2、文件属性

查看文件属性：ls -al

### 3、改变档案权限

chgrp ：改变档案所属群组

    chgrp root some: 设置some为root组

chown ：改变档案所属人
    chown root:root 设置some拥有者和组都为root

chmod ：改变档案的属性、SUID 、等等的特性

    chmod 777 some：设置some为rwxrwxrwx权限
    chmod a+x, g=rx, o-x: 设置拥有者增加x权限，组为rx权限,其他人去掉x权限

### 4、目录属性的意义

r： 表示具有读取目录结构清单的权限，所以当您具有读取 (r) 一个目录的权限时， 您就可以利用 ls 这个指令将该目录的内容列表显示出来！ 

w：这个可写入的权限对目录来说，是很了不起的，表示您将具有异动该目录结构清单的权限，也就是底下这些权限： 

-  删除已经存在的档案与目录(不论该档案是属于谁的！)
-  建立新的档案与目录；
-  将已存在的档案或目录进行
-  搬移该目录内的档案、目录位置。

x：这个 x 与能否进入该目录有关。

###5、Linux 文件种类与附档名

文件种类：

- 正规文件：-
- 目录：d
- 链接：l
- 设备与装置文件：
    - 块区设备：b
    - 字符设备(鼠标、键盘)：c
- 资料接口文件：s
- 数据输送文件：p

### 6、目录含义

**/：根目录（root）**

一般建议在根目录底下只接目录，不要直接有档案在 / 底下。根目录是开机的时候系统第一个挂载的 partition ，所以，所有开机过程会用到的档案， 应该都要放置在这个 partition 当中。举例来说， /etc, /bin, /dev/lib, /sbin 这五个次目录都应该要与根目录连在一起，不可独立成为某个 partition   

**/bin, /usr/bin, /usr/local/bin：放可执行二进制文件**

除了 /bin 之外， /usr/local/bin, /usr/bin 也是`放置使用者可执行的 binary file 的目录`喔！举例来说， ls, mv, rm, mkdir, rmdir, gzip, tar, cat, cp, mount 等等重要指令都放在这个目录当中。

**/boot：开机启动文档**

这个目录主要的目的是放置 Linux 系统开机会用到的档案。 开机会用到什么呢？没错～就是 Linux 的核心档案。这个目录底下文件名为 vmlinuz 的就是 Linux 的 Kernel 啦！粉重要的东西！ 而如果你的开机管理程序 (loader) 选择 grub 的话，那么这个目录内还有 /boot/grub 这个次目录呦！ 

**/etc：配置文档**

系统主要的设定文件几乎都放置在这个目录内，例如人员的账号密码文件、 各种服务的启始档等等。一般来说，这个目录下的各档案属性是可以让一般使用者查阅的， 但是只有 root 有权力修改。

- /etc/init.d/：所有服务的预设启动 script 都是放在这里的，例如要启动或者关闭 iptables 的话： 
    - /etc/init.d/iptables start 
    - /etc/init.d/iptables stop 
- /etc/xinetd.d/：这就是所谓的 super daemon 管理的各项服务的设定文件目录。
- /etc/X11：与 X Window 有关的各种设定档都在这里，尤其是 xorg.conf 或 XF86Config 这两个 X Server 的设定档。

**/home：用户家目录**

这是系统预设的使用者家目录 (home directory)。在你新增一个一般使用者账号时， 预设的使用者家目录都会规范到这里来。比较重要的是，家目录有两种代号喔：

-  ~：代表目前这个使用者的家目录
- ~dmtsai ：则代表 dmtsai 的家目录！

**/lib, /usr/lib, /usr/local/lib：放置库函式目录 **

系统会使用到的函式库放置的目录。 程序在运作的过程中，可能会呼叫一些额外的功能参数，那需要函式库的协助！ 这些函式库就放在此处。比较重要的是 /lib/modules 这个目录内会摆放 kernel 的相关模块喔！

**/lost+found：系统不正常发生的错误，遗失片段存放目录**

系统不正常产生错误时，会将一些遗失的片段放置于此目录下， 通常这个目录会自动出现在某个 partition 最顶层的目录下。例如你加装一棵硬盘于 /disk 中，那在这个目录下就会自动产生一个这样的目录 /disk/lost+found 

**/mnt ,/media : 软盘与光盘挂载点**

**/opt：给主机额外安装软件存放的目录**

**/proc ：虚拟档案系统，所有数据都在内存中**

**/root：系统管理员（root）家目录**

**/sbin, /usr/sbin, /usr/local/sbin ：系统管理员才会用到的执行命令**

**/srv：一些服务启动之后，这些服务所需要取用的数据目录。**

举例来说，WWW 服务器需要的网页资料就可以放置在 /srv/www 里面。

**/tmp：运行程序暂时产生的一些文件目录**

这是让一般使用者或者是正在执行的程序暂时放置档案的地方。 这个目录是任何人都能够存取的，所以您需要定期的清理一下。当然，重要数据不可放置在此目录啊！

**/usr：由 FHS 规范的第二层内容**

在 /usr 此目录下，包含系统的主要程序、 
图形接口所需要的档案、额外的函式库、本机端所自行安装的软件，以及共享的目录与文件等等，都可以在这个目录当中发现。事实上，他有点像是 Windows 操作系统当中的『Program files』与 『WinNT』这两个目录的结合！在此目录下的重要次目录有： 

- /usr/bin, /usr/sbin：一般身份使用者与系统管理员可执行的档案放置目录； 
- /usr/include：c/c++等程序语言的档头 (header) 与包含档(include)放置处， 当我们以 tarball 方式 (*.tar.gz 的方式安装软件) 安装某些数据时，会使用到里头的许多包含档喔！； 
- /usr/lib：各应用软件的函式库档案放置目录； 
- /usr/local：本机端自行安装的软件预设放置的目录。目前也适用于 /opt 目录。 在你安装完了 Linux 之后，基本上所有的配备你都有了，但是软件总是可以升级的， 例如你要升级你的 proxy 服务，则通常软件预设的安装地方就是在 /usr/local (local 是『当地』的意思)，同时，安装完毕之后所得到的执行文件，为了与系统原先的执行文件有分别， 因此升级后的执行档通常摆在 /usr/local/bin 这个地方。
- /usr/share：共享文件放置的目录，例如底下两个目录： 
- /usr/share/doc：放置一些系统说明文件的地方，例如你安装了 grub 了，那么在该目录底下找一找，就可以查到 lilo 的说明文件了！很是便利！ 
- /usr/share/man：manpage 的文件档案目录；那是什么？呵呵！ 就是你使用 man 的时候，会去查询的路径呀！例如你使用 man ls 这个指令时，就会查出 /usr/share/man/man1/ls.1.gz 这个说明档的内容啰！ 
- /usr/src：Linux 系统相关的程序代码放置目录，例如 /usr/src/linux 为核心原始码！ 
- /usr/X11R6：系统内的 X Window System 所需的执行档几乎都放在这！

**/var：由 FHS 规范的第二层内容**

他主要放置的是针对系统执行过程中， 常态性变动的档案放置的目录。举例来说，例如快取档案 (cache) 或者是随时变更的登录档 (log file) 都是放在这个目录中的。此外，某些软件执行过程中会写入的数据库档案， 例如 MySQL 数据库，也都写入在这个目录中！很重要吧！他底下的重要目录有： 

- /var/cache：程序档案在运作过程当中的一些暂存盘； 
- /var/lib：程序本身执行的过程中，需要使用到的数据文件放置的目录， 举例来说， locate 这个数据库与 MySQL 及 rpm 等数据库系统，都写在这个目录内。 
- /var/log：登录文件放置的目录。很重要啊！例如 /var/log/messages 就是总管所有登录档的一个档案！ 
- /var/lock：某些装置具有一次性写入的特性，例如 tab (磁带机)， 此时，为了担心被其它人干扰而破坏正在运作的动作，因此，会将该装置 lock (锁住)起来， 以确定该装置只能被单一个程序所使用啊！ 
- /var/run：某些程序或者是服务启动后，会将他们的 PID 放置在这个目录下喔！ 
- /var/spool：是一些队列数据存放的地方。举例来说，主机收到电子邮件后， 就会放置到 /var/spool/mail 当中，若信件暂时发不出去，就会放置到 /var/spool/mqueue 目录下， 使用者工作排程 (cron) 则是放置在 
- /var/spool/cron 当中！ 

## 三、 Linux磁盘系统与档案系统管理

### 1、磁盘与目录的容量

**df：查询磁盘容量**

df [-ahikHTm] [目录或文件名]   
参数：   
-a ：列出所有的档案系统，包括系统特有的 /proc 等档案系统；   
-k ：以 KBytes 的容量显示各档案系统；   
-m ：以 MBytes 的容量显示各档案系统；   
-h ：以人们较易阅读的 GBytes, MBytes, KBytes 等格式自行显示；   
-H ：以 M=1000K 取代 M=1024K 的进位方式；   
-T ：连同该 partition 的 filesystem 名称 (例如 ext3) 也列出；   
-i ：不用硬盘容量，而以 inode 的数量来显示

**du：查询目录占用容量**

du [-ahskm] 档案或目录名称
参数：   
-a ：列出所有的档案与目录容量，因为预设仅统计目录底下的档案量而已。   
-h ：以人们较易读的容量格式 (G/M) 显示；   
-s ：列出总量而已，而不列出每个各别的目录占用容量；   
-k ：以 KBytes 列出容量显示；   
-m ：以 MBytes 列出容量显示；   
du -sm /*：这是个很常被使用的功能啰～利用万用字符 * 来代表每个目录，所以，如果想要检查某个目录下，那个次目录占用最大的容量，就可以用这个方法找出来    

### 2、链接文件

**ln：创建链接文件**

ln [-sf] 来源文件 目标文件   
参数：   
-s ：如果 ln 不加任何参数就进行连结，那就是 hard link，至于 -s 就是 symbolic link   
-f ：如果 目标文件 存在时，就主动的将目标文件直接移除后再建立！   

要注意啰！使用 ln 如果不加任何参数的话，那么就是 Hard Link （数据关联硬式链接）啰！而如果 ln 使用 -s 的参数时，就做成差不多是 Windows底下的『快捷方式』（软式链接）的意思( Symbolic Link，较常用！ )

###3、磁盘的分割、格式化、检验与挂载： 

**fdisk：磁盘分割**

**mke2fs：磁盘格式化**

**fsck，badblocks：磁盘检验**

**mount：磁盘挂载**

**unmount：磁盘卸载**

## 四、Linux 档案与目录管理

### 1、目录与路径

**绝对路径与相对路径**

绝对路径：路径的写法『一定由根目录 / 写起』，例如： /usr/share/doc 这个目录。 

相对路径：路径的写法『不是由 / 写起』，例如由 /usr/share/doc 要到 /usr/share/man 底下时，可以写成： 『cd ../man』这就是相对路径的写法啦！相对路径意指『相对于目前工作目录的路径！』 

**目录的相关操作：**

    . 代表此层目录 
    .. 代表上一层目录 
    + 代表前一个工作目录 
    ~ 代表『目前使用者身份』所在的家目录 
    ~account 代表 account 这个使用者的家目录 

- cd：变换目录 
- pwd：显示目前的目录 
- mkdir：建立一个新的目录 
- rmdir：删除一个空的目录 

**关于执行文件的环境变量：$PATH**

显示环境路径：echo $PATH

设置环境路径：PATH="$PATH":/root 

### 2、文件与目录的管理

**文件与目录的检视：ls**

    ls 目录或文件名

    参数：   
    -a ：全部的档案，连同隐藏档( 开头为 . 的档案) 一起列出来～   
    -A ：全部的档案，连同隐藏档，但不包括 . 与 .. 这两个目录，一起列出来～   
    -d ：仅列出目录本身，而不是列出目录内的档案数据   
    -f ：直接列出结果，而不进行排序 (ls 预设会以档名排序！)   
    -F ：根据档案、目录等信息，给予附加数据结构，例如：   
    *：代表可执行档； /：代表目录； =：代表 socket 档案； |：代表 FIFO 档案；   
    -h ：将档案容量以人类较易读的方式(例如 GB, KB 等等)列出来；   
    -i ：列出 inode 位置，而非列出档案属性；   
    -l ：长数据串行出，包含档案的属性等等数据；   
    -n ：列出 UID 与 GID 而非使用者与群组的名称 (UID 与 GID 会在账号管理提到！)   
    -r ：将排序结果反向输出，例如：原本档名由小到大，反向则为由大到小；   
    -R ：连同子目录内容一起列出来；   
    -S ：以档案容量大小排序！   
    -t ：依时间排序   
    --color=never ：不要依据档案特性给予颜色显示；   
    --color=always ：显示颜色   
    --color=auto ：让系统自行依据设定来判断是否给予颜色   
    --full-time ：以完整时间模式 (包含年、月、日、时、分) 输出   
    --time={atime,ctime} ：输出 access 时间或 改变权限属性时间 (ctime)   
    而非内容变更时间 (modification time)   

    **复制、移动与删除：cp，rm， mv**

cp（复制文档或目录）   

    cp [-adfilprsu] 来源档(source) 目的檔(destination)
    参数：   
    -a ：相当于 -pdr 的意思；   
    -d ：若来源文件为连结文件的属性(link file)，则复制连结文件属性而非档案本身；   
    -f ：为强制 (force) 的意思，若有重复或其它疑问时，不会询问使用者，而强制复制；   
    -i ：若目的檔(destination)已经存在时，在覆盖时会先询问是否真的动作！   
    -l ：进行硬式连结 (hard link) 的连结档建立，而非复制档案本身；   
    -p ：连同档案的属性一起复制过去，而非使用预设属性；   
    -r ：递归持续复制，用于目录的复制行为；   
    -s ：复制成为符号连结文件 (symbolic link)，亦即『快捷方式』档案；   
    -u ：若 destination 比 source 旧才更新 destination ！   

rm (移除档案或目录)   

    rm [-fir] 档案或目录   
    参数：   
    -f ：就是 force 的意思，强制移除；   
    -i ：互动模式，在删除前会询问使用者是否动作   
    -r ：递归删除啊！最常用在目录的删除了   

    mv (移动档案与目录，或更名)

     mv [-fiu] source destination   
    参数：   
    -f ：force 强制的意思，强制直接移动而不询问；   
    -i ：若目标档案 (destination) 已经存在时，就会询问是否覆盖！   
    -u ：若目标档案已经存在，且 source 比较新，才会更新 (update)   

**取得路径的文件名称与目录名称**

    [root@linux ~]# basename /etc/sysconfig/network 
    network <== 很简单！就取得最后的档名～ 
    [root@linux ~]# dirname /etc/sysconfig/network 
    /etc/sysconfig <== 取得的变成目录名了！ 

### 3、文档内容查阅

- cat 由第一行开始显示档案内容
- tac 从最后一行开始显示，可以看出tac 是cat 的倒着写！
- nl  显示的时候，顺道输出行号！
- more 一页一页的显示档案内容
- less 与more 类似，但是比more 更好的是，他可以往前翻页！
- head 只看头几行
- tail 只看尾巴几行
- od  以二进制的方式读取档案内容！

**直接检视档案内容**

cat（正向查阅）

    cat [-AEnTv]
    参数： 
    -A ：相当于 -vET 的整合参数，可列出一些特殊字符～ 
    -E ：将结尾的断行字符 $ 显示出来； 
    -n ：打印出行号； 
    -T ：将 [tab] 按键以 ^I 显示出来； 
    -v ：列出一些看不出来的特殊字符 

tac（反向查看）

    tac /etc/issue

nl（添加行号打印）

    tac /etc/issue
    参数： 
    -b ：指定行号指定的方式，主要有两种： 
    -b a ：表示不论是否为空行，也同样列出行号； 
    -b t ：如果有空行，空的那一行不要列出行号； 
    -n ：列出行号表示的方法，主要有三种： 
    -n ln ：行号在屏幕的最左方显示； 
    -n rn ：行号在自己字段的最右方显示，且不加 0 ； 
    -n rz ：行号在自己字段的最右方显示，且加 0 ； 
    -w ：行号字段的占用的位数。

more（一页一页的翻动）

less（一页一页的翻动， 可以向前翻页）

**获取资料**

head（取出前面几行）

    head [-n number] 文档
    参数： 
    -n ：后面接数字，代表显示几行的意思

tail (取出后面几行)
    tail [-n number] 文档
    参数： 
    -n ：后面接数字，代表显示几行的意思

非纯文字文件： od 

    od [-t TYPE] 档案
    参数： 
    -t ：后面可以接各种『类型 (TYPE)』的输出，例如： 
    a ：利用预设的字符来输出； 
    c ：使用 ASCII 字符来输出 
    d[size] ：利用十进制(decimal)来输出数据，每个整数占用 size bytes ； 
    f[size] ：利用浮点数值(floating)来输出数据，每个数占用 size bytes ； 
    o[size] ：利用八进位(octal)来输出数据，每个整数占用 size bytes ； 
    x[size] ：利用十六进制(hexadecimal)来输出数据，每个整数占用 size bytes ；

**修改档案时间与建置新档： touch**

    touch [-acdmt] 文档
    参数： 
    -a ：仅修订 access time； 
    -c ：仅修改时间，而不建立档案；
    -d ：后面可以接日期，也可以使用 --date="日期或时间" 
    -m ：仅修改 mtime ； 
    -t ：后面可以接时间，格式为[YYMMDDhhmm] 

### 4、档案与目录的预设权限与隐藏权限

**文档预设权限：umask**

umask 就是指定 `目前使用者在建立档案或目录时候的属性默认值`

    [root@linux ~]# umask 
    0022 
    [root@linux ~]# umask -S 
    u=rwx,g=rx,o=rx 

**文档隐藏属性**

chattr (设定档案隐藏属性) 

    chattr [+-=][ASacdistu] 档案或目录名称
    参数： 
    * ：增加某一个特殊参数，其它原本存在参数则不动。 
    + ：移除某一个特殊参数，其它原本存在参数则不动。 
    = ：设定一定，且仅有后面接的参数 
    A ：当设定了 A 这个属性时，这个档案(或目录)的存取时间 atime (access) 
    将不可被修改，可避免例如手提式计算机容易有磁盘 I/O 错误的情况发生！ 
    S ：这个功能有点类似 sync的功能！就是会将数据同步写入磁盘当中！ 
    可以有效的避免数据流失！ 
    a ：当设定 a 之后，这个档案将只能增加数据，而不能删除，只有 root 
    才能设定这个属性。 
    c ：这个属性设定之后，将会自动的将此档案『压缩』，在读取的时候将会自动解压缩， 
    但是在储存的时候，将会先进行压缩后再储存(看来对于大档案似乎蛮有用的！) 
    d ：当 dump(备份)程序被执行的时候，设定 d 属性将可使该档案(或目录)不具有 dump 功能 
    i ：这个 i 可就很厉害了！他可以让一个档案『不能被删除、改名、设定连结也无法写入 
    或新增资料！』对于系统安全性有相当大的帮助！ 
    j ：当使用 ext3 这个档案系统格式时，设定 j 属性将会使档案在写入时先记录在 
    journal 中！但是当 filesystem 设定参数为 data=journalled 时，由于已经设定了 
    日志了，所以这个属性无效！ 
    s ：当档案设定了 s 参数时，他将会被完全的移除出这个硬盘空间。 
    u ：与 s 相反的，当使用 u 来设定档案时，则数据内容其实还存在磁盘中， 
    可以使用来 undeletion. 
    注意：这个属性设定上面，比较常见的是 a 与 i 的设定值，而且很多设定值必须要身为 
    root 才能够设定的喔！ 

lsattr (显示档案隐藏属性)

    lsattr [-aR] 档案或目录
    参数： 
    -a ：将隐藏文件的属性也秀出来； 
    -R ：连同子目录的数据也一并列出来！

**文档类型:file**

查询某个文档的基本数据类型

### 5、文档搜索

**which（寻找执行文档）**

    which [-a] command
    -a：讲所有找到的指令列出

**whereis（寻找特定的文档）**

    whereis [-bmsu] 文档或者目录名
    参数： 
    -b :只找 binary 的文档 
    -m :只找在说明文件 manual 路径下的文档
    -s :只找 source 来源文档
    -u :没有说明档的文档

**locate已建数据库搜索**

    locate 文档名

**find磁盘搜索**

    find [PATH] [option] [action]
    参数： 
    1. 与时间有关的参数： 
    -atime n ：n 为数字，意义为在 n 天之前的『一天之内』被 access 过的档案； 
    -ctime n ：n 为数字，意义为在 n 天之前的『一天之内』被 change 过状态的档案； 
    -mtime n ：n 为数字，意义为在 n 天之前的『一天之内』被 modification 过的档案； 
    -newer file ：file 为一个存在的档案，意思是说，只要档案比 file 还要新， 
    就会被列出来～ 
    2. 与使用者或群组名称有关的参数： 
    -uid n ：n 为数字，这个数字是使用者的账号 ID，亦即 UID ，这个 UID 是记录在 
    /etc/passwd 里面与账号名称对应的数字。这方面我们会在第四篇介绍。 
    -gid n ：n 为数字，这个数字是群组名称的 ID，亦即 GID，这个 GID 记录在 
    /etc/group，相关的介绍我们会第四篇说明～ 
    -user name ：name 为使用者账号名称喔！例如 dmtsai 
    -group name：name 为群组名称喔，例如 users ； 
    -nouser ：寻找档案的拥有者不存在 /etc/passwd 的人！ 
    -nogroup ：寻找档案的拥有群组不存在于 /etc/group 的档案！ 
                    当您自行安装软件时，很可能该软件的属性当中并没有档案拥有者， 
                    这是可能的！在这个时候，就可以使用 -nouser 与 -nogroup 搜寻。 
    3. 与档案权限及名称有关的参数： 
    -name filename：搜寻文件名称为 filename 的档案； 
    -size [+-]SIZE：搜寻比 SIZE 还要大(+)或小(-)的档案。这个 SIZE 的规格有： 
                            c: 代表 byte， k: 代表 1024bytes。所以，要找比 50KB 
                            还要大的档案，就是『 -size +50k 』 
    -type TYPE ：搜寻档案的类型为 TYPE 的，类型主要有：一般正规档案 (f), 
                        装置档案 (b, c), 目录 (d), 连结档 (l), socket (s), 
                        及 FIFO (p) 等属性。 
    -perm mode ：搜寻档案属性『刚好等于』 mode 的档案，这个 mode 为类似 chmod 
                            的属性值，举例来说， -rwsr-xr-x 的属性为 4755 ！ 
    -perm -mode ：搜寻档案属性『必须要全部囊括 mode 的属性』的档案，举例来说， 
                            我们要搜寻 -rwxr--r-- ，亦即 0744 的档案，使用 -perm -0744， 
                            当一个档案的属性为 -rwsr-xr-x ，亦即 4755 时，也会被列出来， 
                            因为 -rwsr-xr-x 的属性已经囊括了 -rwxr--r-- 的属性了。 
    -perm +mode ：搜寻档案属性『包含任一 mode 的属性』的档案，举例来说，我们搜寻 
    -rwxr-xr-x ，亦即 -perm +755 时，但一个档案属性为 -rw------- 
                             也会被列出来，因为他有 -rw.... 的属性存在！ 
    4. 额外可进行的动作： 
    -exec command ：command 为其它指令，-exec 后面可再接额外的指令来处理搜寻到 
                                的结果。 
    -print ：将结果打印到屏幕上，这个动作是预设动作！

##　四、文档的压缩与打包

tar

-c: 建立压缩档案   
-x：解压   
-t：查看内容   
-r：向压缩归档文件末尾追加文件   
-u：更新原压缩包中的文件  

这五个是独立的命令，压缩解压都要用到其中一个，可以和别的命令连用但只能用其中一个。下面的参数是根据需要在压缩或解压档案时可选的。

-z：有gzip属性的   
-j：有bz2属性的   
-Z：有compress属性的   
-v：显示所有过程   
-O：将文件解开到标准输出   

下面的参数-f是必须的
-f: 使用档案名字，切记，这个参数是最后一个参数，后面只能接档案名。

    # tar -cf all.tar *.jpg这条命令是将所有.jpg的文件打成一个名为all.tar的包。-c是表示产生新的包，-f指定包的文件名。
    # tar -rf all.tar *.gif

这条命令是将所有.gif的文件增加到all.tar的包里面去。-r是表示增加文件的意思。

    # tar -uf all.tar logo.gif

这条命令是更新原来tar包all.tar中logo.gif文件，-u是表示更新文件的意思。

    # tar -tf all.tar

这条命令是列出all.tar包中所有文件，-t是列出文件的意思

    # tar -xf all.tar

这条命令是解出all.tar包中所有文件，-x是解开的意思

压缩

    tar –cvf jpg.tar *.jpg //将目录里所有jpg文件打包成tar.jpg
    tar –czf jpg.tar.gz *.jpg //将目录里所有jpg文件打包成jpg.tar后，并且将其用gzip压缩，生成一个gzip压缩过的包，命名为jpg.tar.gz
    tar –cjf jpg.tar.bz2 *.jpg //将目录里所有jpg文件打包成jpg.tar后，并且将其用bzip2压缩，生成一个bzip2压缩过的包，命名为jpg.tar.bz2
    tar –cZf jpg.tar.Z *.jpg //将目录里所有jpg文件打包成jpg.tar后，并且将其用compress压缩，生成一个umcompress压缩过的包，命名为jpg.tar.Z
    rar a jpg.rar *.jpg //rar格式的压缩，需要先下载rar for linux
    zip jpg.zip *.jpg //zip格式的压缩，需要先下载zip for linux

解压

    tar –xvf file.tar //解压 tar包
    tar -xzvf file.tar.gz //解压tar.gz
    tar -xjvf file.tar.bz2 //解压 tar.bz2
    tar –xZvf file.tar.Z //解压tar.Z
    unrar e file.rar //解压rar
    unzip file.zip //解压zip

总结

1、*.tar 用 tar –xvf 解压   
2、*.gz 用 gzip -d或者gunzip 解压   
3、*.tar.gz和*.tgz 用 tar –xzf 解压   
4、*.bz2 用 bzip2 -d或者用bunzip2 解压   
5、*.tar.bz2用tar –xjf 解压   
6、*.Z 用 uncompress 解压   
7、*.tar.Z 用tar –xZf 解压   
8、*.rar 用 unrar e解压   
9、*.zip 用 unzip 解压   

## 五、vi、vim文字处理器