#!/bin/bash

# 设置语言环境为UTF-8
export LANG=en_US.UTF-8

# 初始化文件计数器
counter=0

# 获取当前目录下所有未被git追踪的新文件或已修改的文件列表
untracked_files=$(git ls-files --others --exclude-standard)
modified_files=$(git diff --name-only HEAD)

# 合并未被追踪和已修改的文件列表
all_files="$untracked_files
$modified_files"

# 遍历所有需要处理的文件
for file in $all_files; do
    # 增加文件计数器
    ((counter++))

    # 执行git add针对具体文件
    git add "$file"
    echo "$file"
    # 当文件计数器达到100时，执行git commit和push
    if [ $((counter % 100)) -eq 0 ]; then
        git commit -m "Processed files up to number $counter"
        git push origin main
    fi
done

# 处理最后不足100个文件的情况
if [ $((counter % 100)) -ne 0 ]; then
    git commit -m "Processed final set of files, total count $counter"
    git push origin main
fi
