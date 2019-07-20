#!/usr/bin/env ruby
require 'xcodeproj'

#打开项目工程
project_path = './testXcodeProj.xcodeproj'
project = Xcodeproj::Project.open(project_path)

#找到要插入的group(参数中的true表示如果找不到group,就创建一个group)
group = project.main_group.find_subpath('testXcodeProj/NewGroup',true)
#设置sorce_tree 值 表示组所相对的路径
# 这里是不同 source_tree 的一些具体含义
# Note: The accepted values are:
# <absolute> for absolute paths
# <group> 相对于 group的路径
# SOURCE_ROOT 相对于 project的路径
# DEVELOPER_DIR for paths relative to the developer directory.
# BUILT_PRODUCTS_DIR for paths relative to the build products directory.
# SDKROOT for paths relative to the SDK directory 引入系统库时候设置的相对路径.

# group.set_source_tree('SOURCE_ROOT')
# 这里可以采用👆上面的方式设置source_tree,也可以设置成相对于当前父group路径，然后给group设置一个路径为根目录
#group.set_source_tree('<group>')
#group.set_path('../Code')
#向group中增加文件引用（.h文件只需引用一下，.m引用后还需add一下）
file_ref = group.new_reference('testXcode.bundle')

#设置h和m文件的路径
file_ref.set_source_tree('SOURCE_ROOT')
file_ref.set_path('Resource/testXcode.bundle')
file_ref.name = 'testXcode.bundle'

targetIndex = 0
project.targets.each_with_index do |target, index|
    puts "#{index} : #{target} "
    #if target.name == "CTPH5Container.xcodeproj"
    #end
end

target = project.targets[0]
target.add_resources([file_ref])

project.save
