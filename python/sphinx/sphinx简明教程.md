> 本文章是学习如何使用Sphinx工具创建以各种格式（HTML）自动进行分布的可维护的、样式支配的文档。

## 简介

Sphinx 是一种工具，它允许开发人员以纯文本格式编写文档，以便采用满足不同需求的格式轻松生成输出。这在使用 Version Control System 追踪变更时非常有用。纯文本文档对不同系统之间的协作者也非常有用。纯文本是当前可以采用的最便捷的格式之一。

虽然 Sphinx 是用 Python 编写的，并且最初是为 Python 语言文档而创建，但它并不一定是以语言为中心，在某些情况下，甚至不是以程序员为中心。Sphinx 有许多用处，比如可以用它来编写整本书！


默认情况下，Sphinx 会为 Python 突出显示代码，但它还允许定义其他编程语言，比如 C 和 Ruby。

可以将 Sphinx 想像成为一种文档框架：它会抽象化比较单调的部分，并提供自动函数来解决一些常见问题，比如突出显示标题索引和特殊代码（在显示代码示例时），以及突出显示适当的语法。

## 要求

 您应该能轻车熟路地使用 Linux® 或 UNIX® 终端（也称为控制台或终端仿真器），因为命令行界面是与 Sphinx 进行互动的主要方式。

您需要安装 Python。在所有主要的 Linux 发行版和一些基于 UNIX 的操作系统（如 Mac OSX）上预先安装 Python 并做好使用它的准备。目前最新的Sphinx1.5版本 支持 Python V 2.7。要确定您已经安装了 Python 并且安装的是有效版本，请运行清单1的代码。

**清单1.**
```python
$python --version
Python 2.7.12
```
## 语法
 Sphinx 使用 reStructuredText 标记语法（和其他一些语法）来提供文档控制。如果您之前编写过纯文本文件，那么您可能非常了解精通 Sphinx 所需的语法。

标记允许为适当的输出实现文本的定义和结构。开始之前，请参见下面 中的一个小的标记语法示例。

**清单2.Sphinx标记语法示例**
```
This is a Title
===============
That has a paragraph about a main subject and is set when the '='
is at least the same length of the title itself.

Subject Subtitle
----------------
Subtitles are set with '-' and are required to have the same length 
of the subtitle itself, just like titles.

Lists can be unnumbered like:

 * Item Foo
 * Item Bar

Or automatically numbered:

 #. Item 1
 #. Item 2

Inline Markup
-------------
Words can have *emphasis in italics* or be **bold** and you can define
code samples with back quotes, like when you talk about a command: ``sudo`` 
gives you super user powers!
```
正如您所看到的，纯文本格式的语法非常容易读懂。在创建特定格式（如 HTML）时，标题会成为主要目标，其字体会比副标题大一些（理应如此），并且会对编号列表进行适当的编号。您已经拥有一些非常强大的功能。添加更多的项或更改编号列表中的顺序不会影响到编号，而通过替换使用的下划线可以改变标题的重要性。 

## 安装和配置 

安装是通过命令进行的，非常简单明了，一种是直接通过pip安装：


```bash
$ pip install sphinx
Searching for sphinx
Reading http://pypi.python.org/simple/sphinx/
Reading http://sphinx.pocoo.org/
Best match: Sphinx 1.5.2
Downloading http://pypi.python.org/packages/[...]
Processing Sphinx-1.5.5-py2.7.egg
[...]
Finished processing dependencies for sphinx
```

如果安装不成功，可以另外试一下：


```
$easy_install sphinx
```

如果还是不行，可以下载源码安装: [http://sphinx-doc.org/](http://note.youdao.com/)

框架使用了一个目录结构来分离源文件（纯文本文件）和构建（指生成的输出）。例如，如果使用 Sphinx 从文档源中生成一个 PDF，那么该文件会放置在构建目录中。您可以更改此行为，但为了获得一致性，我们还是保留了默认格式。

让我们快速启动下面命令
**清单4.**

```
$ sphinx-quickstart
Welcome to the Sphinx 1.5a2 quickstart utility.

Please enter values for the following settings (just press Enter to
accept a default value, if one is given in brackets).

Enter the root path for documentation.
> Root path for the documentation [.]: 
```

如果报错了，一般会按照提示安装相应的包即可。运行无误后，系统会通过一些问题提示您如何操作，请按下 Enter 键接受所有的默认值。最后可以生成如下的目录树：


```
.
├── build
└── source
    ├── _static
    ├── _templates
    ├── conf.py
    └── index.rst
├── make.bat
└── Makefile
```
 让我们详细研究一下每个文件。


- make.bat: make编译的命令文件
- Makefile：编译过代码的开发人员应该非常熟悉这个文件，如果不熟悉，那么可以将它看作是一个包含指令的文件，在使用 make 命令时，可以使用这些指令来构建文档输出。
- build：这是触发特定输出后用来存放所生成的文件的目录。
- source: 源文件目录
- _static：所有不属于源代码（如图像）一部分的静态文件均存放于此处，稍后会在构建目录中将它们链接在一起。
- _templates: 模板文件
- conf.py：这是一个 Python 文件，用于存放 Sphinx 的配置值，包括在终端执行 sphinx-quickstart 时选中的那些值。
- index.rst：文档项目的 root目录。如果将文档划分为其他文件，该目录会连接这些文件。

## 定义文档结构

 此时，我们已经正确安装了 Sphinx，查看了默认结构，并了解了一些基本语法。不要直接开始编写文档。缺乏布局和输出方面的知识会让您产生混淆，可能耽误您的整个进程。

现在来深入了解一下 index.rst 文件。它包含大量的信息和其他一些复杂的语法。为了更顺利地完成任务并避免干扰，我们将合并一个新文件，将它列在主要章节中。

在 index.rst 文件中的主标题之后，有一个内容清单，其中包括 toctree 声明。toctree 是将所有文档汇集到文档中的中心元素。如果有其他文件存在，但没有将它们列在此指令下，那么在构建的时候，这些文件不会随文档一起生成。

我们想将一个新文件添加到文档中，并打算将其命名为 example.rst。还需要将它列在 toctree 中，但要谨慎操作。文件名后面需要有一个间隔，这样文件名清单才会有效，该文件不需要文件扩展名（在本例中为 .rst）。在文件名距离左边距有三个空格的距离，maxdepth 选项后面有一个空白行。以下展示了index.res中的`toctree`示例

**清单5.**
```
.. toctree::
   :maxdepth: 2

   example
```
讲上面sphinx的示例语法复制粘贴到example.rst文件中并保存它。

编译文档命令：

```
$ sphinx-build -b html sourcedir builddir
```

在上面运行的sphinx-quickstart已经创建了一个makefile和make.bat文件，我们可以使用make命令更方便的编译文档。如清单6代码。

**清单6.**

```
$ make html
sphinx-build -b html -d _build/doctrees   . _build/html
Making output directory...
Running Sphinx v1.0.5
loading pickled environment... not yet created
building [html]: targets for 2 source files that are out of date
updating environment: 2 added, 0 changed, 0 removed
reading sources... [100%] index
looking for now-outdated files... none found
pickling environment... done
checking consistency... done
preparing documents... done
writing output... [100%] index 
writing additional files... genindex search
copying static files... done
dumping search index... done
dumping object inventory... done
build succeeded.

Build finished. The HTML pages are in _build/html.
```

关于make更多的用法可以直接输入make进行查看：

```
Sphinx v1.5a2
Please use `make target' where target is one of
  html        to make standalone HTML files
  dirhtml     to make HTML files named index.html in directories
  singlehtml  to make a single large HTML file
  pickle      to make pickle files
  json        to make JSON files
  htmlhelp    to make HTML files and a HTML help project
  qthelp      to make HTML files and a qthelp project
  devhelp     to make HTML files and a Devhelp project
  epub        to make an epub
  latex       to make LaTeX files, you can set PAPER=a4 or PAPER=letter
  text        to make text files
  man         to make manual pages
  texinfo     to make Texinfo files
  gettext     to make PO message catalogs
  changes     to make an overview of all changed/added/deprecated items
  xml         to make Docutils-native XML files
  pseudoxml   to make pseudoxml-XML files for display purposes
  linkcheck   to check all external links for integrity
  doctest     to run all doctests embedded in the documentation (if enabled)
  coverage    to run coverage check of the documentation (if enabled)

```

## 生成静态网站

完成上面步骤，你可以在build目录中看到一个完整的网站代码，这里我们就拥有一个完整的函数式（静态）网站。

在 build 目录内，现在应该有两个目录：doctrees 和 HTML。我们对于这个存储了文档网站所需的全部文件的 HTML 目录很感兴趣。使用浏览器打开 index.html 文件，

![image](http://104.224.172.75/wp-content/uploads/2016/10/sphinx.png)

 虽然信息很少，但 Sphinx 能够创建很多内容。我们拥有一个基本布局，该布局包含有关项目文档、搜索部分、内容表、附带名称和日期的版权声明、页码的一些信息。

搜索部分非常有趣，因为 Sphinx 已经为所有文件建立索引，并使用 JavaScript 的一些强大功能创建了一个可搜索的静态网站。

还记得我们已将 example 作为一个单独的文件添加至`toctree` 中的文档吗？您可以看到，主标题显示为内容索引中的主要项目符号，副标题显示为二级项目符号。Sphinx 小心维护着让整个结构保持正确。

所有的链接都指向文档中的正确位置，并且标题和副标题均有定位点，允许直接进行链接。比如，Subject Subtitle 部分在浏览器中有一个类似 ../example.html#subject-subtitle 的定位点。如前所述，该工具消除了我们对这些琐碎的、重复的需求的顾虑。

## 添加图像

简明的段落、图像和图形都为项目文档增加趣味性和可读性。Sphinx 有助于利用这些有可能添加了静态文件的主要元素来吸引读者的注意。

添加静态文件的正确语法很容易记忆。只要将静态文件放置 _static 目录（Sphinx 在创建文档布局时创建了该目录）中，就可以轻松地对其进行引用。在 清单 9，查看 reStructuredTex 文件中的引用应该是什么样子的。在本例中，我将其添加在 example.rst 的底部。

**清单 7. example.rst 的静态清单**

```
.. image:: _static/system_activity.jpg
```
生成文档之后，应将图像正确放置在我们为有关系统活动的 JPEG 小图像指定的地方。

## 结束语 

 本文介绍了开始使用 Sphinx 的一些基础知识，但仍有许多内容有待我们探索。Sphinx 能够用不同的格式导出文档，但要求安装额外的库和软件。可生成的格式包括：PDF、epub、man (UNIX Manual Pages) 和 LaTeX。


