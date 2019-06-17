#!/usr/bin/env ruby
require 'xcodeproj'

#打开项目工程 
project_path = './testXcodeProj.xcodeproj'
project = Xcodeproj::Project.open(project_path)

#创建framework文件引用
file_path = 'ThirdFramework/BMKLocationKit.framework'
file_ref = project.frameworks_group.new_reference(file_path)
#设置文件路径的根路径
file_ref.set_source_tree('SOURCE_ROOT')
file_ref.name = 'BMKLocationKit.framework'
#找到目标对象
targetIndex = 0
project.targets.each_with_index do |target, index|
    puts "#{index} : #{target} "
    #if target.name == "CTPH5Container.xcodeproj"
    #end
end

target = project.targets[0]
#添加文件引用到build phases中
target.frameworks_build_phases.add_file_reference(file_ref)
#设置索引 FRAMEWORK_SEARCH_PATHS
target.build_configurations.each do |config|
    config.build_settings["FRAMEWORK_SEARCH_PATHS"] = ["$(inherited)","$(PROJECT_DIR)/ThirdFramework"]
end

project.save
