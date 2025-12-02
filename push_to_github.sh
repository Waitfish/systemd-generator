#!/bin/bash
# 推送代码到 GitHub

echo "🚀 准备推送代码到 GitHub..."
echo ""
echo "请确保你已经在 GitHub 上创建了仓库："
echo "https://github.com/waitfish/systemd-generator"
echo ""
read -p "已经创建了仓库？按回车继续..."

echo ""
echo "📤 推送代码中..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 成功！代码已推送到 GitHub"
    echo ""
    echo "📋 访问你的仓库："
    echo "https://github.com/waitfish/systemd-generator"
    echo ""
    echo "🏷️  现在可以创建第一个 release 标签："
    echo "git tag v0.1.0"
    echo "git push origin v0.1.0"
else
    echo ""
    echo "❌ 推送失败，请检查："
    echo "1. GitHub 仓库是否已创建"
    echo "2. SSH 密钥是否配置正确"
    echo "3. 运行: ssh -T git@github.com 测试连接"
fi

