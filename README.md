# systemd-generator

一个简单高效的命令行工具，快速生成 Linux systemd service 配置文件。

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE-MIT)
[![GitHub](https://img.shields.io/badge/github-Waitfish/systemd--generator-blue)](https://github.com/Waitfish/systemd-generator)

## ✨ 特性

- 🚀 快速生成 systemd service 文件
- 💻 简洁的命令行界面
- ⚙️ 支持常用配置选项
- 📝 自动生成安装说明
- 🔒 验证可执行文件路径
- 📦 单文件可执行程序，无需依赖

## 📦 安装

### 方式 1: 下载预编译二进制文件（推荐）

从 [Releases](https://github.com/Waitfish/systemd-generator/releases) 页面下载最新版本：

```bash
# 下载最新版本
wget https://github.com/Waitfish/systemd-generator/releases/latest/download/systemd-generator

# 添加执行权限
chmod +x systemd-generator

# 移动到系统路径
sudo mv systemd-generator /usr/local/bin/
```

### 方式 2: 使用 Cargo 安装

如果你已经安装了 Rust 工具链：

```bash
cargo install systemd-generator
```

### 方式 3: 从源码编译

```bash
git clone https://github.com/Waitfish/systemd-generator.git
cd systemd-generator
cargo build --release
sudo cp target/release/systemd-generator /usr/local/bin/
```

## 🚀 使用方法

### 基本用法

```bash
systemd-generator --name myapp --exec /usr/bin/python3
```

### 完整示例

```bash
systemd-generator \
  --name myapp \
  --exec "/usr/bin/python3 /opt/myapp/main.py" \
  --description "我的应用服务" \
  --working-dir /opt/myapp \
  --user www-data \
  --output /tmp/myapp.service
```

### 查看所有选项

```bash
systemd-generator --help
```

## 📋 命令行参数

| 参数 | 简写 | 必需 | 说明 |
|------|------|------|------|
| `--name` | `-n` | ✅ | 服务名称 |
| `--exec` | `-e` | ✅ | 可执行文件的完整路径 |
| `--description` | `-d` | ❌ | 服务描述（默认："My Service"） |
| `--working-dir` | `-w` | ❌ | 工作目录 |
| `--user` | `-u` | ❌ | 运行用户（默认：当前用户） |
| `--output` | `-o` | ❌ | 输出文件路径（默认：当前目录） |

## 📝 使用示例

### 示例 1: Python Web 应用

```bash
systemd-generator \
  --name flask-app \
  --exec "/usr/bin/python3 /home/user/app/app.py" \
  --description "Flask Web Application" \
  --working-dir /home/user/app \
  --user www-data
```

### 示例 2: Node.js 应用

```bash
systemd-generator \
  --name node-app \
  --exec "/usr/bin/node /opt/app/server.js" \
  --description "Node.js Application" \
  --working-dir /opt/app \
  --user nodeuser
```

### 示例 3: Go 服务

```bash
systemd-generator \
  --name go-api \
  --exec /opt/myservice/server \
  --description "Go API Server" \
  --user apiuser
```

## 🔧 安装生成的 Service 文件

生成 service 文件后，按照以下步骤安装：

```bash
# 1. 移动到 systemd 目录
sudo mv myapp.service /etc/systemd/system/

# 2. 重载 systemd 配置
sudo systemctl daemon-reload

# 3. 启用服务（开机自启动）
sudo systemctl enable myapp

# 4. 启动服务
sudo systemctl start myapp

# 5. 查看服务状态
sudo systemctl status myapp

# 6. 查看服务日志
sudo journalctl -u myapp -f
```

## 📄 生成的 Service 文件示例

```ini
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
User=myuser
ExecStart=/usr/bin/myapp
WorkingDirectory=/opt/myapp
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

## 🛠️ 开发

```bash
# 克隆仓库
git clone https://github.com/Waitfish/systemd-generator.git
cd systemd-generator

# 编译
cargo build

# 运行测试
cargo test

# 运行
cargo run -- --name test --exec /bin/bash

# 构建 release 版本
cargo build --release
```

## 📖 技术栈

- **语言**: Rust
- **依赖**: clap (命令行参数解析)
- **最小 Rust 版本**: 1.70+

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE-MIT](LICENSE-MIT) 文件了解详情

## 🔗 相关链接

- [GitHub 仓库](https://github.com/Waitfish/systemd-generator)
- [Issue 追踪](https://github.com/Waitfish/systemd-generator/issues)
- [systemd 文档](https://www.freedesktop.org/software/systemd/man/systemd.service.html)

---

Made with ❤️ using Rust 🦀
