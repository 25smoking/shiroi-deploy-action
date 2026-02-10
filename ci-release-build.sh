#!/bin/bash
set -e

# 1. 编译项目
pnpm build

# 2. 准备打包环境（进入构建产物目录）
cd .next

# 清理缓存并创建 standalone 目录结构
rm -rf cache
mkdir -p standalone/public
mkdir -p standalone/.next/static

# 3. 复制静态资源（关键步骤：Next.js standalone 模式默认不带这些）
# 复制 public 文件夹
cp -r ../public/* ./standalone/public/ || true
# 复制 _next/static 文件夹
cp -r static/* ./standalone/.next/static/ || true

# 4. 复制配置文件（如果有的话）
cp ../ecosystem.config.js ./standalone/ 2>/dev/null || true

# 5. 打包成 zip
# 回到上级目录
cd ..
mkdir -p assets

# 检查是否有 zip 命令，然后打包
if command -v zip >/dev/null 2>&1; then
    echo "Creating release.zip..."
    # 将 .next/standalone 文件夹打包到 assets/release.zip
    zip -r -q assets/release.zip .next/standalone
else
    echo "Error: zip command not found"
    exit 1
fi

echo "Build and packaging done!"
