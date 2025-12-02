# 安装指南

## 🔧 安装 Rust 环境

### Linux / macOS

#### 方式 1: 使用官方安装脚本（推荐）
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

安装过程中选择默认选项（按回车）。

#### 安装完成后，加载环境变量
```bash
source $HOME/.cargo/env
```

或重新打开终端。

### 验证安装

```bash
rustc --version
cargo --version
```

应该看到类似输出：
```
rustc 1.75.0 (82e1608df 2023-12-21)
cargo 1.75.0 (1d8b05cdd 2023-11-20)
```

---

## 🚀 运行项目

### 1. 进入项目目录
```bash
cd /home/daiwj/wkspace/learn_rust/systemd-generator
```

### 2. 首次编译（会下载依赖）
```bash
cargo build
```

第一次编译可能需要几分钟，因为需要下载并编译依赖包。

### 3. 运行测试
```bash
./test.sh
```

如果所有测试通过，说明环境配置正确！

### 4. 运行程序
```bash
cargo run -- --help
```

---

## 🛠️ 安装额外工具（可选但推荐）

### Clippy（代码质量检查）
```bash
rustup component add clippy
```

使用：
```bash
cargo clippy
```

### Rustfmt（代码格式化）
```bash
rustup component add rustfmt
```

使用：
```bash
cargo fmt
```

### Rust Analyzer（IDE 支持）
如果使用 VS Code，安装 rust-analyzer 插件：
```bash
code --install-extension rust-lang.rust-analyzer
```

---

## 📦 编译发布版本

开发测试完成后，可以编译优化的发布版本：

```bash
cargo build --release
```

可执行文件在 `target/release/systemd-generator`

### 安装到系统
```bash
sudo cp target/release/systemd-generator /usr/local/bin/
```

然后可以直接使用：
```bash
systemd-generator --name myapp --exec /usr/bin/myapp
```

---

## 🐛 常见问题

### 问题 1: curl 命令失败
**解决方案**：
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install curl

# CentOS/RHEL
sudo yum install curl
```

### 问题 2: 编译时缺少依赖
**解决方案**：
```bash
# Ubuntu/Debian
sudo apt install build-essential pkg-config libssl-dev

# CentOS/RHEL
sudo yum groupinstall "Development Tools"
sudo yum install openssl-devel
```

### 问题 3: 权限问题
**解决方案**：
确保不要用 sudo 运行 cargo：
```bash
# ❌ 错误
sudo cargo build

# ✅ 正确
cargo build
```

### 问题 4: cargo 命令找不到
**解决方案**：
```bash
# 重新加载环境变量
source $HOME/.cargo/env

# 或将以下内容添加到 ~/.bashrc 或 ~/.zshrc
echo 'source $HOME/.cargo/env' >> ~/.bashrc
source ~/.bashrc
```

---

## 📚 更新 Rust

保持 Rust 工具链最新：

```bash
rustup update
```

---

## 🎓 IDE 配置

### VS Code（推荐）
1. 安装 rust-analyzer 插件
2. 安装 CodeLLDB 插件（用于调试）
3. 安装 Better TOML 插件

### IntelliJ IDEA / CLion
1. 安装 Rust 插件
2. 配置 Rust toolchain 路径

### Vim / Neovim
1. 安装 rust.vim
2. 配置 LSP (rust-analyzer)

---

## ✅ 验证清单

安装完成后，检查以下内容：

- [ ] `rustc --version` 显示版本信息
- [ ] `cargo --version` 显示版本信息
- [ ] `cargo clippy --version` 显示版本（可选）
- [ ] `cargo fmt --version` 显示版本（可选）
- [ ] `cd systemd-generator && cargo build` 编译成功
- [ ] `./test.sh` 所有测试通过

---

## 🚀 下一步

安装完成！现在可以：

1. **阅读 QUICKSTART.md** - 快速上手
2. **运行 test.sh** - 验证环境
3. **查看 PROJECT_OVERVIEW.md** - 了解项目结构
4. **开始学习** - 阅读 RUST_CONCEPTS.md

祝你学习愉快！🦀

