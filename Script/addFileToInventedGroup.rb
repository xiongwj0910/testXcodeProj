#!/usr/bin/env ruby
require 'xcodeproj'

#打开项目工程 
project_path = './testXcodeProj.xcodeproj'
project = Xcodeproj::Project.open(project_path)

#找到要插入的group(参数中的true表示如果找不到group,就创建一个group)
group = project.main_group.find_subpath('testXcodeProj/ViewModel',true)

puts #{group}
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
file_ref = group.new_reference('test.h')
file_ref_m = group.new_reference('test.m')



#设置h和m文件的路径
file_ref.set_source_tree('SOURCE_ROOT')
file_ref.set_path('Code/test.h')
file_ref.name = 'test.h'
file_ref_m.set_source_tree('SOURCE_ROOT')
file_ref_m.set_path('Code/test.m')
file_ref_m.name = 'test.m'
targetIndex = 0
project.targets.each_with_index do |target, index|
    puts "#{index} : #{target} "
    #if target.name == "CTPH5Container.xcodeproj"
    #end
end
target = project.targets[0]
target.add_file_references([file_ref_m])


file_ref_T = project.reference_for_path('/Users/xiongwenjie/Desktop/code/testXcodeProj/Code/test.m')
puts "---- #{file_ref_T.class},#{file_ref_m.class}"

#添加单个文件的编译配置
build_file = target.source_build_phase.build_file(file_ref_T)
build_file.settings = Hash.new
build_file.settings["COMPILER_FLAGS"] = "-w -DSQLITE_HAS_CODEC -DHAVE_USLEEP=1 -DSQLITE_TEMP_STORE=3 -DSQLCIPHER_CRYPTO_CC -DSQLITE_LOCKING_STYLE=1 -DNDEBUG -DSQLITE_THREADSAFE=1 -DSQLITE_DEFAULT_SYNCHRONOUS=3 -DSQLITE_DEFAULT_MEMSTATUS=0 -DSQLITE_OMIT_DECLTYPE -DSQLITE_OMIT_DEPRECATED -DSQLITE_OMIT_PROGRESS_CALLBACK -DSQLITE_OMIT_SHARED_CACHE -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_JSON1"

puts "====#{target.source_build_phase},#{build_file.class}"

project.save
