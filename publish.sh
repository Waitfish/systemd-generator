#!/bin/bash
# 快速发布脚本

set -e

echo "🦀 Systemd Generator - 发布助手"
echo "================================"
echo ""

# 检查是否在正确的目录
if [ ! -f "Cargo.toml" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    exit 1
fi

# 检查 Git 状态
if [ -d ".git" ]; then
    if [ -n "$(git status --porcelain)" ]; then
        echo "⚠️  警告: 有未提交的更改"
        git status --short
        echo ""
        read -p "是否继续？(y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
fi

# 显示当前版本
CURRENT_VERSION=$(grep '^version' Cargo.toml | head -n 1 | cut -d '"' -f 2)
echo "📦 当前版本: $CURRENT_VERSION"
echo ""

# 询问发布类型
echo "选择发布方式:"
echo "  1) 测试发布 (dry-run)"
echo "  2) 发布到 crates.io"
echo "  3) 创建 GitHub Release (需要先推送代码)"
echo "  4) 全部执行 (crates.io + GitHub tag)"
echo ""
read -p "请选择 (1-4): " choice

case $choice in
    1)
        echo "🧪 执行测试发布..."
        cargo publish --registry crates-io --dry-run
        echo ""
        echo "✅ 测试完成！如果没有错误，可以执行正式发布"
        ;;
    2)
        echo "📤 发布到 crates.io..."
        
        # 检查是否已登录
        if ! cargo login --help &> /dev/null; then
            echo "❌ 请先登录: cargo login YOUR_TOKEN"
            exit 1
        fi
        
        # 构建
        echo "🔨 构建项目..."
        cargo build --release
        
        # 运行测试
        echo "🧪 运行测试..."
        cargo test
        
        # 发布
        echo "📤 发布中..."
        cargo publish --registry crates-io
        
        echo ""
        echo "🎉 发布成功！"
        echo "用户现在可以通过以下命令安装:"
        echo "  cargo install systemd-generator"
        ;;
    3)
        echo "🏷️  创建 GitHub Release..."
        
        if [ ! -d ".git" ]; then
            echo "❌ 错误: 这不是一个 Git 仓库"
            exit 1
        fi
        
        # 创建标签
        TAG="v$CURRENT_VERSION"
        echo "创建标签: $TAG"
        
        git tag -a "$TAG" -m "Release $TAG"
        git push origin "$TAG"
        
        echo ""
        echo "✅ 标签已推送！"
        echo "请访问 GitHub 仓库创建 Release 并上传二进制文件:"
        echo "  target/release/systemd-generator"
        ;;
    4)
        echo "🚀 执行完整发布流程..."
        
        # 1. 构建和测试
        echo "🔨 构建项目..."
        cargo build --release
        cargo test
        
        # 2. 发布到 crates.io
        echo "📤 发布到 crates.io..."
        cargo publish --registry crates-io
        
        # 3. 创建 Git 标签
        if [ -d ".git" ]; then
            TAG="v$CURRENT_VERSION"
            echo "🏷️  创建标签: $TAG"
            git tag -a "$TAG" -m "Release $TAG"
            git push origin "$TAG"
        fi
        
        echo ""
        echo "🎉 发布完成！"
        echo ""
        echo "📋 后续步骤:"
        echo "  1. 访问 GitHub 创建 Release"
        echo "  2. 上传 target/release/systemd-generator"
        echo "  3. 更新版本号准备下次发布"
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

echo ""
echo "📚 更多信息请查看: PUBLISH.md"

