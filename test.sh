#!/bin/bash
# 测试脚本 - 快速验证工具是否正常工作

set -e  # 遇到错误立即退出

echo "🦀 Systemd Service Generator - 测试脚本"
echo "========================================"
echo ""

# 检查 Rust 环境
echo "📦 检查 Rust 环境..."
if ! command -v cargo &> /dev/null; then
    echo "❌ 错误: 未找到 cargo 命令"
    echo "💡 请先安装 Rust: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    exit 1
fi

echo "✅ Rust 版本: $(rustc --version)"
echo "✅ Cargo 版本: $(cargo --version)"
echo ""

# 编译项目
echo "🔨 编译项目..."
cargo build --quiet
echo "✅ 编译成功"
echo ""

# 运行帮助命令
echo "📖 显示帮助信息..."
cargo run --quiet -- --help
echo ""

# 测试用例 1: 基本功能
echo "🧪 测试用例 1: 基本功能"
cargo run --quiet -- \
    --name test-basic \
    --exec /bin/bash \
    --description "基本测试服务" \
    --output /tmp/test-basic.service

if [ -f /tmp/test-basic.service ]; then
    echo "✅ 测试通过: 文件已生成"
    echo "📄 生成的文件内容:"
    echo "---"
    cat /tmp/test-basic.service
    echo "---"
    rm /tmp/test-basic.service
else
    echo "❌ 测试失败: 文件未生成"
    exit 1
fi
echo ""

# 测试用例 2: 完整参数
echo "🧪 测试用例 2: 完整参数"
cargo run --quiet -- \
    --name test-full \
    --exec "/usr/bin/python3 /opt/app/main.py" \
    --description "完整参数测试" \
    --working-dir /opt/app \
    --user testuser \
    --output /tmp/test-full.service

if [ -f /tmp/test-full.service ]; then
    echo "✅ 测试通过: 完整参数文件已生成"
    
    # 验证内容
    if grep -q "WorkingDirectory=/opt/app" /tmp/test-full.service && \
       grep -q "User=testuser" /tmp/test-full.service; then
        echo "✅ 内容验证通过"
    else
        echo "❌ 内容验证失败"
        exit 1
    fi
    
    rm /tmp/test-full.service
else
    echo "❌ 测试失败"
    exit 1
fi
echo ""

# 测试用例 3: 不存在的可执行文件（应该失败）
echo "🧪 测试用例 3: 错误处理（不存在的可执行文件）"
if cargo run --quiet -- \
    --name test-error \
    --exec /non/existent/file 2>&1 | grep -q "可执行文件不存在"; then
    echo "✅ 测试通过: 正确处理错误"
else
    echo "❌ 测试失败: 错误处理不正确"
    exit 1
fi
echo ""

# 代码质量检查
echo "🔍 运行代码质量检查..."
if command -v cargo-clippy &> /dev/null; then
    cargo clippy --quiet -- -D warnings 2>&1 | head -10 || true
    echo "✅ Clippy 检查完成"
else
    echo "⚠️  未安装 clippy，跳过检查"
    echo "💡 安装: rustup component add clippy"
fi
echo ""

# 格式检查
echo "📐 检查代码格式..."
cargo fmt -- --check 2>&1 || {
    echo "⚠️  代码格式需要调整"
    echo "💡 运行: cargo fmt"
}
echo ""

echo "🎉 所有测试通过！"
echo ""
echo "📚 下一步:"
echo "  1. 阅读 QUICKSTART.md 快速开始"
echo "  2. 阅读 RUST_CONCEPTS.md 学习 Rust 概念"
echo "  3. 查看 examples.md 了解更多示例"
echo "  4. 修改 src/main.rs 添加新功能"
echo ""
echo "🚀 开始你的 Rust 之旅吧！"

