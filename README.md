# Xcode工程文件pbxproj



`Xcode会去读Project.pbxproj文件，把pbxproj转成plist文件，看起根目录结构`

![pbxproj根结构](/uploads/fe9f51f51833bcba069b7dd0e11f03a9/pbxproj根结构.jpg)

- rootObject：指向的是我们的工程对象。（对应一个24个16进制字符，96位的UUID，具体生成规则没有确切文档说明，Xcodeproj使用的是 日期+进程ID+MAC地址组合成一个唯一ID，任何一个文件都对应一个uuid，并且一定属于某个组内，工程根目录所在组为mainGroup）
- objects:`工程中的所有配置都在这里`
- archiveVersion：打包版本？？？
- objectVersion：Xcode兼容的版本？？？例如 Xcode 9.3以上兼容？？？官方没有具体说，参考 XcodeCompatibilityVersion枚举值。
- classes：空字段暂时不知道含义



### Xcode解读工程树形结构

- Xcode读取rootObject值，找到工程uuid。并在`objects对象`中寻找rootObject对象。

- rootObject的isa类型是PBXProject类型，表示是工程对象，我们看看工程对象的包含了哪些东西

  - attributes 属性，包含一些编译器的基本信息，版本，以及项目中的target，每一个target一个UUID其中，Xcode自动创建的项目里面有三个target一个就是所要编译的APP主target，其余两个为test Target，可以看到其余两个target中有一个字段TestTargetID指向主target，可以理解为依赖相关吧
  - buildConfigurationList 配置列表 指向一个配置字典 XCConfigurationList 类型类型
  - compatibilityVersion （兼容版本 目前看来是 Xcode 3.2）
  - developmentRegion 语言版本，English英语
  - hasScannedForEncodings 是否已经扫描了文件编码信息
  - knownRegions 不同区域的本地资源文件列表
  - `mainGroup Xcode的文件组织形式，可以理解为文件层次 PBXGroup 类型`
  - productRefGroup  编译后的输出文件 PBXGroup 类型
  - projectDirPath 项目路径
  - projectRoot 项目的根目录
  - targets 项目下的N个target对象 PBXNativeTarget类型

- 根据mainGroup的uuid找到对应的对象，Xcode打开工程对比配置

  ![Rectangle_2x](/uploads/0131b96df227cb130795c532c85c534e/Rectangle_2x.png)

- 根据children中的uuid又可以找到对应的组对象，组对象又会包含其他的对象，形成树形结构



## objects中包含的集合对象

- PBXProject （工程包含所有信息）

- PBXNativeTarget  section（点击工程project那一栏）

- XCBuildConfiguration （没错 这个就是我们经常看见的build Setting选项卡的内容 对应各个target的  buildSetting）

- XCConfigurationList（Xcode编译模式，指向多个XCBuildConfiguration）

- PBXTargetDependency

- PBXBuildFile 工程构建所需要的源文件，依赖库，资源文件

- PBXBuildPhase  就是Xcode中Build Phases选项卡

- PBXContainerItemProxy

- PBXFileElement（抽象类型，包含文件类型，组类型）

- PBXTarget （编译目标对象）

  ​

## 通过修改配置添加文件到工程和target

### Group的概念

-  group并不一定要是真实文件夹，只是Xcode用于管理文件归类的集合。也可以是真实的文件夹，我们分别创建1个虚拟组和1个真实文件夹组，看看proj文件的变化。我们发现虚拟组的group对象是没有path值的 ，真实文件夹group对象有指定path和sourceTree 来指向文件夹“实际路径”

-  文件也有sourceTree和path两个属性用来指定实际文件路径。

-  给一个实体group添加文件Demo

-  给一个虚拟group添加文件Demo



## 添加库到target

-  添加系统库依赖

-  添加三方库依赖


## 修改Build Setting 设置

编译依赖配置分为工程配置和目标对象配置。

-  修改目标依赖，见demo

-  修改工程依赖，见demo  




## 整个pbxproj文件结构图

![project.pbxproj文件_iOS小熊制作_](/uploads/db3f52624c55f4e2c420a8c744da6bd4/project.pbxproj文件_iOS小熊制作_.png)



### XcodeProj脚本demo

<http://10.10.15.98/xiaoxiong/testXcodeProj>

脚本功能目录

添加文件到虚拟group脚本--addFileToInventedGroup.rb   

添加文件到有实体文件夹的group脚本--addFileToGroup.rb   

添加系统库给target脚本--addFrameWorkToTarget.rb   

添加三方库给target脚本--addThirdFrameWorkToTarget.rb   



进入到工程根目录，在执行对应功能的脚本

```
cd /xxx/xxx/testXcodeProj
ruby ./Script/addThirdFrameWorkToTarget.rb
```



### 3.参考网站

project.pbxproj结构参考 <https://yulingtianxia.com/blog/2016/09/28/Let-s-Talk-About-project-pbxproj/>

<https://www.jianshu.com/p/e82ec6a56fc2>（Xcode工程文件project.pbxproj小结）

官网结构文档 <http://www.monobjc.net/xcode-project-file-format.html>

<https://www.jianshu.com/p/bd4e3c1a7276#>（xcode工程文件格式说明 翻译官网）

<https://blog.csdn.net/darya_1/article/details/78095821>（xcodeproj使用心得）

Xcodeproj源码详解

<https://www.jianshu.com/p/84936d9344ff>（cocoapods做了什么 ）

<https://www.jianshu.com/p/98029cf49a69>（Xcodeproj: 使用 ruby 自由的修改Xcode 工程文件）

<https://blog.csdn.net/skylin19840101/article/details/64905318>(各语言版本的解析库)

Xcodeproj使用参考网站 <https://www.jianshu.com/p/98029cf49a69>

<https://blog.csdn.net/darya_1/article/details/78095821>

<https://www.jianshu.com/p/03a3f7eafe26>

<https://www.jianshu.com/p/cca701e1d87c>

<https://blog.csdn.net/auccy/article/details/68061889>
