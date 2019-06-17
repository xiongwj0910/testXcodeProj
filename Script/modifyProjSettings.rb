#!/usr/bin/env ruby
require 'xcodeproj'

#打开项目工程 
project_path = './testXcodeProj.xcodeproj'
project = Xcodeproj::Project.open(project_path)

#设置索引 FRAMEWORK_SEARCH_PATHS
project.build_configurations.each do |config|
    config.build_settings["CLANG_CXX_LANGUAGE_STANDARD"] = "gnu++98"
end

project.save
