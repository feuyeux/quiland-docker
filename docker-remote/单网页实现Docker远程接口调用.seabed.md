所谓单网页应用(SPA/SPI)，就是整个前端应用只有一个html页面，所有的响应式交互、用户交互都基于页面不跳转的前提下，通过JavaScript和css/less完成。 换句话说，SPA完全可以做到只使用纯html和JavaScript来实现，而无需传统的服务器端语言参与。

1.技术栈
--------

### 1.1.前端MVC框架

单网页技术日臻成熟，可以选择的前端框架不胜枚举，这里以backbone作为前端框架，实现单网页对Docker remote API的调用和展示。 当前backbone的最新版本是1.1.2，其内部依赖underscore：

-	backbone 1.1.2 http://backbonejs.org/backbone-min.js
-	underscore 1.7.0 http://underscorejs.org/underscore-min.js

### 1.2.异步请求

jQuery是backbone的可选依赖，由于jQuery的普及性，考虑在本实现中，主要用于ajax操作。

-	jQuery 2.1.1 http://code.jquery.com/jquery-2.1.1.min.js

### 1.3.页面模板

backbone本身提供了完整而简约的MVC框架，封装了model和collection作为对象和对象集合的单位、 封装了view作为页面展示的基本单元、封装了router作为导航的操作单元，同时提供了支持el表达式的template实现在html页面中对JavaScript对象的调用。

但是，backbone的简约和轻量不足以简化开发过程，还好，backbone有很成熟的生态系统，从不同角度支持和扩展了backbone功能。 这里选择backbone.layoutmanager作为模板组件，简化开发过程。

-	backbone.layoutmanager 0.9.5 https://raw.githubusercontent.com/tbranyen/backbone.layoutmanager/master/backbone.layoutmanager.js

### 1.4.AMD

AMD不是不是指代中央处理器的制造商！而是指JavaScript的异步模块定义（如果你想到了CMD和玉伯大师的seajs，恭喜你已经会抢答了）,其意义在于减少页面加载时的延时，原理是避免一次将页面定义的全部JavaScript请求并加载到页面，而是在真正使用时再加载。 requiredjs的通用性是被选择的主要因素。

-	requiredjs 2.1.15 http://requirejs.org/docs/release/2.1.15/minified/require.js

### 1.5.响应式设计及页面渲染

bootstrap的普及性无需多言地成为这一角色，有了bootstrap不仅可以使页面样式整洁统一，还可以实现响应式交互，这样就算应用被移动设备访问，也会很流鼻地展示。bootstrap很好地集成了glyphicons，可以使土宅轻易地将绚(su)烂(tao)的图形引入按钮或文字之间。

-	bootstrap 3.2.0: https://github.com/twbs/bootstrap/releases/download/v3.2.0/bootstrap-3.2.0-dist.zip
-	[glyphicons](http://glyphicons.bootstrapcheatsheets.com/)

### 1.6.JSON的解析和展示

backbone提供了model对应json对象的能力，我们无需像在Java中使用JAXB那样苦逼地逐个字段定义。 但是，在html中还是要通过模板来逐个字段地敲在span、td等字里行间。 死程的痛苦就是接受不了枯燥的体力劳动。因此，有必要引入一个解析工具，让json直接变成html的element。那就是json.human，看上去很像superman。

-	JSON HUMAN [https://raw.githubusercontent.com/marianoguerra/json.human.js/master/src/json.human.js](https://github.com/marianoguerra/json.human.js)

### 1.7.Docker RESTful API:

既然本应用是要访问和展示Docker，势必要深入研究docker的remote api。这套api完全符合RESTful风格， 只是官网极其严谨地说，某些操作，比如stream上的交互，走http还是不靠谱，所以我们提供的api近乎RESTful。

-	docker remote api [https://docs.docker.com/reference/api/docker_remote_api_v1.15](https://docs.docker.com/reference/api/docker_remote_api_v1.15/)

### 2.功能概述

-	获取镜像列表和某个镜像的详情 ![screenshot](http://img1.tbcdn.cn/L1/461/1/38092924ff05714a83d1814aaf2390e56fdd808f)
-	获取容器列表和某个容器的详情 ![screenshot](http://img4.tbcdn.cn/L1/461/1/5901e3852391cc3c6f83276bc66b20c9eecd3ecb)
-	增加新镜像
-	增加新容器
-	执行容器管理的各类操作

### 3.实现分享

> 本文的docker环境请参考[[Docker系列·13] 使用fig启动容器](http://www.atatech.org/articles/25614)

上面介绍了技术栈和功能，在此分享单网页应用的结构和流程。 这里以容器列表的展示为例。

#### 3.1.html相关代码

```html
<link rel="stylesheet" type="text/css" href="css/seabed.css"/>

<script src="lib/require-2.1.15.js" defer async="true" type="text/javascript" data-main="js/seabed"></script>
```

在html页面中，对css和JavaScript的定义各只有一句， 那么第三方的依赖库和自定义实现都在哪里呢？ 这是前述的AMD风格的具体实现，随后揭晓。

```javascript
 <script class="template" type="template" id="container-list-pane">
  ……
    <% containers.each(function(container) { %>
    <tr>
        <td><a href="#container/<%= container.get('Id') %>"><%= container.get('Names') %></a></td>
        <!--<td><%= container.get('Id').substring(0,12) %></td>-->
        <!--<td><%= container.get('Created') %></td>-->
        <td><%= container.get('Image') %></td>
        <td><%= container.get('Status') %></td>
        <td>
            <% if(container.get('Ports').length>0) { %>
            <table class="table table-condensed">
                <thead>
                <tr class="bg-info">
                    <td>IP</td>
                    <td>PrivatePort</td>
                    <td>PublicPort</td>
                    <td>Type</td>
                </tr>
                </thead>
                <tbody>
                <% _.each(container.get('Ports'),function(port) { %>
                <tr>
                    <td><%= port['IP'] %></td>
                    <td><%= port['PrivatePort']%></td>
                    <td><%= port['PublicPort'] %></td>
                    <td><%= port['Type']%></td>
                </tr>
                <% });%>
                </tbody>
            </table>
            <% }%>
        </td>
    </tr>
    <% });%>
  ……
    </script>
```

这段代码片段是对容器列表的展示。其中使用了backbone.layoutmanager和el表达式。

-	containers是backbone的collection对象，是json格式的容器对象列表
-	container是each迭代中的model对象，是json格式的容器对象
-	迭代内部使用了_.each，而不是我们常见的for或者while循环，以_开头的调用使用了underscore库，在模板中el的使用是在backbone的执行上下文中的，而underscore是backbone的内部依赖
-	<%= container.get('Id') %>是backbone模板所支持的获取JavaScript变量值的方式，container是json对象，container.get是获取json对象的字段值
-	<%= port['IP'] %>是获取数组字典值的方式，IP是key

#### 3.2.AMD实现

```javascript
require.config({
    baseUrl: "lib",
    paths: {
        "jquery": "jquery-2.1.1",
        "underscore": "underscore-1.7.0",
        "backbone": "backbone-1.1.2",
        "human": "json.human",
        "layoutmanager": "backbone.layoutmanager-0.9.5",
        "boostrap": "bootstrap-3.2.0-dist/js/bootstrap.min.js"
    },
    shim: {
        'underscore': {
            exports: '_'
        },
        'backbone': {
            deps: ['underscore', 'jquery'],
            exports: 'Backbone',
            init: function (_, $) {
                Backbone.$ = $;
                return Backbone;
            }
        }
    }
});

define(['backbone', 'layoutmanager', '../js/workspace'], function (Backbone, layoutmanager, Workspace) {
    var init = function () {
        window.workspace = new Workspace();
        Backbone.history.start();
    };
    return {
        initialize: init()
    }
});
```

-	require.config是requre.js的配置，用于以AMD风格加载全部的依赖库
-	Backbone.history.start将开启history堆栈的记录
-	workspace是backbone的router对象

#### 3.3.model和collection

```javascript
define(['backbone', 'human', '../js/seabedConfig'], function (Backbone, JsonHuman, seabedConfig) {
    var DockerContainer = Backbone.Model.extend({
        toHumanConfig: function () {
            var humanConfig = JsonHuman.format(this.attributes);
            return humanConfig;
        },
        defaults: {
            Id: "-1"
        },
        idAttribute: "Id"
    });
    return DockerContainer;
});

define(['backbone', '../js/dockerContainer', '../js/seabedConfig'], function (Backbone, DockerContainer, seabedConfig) {
    var DockerContainerList = Backbone.Collection.extend({
        model: DockerContainer,
        url: seabedConfig.dockerContainersURL + RUNNING,
    });
    return DockerContainerList;
});
```

AMD的要求是，模块的定义必须有返回值。

#### 3.4.view

```javascript
define(['backbone', 'layoutmanager'],
function (Backbone, layoutmanager) {
    var DockerContainerLitPane = Backbone.Layout.extend({
        template: '#container-list-pane',
        serialize: function () {
            return {containers: _.chain(this.collection.models)};
        },
        initialize: function () {
            this.listenTo(this.collection, 'reset', this.render);
        }
    });
    return DockerContainerLitPane;
});

* template对应页面上的模板id
* initialize是backbone加载该对象时的“构造函数”
* serialize是layoutmanager有别于backbone的“构造函数”，containers就是前述页面中使用的JavaScript对象别名

```

#### 3.5.导航和页面切换

```javascript
<a class="btn btn-default glyphicon glyphicon-th" href="#containers/"> 容器</a>

routes: {
……
  'containers/': 'containers',
}

containers: function () {
    this.collection = new DockerContainerList();
    var listPane = new DockerContainerListPane({collection: this.collection})
    window.workspace.layout.setView('#container-list-pane', listPane);
    window.workspace.layout.removeView('#image-list-pane');
    window.workspace.layout.removeView('#image-info-pane');
    /*
     * 200 – no error
     * 400 – bad parameter
     * 500 – server error
     */
    this.collection.fetch({
        async: false,
        success: function (collection, response, options) {
            var filterType = _.filter(collection.models, function (item) {
                var name = item.get("Names")[0];
                return name != "<none>";
            });
            collection.reset(filterType);
        },
        error: function (collection, response, options) {
            console.error("[containers] Error status=" + response.status + ",Error Text=" + response.statusText);
        },
        reset: true,
        data: {page: 5}
    });
},

```

-	页面上定义了按钮形式的锚点，请求的资源地址是#containers/
-	backbone的router将其映射到containers方法
-	fetch是对ajax的http get请求的封装
-	layout.setView和removeView是SPA的灵魂，就是说靠一张网页如何实现对用户交互的响应呢？删除旧的div，使用新的渲染。这样看上去就像进入了一张新的页面。

### 4.坑

#### 4.1.jquery还是jQuery

backbone.layoutmanager内部使用了jquery作为关键字，因此这个别名还不能随便定义。

本文后续会做进一步更新，今天先到这里……
