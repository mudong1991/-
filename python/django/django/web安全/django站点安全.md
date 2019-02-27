[TOC]

***

# Django站点安全
> 安全在Web应用开发中是一项至关重要的话题，Django提供了多种保护手段和机制



## 一、django应用安全

django安全概述，包含了一些django网站的驱动的加固建议。

### 1、跨站脚本(XSS)保护

**威胁描述：**

XSS攻击允许用户注入客户端脚本到其他用户的浏览器里。 这通常是通过存储在数据库中的恶意脚本，它将检索并显示给其他用户，或者通过让用户点击一个链接，这将导致攻击者的 JavaScript 被用户的浏览器执行。 然而，XSS 攻击可以来自任何不受信任的源数据，如 Cookie 或 Web 服务，任何没有经过充分处理就包含在网页中的数据。

**安全保护：**

使用 Django 模板保护你免受多数 XSS 攻击。Django 模板会 编码特殊字符 ，这些字符在 HTML 中都是特别危险的。 虽然这可以防止大多数恶意输入的用户，但它不能完全保证万无一失。

### 2、跨站请求伪造 (CSRF) 防护

**威胁描述：**

CSRF 攻击允许恶意用户在另一个用户不知情或者未同意的情况下，以他的身份执行操作。

**安全保护：**

Django 对大多数类型的 CSRF 攻击有内置的保护，在适当情况下你可以开启并使用它 。

CSRF 防护 是通过检查每个 POST 请求的一个随机数（nonce）来工作。 这确保了恶意用户不能简单“回放”你网站上面表单的POST，以及让另一个登录的用户无意中提交表单。恶意用户必须知道这个随机数，它是用户特定的（存在cookie里）。

使用 HTTPS来部署的时候，CsrfViewMiddleware会检查HTTP referer协议头是否设置为同源的URL（包括子域和端口）。因为HTTPS提供了附加的安全保护，转发不安全的连接请求时，必须确保链接使用 HTTPS，并使用HSTS支持的浏览器。

使用csrf_exempt装饰器来标记视图时，要非常小心，除非这是极其必要的。

### 3、SQL 注入保护

**威胁描述：**

SQl注入是一种攻击类型，恶意用户可以在系统数据库中执行任意SQL代码。这可能会导致记录删除或者数据泄露。

**安全保护：**

通过使用Django的查询集，产生的SQL会由底层数据库驱动正确地转义。然而，Django也允许开发者编写原始查询或者执行自定义sql。这些功能应该谨慎使用，并且你应该时刻小心正确转义任何用户可以控制的参数。另外，你在使用extra()（这个方法可以直接执行注入sql语句）的时候应该谨慎行事。

###4、点击劫持保护

**威胁描述：**

点击劫持是一类攻击，恶意站点在一个frame中包裹了另一个站点。这类攻击可能导致用户被诱导在目标站点做出一些无意识的行为。

**安全保护：**

Django在X-Frame-Options 中间件的表单中中含有 点击劫持保护 ，它在支持的浏览器中可以保护站点免于在frame中渲染。也可以在每个视图中禁止这一保护，或者配置要发送的额外的协议头。

对于任何不需要将页面包装在三方站点的frame中，或者只需要包含它的一部分的站点，都强烈推荐启用这一中间件。

**SSL/HTTPS:**

把你的站点部署在HTTPS下总是更安全的，尽管不是在所有情况下都有效。如果不这样，恶意的网络用户可能会嗅探授权证书，或者其他在客户端和服务端之间传输的信息，或者一些情况下 活跃的网络攻击者会修改在两边传输的数据。

### 4、Session 会话安全

类似于部署在站点上的CSRF 限制 使不受信任的用户不能访问任何子域，django.contrib.sessions也有一些限制。

### 5、额外的安全话题

虽然Django提供了开箱即用的，良好的安全保护，但是合理地部署你的应用，以及利用web服务器、操作系统和其他组件的安全保护仍然很重要。

- 确保你的Python代码在web服务器的根目录外。这会确保你的Python代码不会意外被解析为纯文本（或者意外被执行）。
- 小心处理任何用户上传的文件。
- Django并不限制验证用户的请求。要保护对验证系统的暴力破解攻击，你可以考虑部署一个DJango的插件或者web服务器模块来限制这些请求。
- 秘密保存SECRET_KEY。
- 使用防火墙来限制缓存系统和数据库的访问是个好方法。


## 二、点击劫持保护

点击劫持中间件（'django.middleware.clickjacking.XFrameOptionsMiddleware'）和装饰器提供了简捷易用的，对点击劫持的保护。这种攻击在恶意站点诱导用户点击另一个站点的被覆盖元素时出现，另一个站点已经加载到了隐藏的frame或iframe中。

### 点击劫持防御

现代浏览器遵循X-Frame-Options协议头，它表明一个资源是否允许加载到frame或者iframe中。如果响应包含值为SAMEORIGIN的协议头，浏览器会在frame中只加载同源请求的的资源。如果协议头设置为DENY，浏览器会在加载frame时屏蔽所有资源，无论请求来自于哪个站点。

Django提供了一些简单的方法来在你站点的响应中包含这个协议头：

- 一个简单的中间件，在所有响应中设置协议头。
- 一系列的视图装饰器，可以用于覆盖中间件，或者只用于设置指定视图的协议头。

### 使用方法

**1、为所有响应设置X-Frame-Options**

要为你站点中所有的响应设置相同的X-Frame-Options值，将'django.middleware.clickjacking.XFrameOptionsMiddleware'设置为 MIDDLEWARE_CLASSES：

    MIDDLEWARE_CLASSES = (
    ...
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    ...
    )

通常，这个中间件会为任何开放的HttpResponse设置X-Frame-Options协议头为SAMEORIGIN。如果你想用 DENY来替代它，要设置X_FRAME_OPTIONS：

    X_FRAME_OPTIONS = 'DENY'

使用这个中间件时可能会有一些视图，你并不想为它设置X-Frame-Options协议头。对于这些情况，你可以使用一个视图装饰器来告诉中间件不要设置协议头：

    from django.http import HttpResponse
    from django.views.decorators.clickjacking import xframe_options_exempt

    @xframe_options_exempt
    def ok_to_load_in_a_frame(request):
        return HttpResponse("This page is safe to load in a frame on any site.")

**2、 为每个视图设置 X-Frame-Options **

Django提供了以下装饰器来为每个基础视图设置X-Frame-Options协议头。

    from django.http import HttpResponse
    from django.views.decorators.clickjacking import xframe_options_deny
    from django.views.decorators.clickjacking import xframe_options_sameorigin

    @xframe_options_deny
    def view_one(request):
        return HttpResponse("I won't display in any frame!")

    @xframe_options_sameorigin
    def view_two(request):
        return HttpResponse("Display in a frame if it's from the same origin as me.")

**3、限制**

支持X-Frame-Options浏览器

- Internet Explorer 8+
- Firefox 3.6.9+
- Opera 10.5+
- Safari 4+
- Chrome 4.1+

## 三、跨站伪造保护

CSRF 中间件和模板标签提供对跨站请求伪造简单易用的防护。某些恶意网站上包含链接、表单按钮或者JavaScript ，它们会利用登录过的用户在浏览器中的认证信息试图在你的网站上完成某些操作，这就是跨站攻击。还有另外一种相关的攻击叫做“登录CSRF”，攻击站点触发用户浏览器用其它人的认证信息登录到其它站点。


### 如何使用

1、加入中间件'django.middleware.csrf.CsrfViewMiddleware'，如果你关闭了它，虽然不建议，你可以在你想要保护的视图上使用csrf_protect()

2、在使用POST 表单的模板中，对于内部的URL请在<form> 元素中使用csrf_token 标签：

    <form action="." method="post">
    {% csrf_token %}
    </from>

3、在对应的视图函数中，确保使用 'django.template.context_processors.csrf' Context 处理器。

1）通常我们使用RequestContext（request）来处理上下文，一般通用视图都使用到了RequestContext。

2）手工导入并使用处理器来生成CSRF token，并将它添加到模板上下文中。例如：

    from django.shortcuts import render_to_response
    from django.template.context_processors import csrf

    def my_view(request):
        c = {}
        c.update(csrf(request))
        # ... view code here
        return render_to_response("a_template.html", c)

### AJAX

获取CSRF token，可以使用jquery cookies plugin来获取：

    var csrftoken = $.cookie('csrftoken');


### 一些视图装饰器方法

1）csrf_protect

给视图提供csrf保护

2）csrf_exempt

豁免保护，例如

    from django.views.decorators.csrf import csrf_exempt
    from django.http import HttpResponse

    @csrf_exempt
    def my_view(request):
        return HttpResponse('Hello world')

## 四、加密签名

web应用安全的黄金法则是，永远不要相信来自不可信来源的数据。有时通过不可信的媒介来传递数据会非常方便。密码签名后的值可以通过不受信任的途径传递，这样是安全的，因为任何篡改都会检测的到。

### 保护 SECRET_KEY

当你使用 startproject创建新的Django项目时，自动生成的 settings.py文件会得到一个随机的SECRET_KEY值。这个值是保护签名数据的密钥 -- 它至关重要，你必须妥善保管，否则攻击者会使用它来生成自己的签名值。

### 使用底层 API

    >>> django.core.signing import Signer
    >>> signer = Signer()
    >>> signer.sign('My string')
    'My string:GdMGD6HNQ_qdgxYP8yBZAdAIV1w'
    >>> signer = Signer(salt='extra')
    >>> signer.sign('My string')
    'My string:Ee7vGi-ING6n02gkcJ-QLHg6vFw'
    >>> signer.unsign('My string:Ee7vGi-ING6n02gkcJ-QLHg6vFw')
    'My string'

数据结构的加解密

    >>> from django.core import signing
    >>> value = signing.dumps({"foo": "bar"})
    >>> value
    'eyJmb28iOiJiYXIifQ:1NMg1b:zGcDE4-TCkaeGzLeW9UQwZesciI'
    >>> signing.loads(value)
    {'foo': 'bar'}

## 五、安全中间件

如果你的部署环境允许的话，让你的前端web服务器展示SecurityMiddleware提供的功能是个好主意。这样一来，如果有任何请求没有被Django处理（比如静态媒体或用户上传的文件），它们会拥有和向Django 应用的请求相同的保护。

django.middleware.security.SecurityMiddleware为请求/响应循环提供了几种安全改进。每一种可以通过一个选项独立开启或关闭。

- SECURE_BROWSER_XSS_FILTER
- SECURE_CONTENT_TYPE_NOSNIFF
- SECURE_HSTS_INCLUDE_SUBDOMAINS
- SECURE_HSTS_SECONDS
- SECURE_REDIRECT_EXEMPT
- SECURE_SSL_HOST
- SECURE_SSL_REDIRECT

**1、HTTP Strict Transport Security (HSTS)**

对于那些应该只能通过HTTPS访问的站点，你可以通过设置HSTS协议头，通知现代的浏览器，拒绝用不安全的连接来连接你的域名。这会降低你受到SSL-stripping的中间人（MITM）攻击的风险。

如果你将SECURE_HSTS_SECONDS设置为一个非零值，SecurityMiddleware会在所有的HTTPS响应中设置这个协议头。

开启HSTS的时候，首先使用一个小的值来测试它是个好主意，例如，让SECURE_HSTS_SECONDS = 3600为一个小时。每当浏览器在你的站点看到HSTS协议头，都会在提供的时间段内拒绝使用不安全（HTTP）的方式连接到你的域名。一旦你确认你站点上的所有东西都以安全的方式提供（例如，HSTS并不会干扰任何事情），建议你增加这个值，这样不常访问你站点的游客也会被保护（比如，一般设置为31536000秒，一年）。

另外，如果你将 SECURE_HSTS_INCLUDE_SUBDOMAINS设置为True,，SecurityMiddleware会将includeSubDomains标签添加到Strict-Transport-Security协议头中。强烈推荐这样做（假设所有子域完全使用HTTPS），否则你的站点仍旧有可能由于子域的不安全连接而受到攻击。

`注意`

如果你的站点部署在负载均衡器或者反向代理之后，并且Strict-Transport-Security协议头没有添加到你的响应中，原因是Django有可能意识不到这是一个安全连接。你可能需要设置SECURE_PROXY_SSL_HEADER。

    SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

**2、 X-Content-Type-Options: nosniff**

一些浏览器会尝试猜测他们所得内容的类型，而不是读取Content-Type协议头。虽然这样有助于配置不当的服务器正常显示内容，但也会导致安全问题。

如果你的站点允许用户上传文件，一些恶意的用户可能会上传一个精心构造的文件，当你觉得它无害的时候，文件会被浏览器解释成HTML或者Javascript。

要防止浏览器猜测内容类型，并且强制它一直使用 Content-Type协议头中提供的类型，你可以传递X-Content-Type-Options: nosniff协议头。SecurityMiddleware将会对所有响应这样做，如果SECURE_CONTENT_TYPE_NOSNIFF 设置为True。

**3、X-XSS-Protection: 1; mode=block**

一些浏览器能够屏蔽掉出现XSS攻击的内容。通过寻找页面中GET或者POST参数中的JavaScript内容来实现。如果JavaScript在服务器的响应中被重放，页面就会停止渲染，并展示一个错误页来取代。

X-XSS-Protection协议头用来控制XSS过滤器的操作。

要在浏览器中启用XSS过滤器，并且强制它一直屏蔽可疑的XSS攻击，你可以在协议头中传递X-XSS-Protection: 1; mode=block。  如果SECURE_BROWSER_XSS_FILTER设置为True，SecurityMiddleware会在所有响应中这样做。

**4、SSL重定向**

如果你同时提供HTTP和HTTPS连接，大多数用户会默认使用不安全的（HTTP）链接。为了更高的安全性，你应该重定向所有的HTTP 连接到HTTPS。

如果你将SECURE_SSL_REDIRECT设置为True，SecurityMiddleware会将HTTP链接永久地（HTTP 301，permanently）重定向到HTTPS连接。

`注意`

由于性能因素，最好在Django外面执行这些重定向，在nginx这种前端负载均衡器或者反向代理服务器中执行。SECURE_SSL_REDIRECT专门为这种部署情况而设计，当这不可选择的时候。

如果你在负载均衡器或者反向代理服务器后面部署应用，而且Django不能辨别出什么时候一个请求是安全的，你可能需要设置SECURE_PROXY_SSL_HEADER。

## 六、SQL注入攻击保护

 方案一

总是使用Django自带的数据库API。它会根据你所使用的数据库服务器（例如PostSQL或者MySQL）的转换规则，自动转义特殊的SQL参数。这被运用到了整个Django的数据库API中，只有一些例外：

传给 extra() 方法的 where 参数。 (参考 附录 C。) 这个参数故意设计成可以接受原始的SQL。

使用底层数据库API的查询。

方案二

看下面的Python代码：

    from django.db import connection
    def user_contacts(request):

        user = request.GET['username']

        sql = "SELECT * FROM user_contacts WHERE username = %s"

        cursor = connection.cursor()

        cursor.execute(sql, [user])

    # ... do something with the results

请注意在cursor.execute() 的SQL语句中使用“%s”，而不要在SQL内直接添加参数。 如果你使用这项技术，数据库基础库将会自动添加引号，同时在必要的情况下转意你的参数。

## web恶意扫描保护

