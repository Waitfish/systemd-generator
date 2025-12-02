# 📦 发布指南

本文档介绍如何将 systemd-generator 发布到各个软件市场。

---

## 🎯 发布前准备清单

- [ ] 完善项目文档（README.md）
- [ ] 添加 LICENSE 文件
- [ ] 测试所有功能
- [ ] 更新版本号
- [ ] 创建 Git 仓库（GitHub/GitLab）
- [ ] 编写 CHANGELOG.md

---

## 方式 1: 发布到 Cargo (crates.io) ⭐ 推荐

### 适合人群
- ✅ 所有 Rust 开发者
- ✅ 使用 `cargo install` 的用户
- ✅ 最简单、最快速的方式

### 用户安装方式
```bash
cargo install systemd-generator
```

### 发布步骤

#### 1. 注册 crates.io 账号
访问 https://crates.io/ 并用 GitHub 账号登录

#### 2. 获取 API Token
```bash
# 访问 https://crates.io/me
# 点击 "New Token"，创建一个 API token
# 然后在终端配置：
cargo login YOUR_API_TOKEN_HERE
```

#### 3. 完善 Cargo.toml
确保包含以下字段（已添加）：
```toml
[package]
name = "systemd-generator"
version = "0.1.0"
authors = ["Your Name <email@example.com>"]
description = "快速生成 systemd service 文件的 CLI 工具"
license = "MIT OR Apache-2.0"
repository = "https://github.com/yourusername/systemd-generator"
```

⚠️ **注意**：需要修改：
- `authors`: 你的名字和邮箱
- `repository`: 你的 GitHub 仓库地址

#### 4. 添加 LICENSE 文件
```bash
# 选择一个许可证，推荐 MIT 或 Apache-2.0
# 我已经为你准备好了 LICENSE 文件
```

#### 5. 测试发布（dry-run）
```bash
cd /home/daiwj/wkspace/learn_rust/systemd-generator
cargo publish --dry-run
```

检查输出，确保没有错误。

#### 6. 正式发布
```bash
cargo publish
```

🎉 发布成功！用户可以通过以下命令安装：
```bash
cargo install systemd-generator
```

#### 7. 更新版本
修改 `Cargo.toml` 中的版本号，然后重新发布：
```toml
version = "0.1.1"  # 修复 bug
version = "0.2.0"  # 新功能
version = "1.0.0"  # 稳定版本
```

### 优缺点
✅ 优点：
- 发布极其简单（几分钟搞定）
- Rust 社区标准方式
- 自动处理依赖
- 版本管理方便

❌ 缺点：
- 需要用户安装 Rust 工具链
- 首次安装需要编译（1-2 分钟）

---

## 方式 2: GitHub Releases + 二进制发布

### 适合人群
- ✅ 所有 Linux 用户
- ✅ 不想安装 Rust 的用户
- ✅ 需要快速下载即用

### 用户安装方式
```bash
wget https://github.com/yourusername/systemd-generator/releases/download/v0.1.0/systemd-generator
chmod +x systemd-generator
sudo mv systemd-generator /usr/local/bin/
```

### 发布步骤

#### 1. 创建 GitHub 仓库
```bash
cd /home/daiwj/wkspace/learn_rust/systemd-generator

# 初始化 git（如果还没有）
git init
git add .
git commit -m "Initial commit"

# 添加远程仓库
git remote add origin https://github.com/yourusername/systemd-generator.git
git push -u origin main
```

#### 2. 编译多个平台的二进制文件
```bash
# Linux x86_64 (最常用)
cargo build --release --target x86_64-unknown-linux-gnu

# Linux ARM64 (树莓派等)
# cargo build --release --target aarch64-unknown-linux-gnu

# 可执行文件在 target/release/systemd-generator
```

#### 3. 创建 GitHub Release
1. 访问你的 GitHub 仓库
2. 点击 "Releases" → "Create a new release"
3. 创建标签（如 `v0.1.0`）
4. 上传编译好的二进制文件
5. 编写 Release Notes
6. 发布！

#### 4. 自动化发布（使用 GitHub Actions）

创建 `.github/workflows/release.yml`:

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install Rust
        uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
      
      - name: Build
        run: cargo build --release
      
      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          files: target/release/systemd-generator
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

然后每次推送标签即可自动发布：
```bash
git tag v0.1.0
git push origin v0.1.0
```

### 优缺点
✅ 优点：
- 用户无需安装 Rust
- 下载即用，非常快
- 支持多个平台

❌ 缺点：
- 需要手动下载和安装
- 更新不够方便

---

## 方式 3: 发布到 Snap Store

### 适合人群
- ✅ Ubuntu 用户
- ✅ 其他支持 Snap 的 Linux 发行版

### 用户安装方式
```bash
sudo snap install systemd-generator
```

### 发布步骤

#### 1. 创建 snapcraft.yaml
```bash
cd /home/daiwj/wkspace/learn_rust/systemd-generator
```

创建 `snap/snapcraft.yaml`:

```yaml
name: systemd-generator
base: core22
version: '0.1.0'
summary: 快速生成 systemd service 文件
description: |
  一个简单的命令行工具，可以快速生成 Linux systemd service 配置文件。
  只需提供服务名称和可执行文件路径即可。

grade: stable
confinement: strict

apps:
  systemd-generator:
    command: bin/systemd-generator
    plugs:
      - home
      - removable-media

parts:
  systemd-generator:
    plugin: rust
    source: .
    build-packages:
      - pkg-config
```

#### 2. 构建 Snap 包
```bash
# 安装 snapcraft
sudo snap install snapcraft --classic

# 构建
snapcraft

# 测试
sudo snap install systemd-generator_0.1.0_amd64.snap --dangerous
```

#### 3. 发布到 Snap Store
```bash
# 登录
snapcraft login

# 上传
snapcraft upload systemd-generator_0.1.0_amd64.snap

# 发布到 stable 频道
snapcraft release systemd-generator 1 stable
```

#### 4. 在 Snapcraft.io 完成信息
访问 https://snapcraft.io/systemd-generator 填写详细信息

### 优缺点
✅ 优点：
- Ubuntu 用户安装方便
- 自动更新
- 沙箱隔离，安全

❌ 缺点：
- 只支持部分 Linux 发行版
- Snap 体积较大
- 需要注册 Snapcraft 账号

---

## 方式 4: 发布到 Debian/Ubuntu APT 仓库

### 适合人群
- ✅ Debian/Ubuntu 用户
- ✅ 希望通过 apt 安装的用户

### 用户安装方式
```bash
sudo add-apt-repository ppa:yourusername/systemd-generator
sudo apt update
sudo apt install systemd-generator
```

### 发布步骤

这是最复杂的方式，需要：

#### 1. 创建 Debian 打包文件
需要创建 `debian/` 目录，包含：
- `debian/control` - 包信息
- `debian/rules` - 构建规则
- `debian/changelog` - 变更日志
- `debian/copyright` - 版权信息

#### 2. 构建 .deb 包
```bash
# 安装打包工具
sudo apt install build-essential debhelper cargo

# 构建
dpkg-buildpackage -us -uc
```

#### 3. 发布到 PPA (Ubuntu)
```bash
# 创建 PPA: https://launchpad.net/
# 上传源码包
dput ppa:yourusername/systemd-generator systemd-generator_0.1.0_source.changes
```

#### 4. 或使用第三方仓库服务
- **Gemfury**: https://gemfury.com/
- **Packagecloud**: https://packagecloud.io/

### 优缺点
✅ 优点：
- 用户体验最好（apt install）
- 自动更新
- 系统集成好

❌ 缺点：
- 最复杂的发布方式
- 需要学习 Debian 打包
- 维护成本高

---

## 方式 5: 发布到 AUR (Arch User Repository)

### 适合人群
- ✅ Arch Linux 用户
- ✅ Manjaro 等衍生版用户

### 用户安装方式
```bash
yay -S systemd-generator
# 或
paru -S systemd-generator
```

### 发布步骤

#### 1. 创建 PKGBUILD 文件
```bash
# 文件名: PKGBUILD
pkgname=systemd-generator
pkgver=0.1.0
pkgrel=1
pkgdesc="快速生成 systemd service 文件的 CLI 工具"
arch=('x86_64')
url="https://github.com/yourusername/systemd-generator"
license=('MIT')
depends=()
makedepends=('cargo')
source=("$pkgname-$pkgver.tar.gz::https://github.com/yourusername/systemd-generator/archive/v$pkgver.tar.gz")
sha256sums=('SKIP')

build() {
    cd "$pkgname-$pkgver"
    cargo build --release --locked
}

package() {
    cd "$pkgname-$pkgver"
    install -Dm755 target/release/systemd-generator "$pkgdir/usr/bin/systemd-generator"
}
```

#### 2. 提交到 AUR
```bash
# 克隆 AUR 仓库
git clone ssh://aur@aur.archlinux.org/systemd-generator.git
cd systemd-generator

# 添加 PKGBUILD
cp /path/to/PKGBUILD .

# 生成 .SRCINFO
makepkg --printsrcinfo > .SRCINFO

# 提交
git add PKGBUILD .SRCINFO
git commit -m "Initial commit"
git push
```

### 优缺点
✅ 优点：
- Arch 用户安装方便
- 社区维护友好

❌ 缺点：
- 只支持 Arch Linux
- 需要学习 PKGBUILD 语法

---

## 方式 6: 发布到 Homebrew

### 适合人群
- ✅ macOS 用户
- ✅ Linux 用户（Homebrew on Linux）

### 用户安装方式
```bash
brew install systemd-generator
```

### 发布步骤

#### 1. 创建 Formula
```ruby
# 文件名: systemd-generator.rb
class SystemdGenerator < Formula
  desc "快速生成 systemd service 文件的 CLI 工具"
  homepage "https://github.com/yourusername/systemd-generator"
  url "https://github.com/yourusername/systemd-generator/archive/v0.1.0.tar.gz"
  sha256 "YOUR_SHA256_HERE"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/systemd-generator", "--version"
  end
end
```

#### 2. 提交到 Homebrew
```bash
# Fork homebrew-core
# 提交 PR
```

或创建自己的 Tap：
```bash
brew tap yourusername/tap
brew install systemd-generator
```

---

## 📋 推荐发布策略

### 第一阶段：快速发布（第 1 天）
1. ✅ **发布到 crates.io** - 5 分钟
2. ✅ **创建 GitHub Release** - 10 分钟

### 第二阶段：扩大覆盖（第 1 周）
3. ✅ **发布到 Snap Store** - 1 小时
4. ✅ **发布到 AUR** - 30 分钟

### 第三阶段：深度集成（长期）
5. ⏳ **发布到 APT 仓库** - 需要学习和维护
6. ⏳ **发布到 Homebrew** - 需要审核

---

## 🎯 我的建议

作为你的第一个 Rust 项目，建议：

1. **立即做**：发布到 **crates.io** + **GitHub Releases**
   - 最简单，覆盖最多 Rust 用户
   - 10 分钟搞定

2. **有时间做**：**Snap Store** 或 **AUR**
   - 扩大用户群
   - 学习打包知识

3. **暂时不做**：APT 仓库
   - 太复杂，投入产出比低
   - 等项目成熟后再考虑

---

## 📝 TODO 清单

在发布前，请完成：

- [ ] 修改 Cargo.toml 中的作者信息和仓库地址
- [ ] 创建 GitHub 仓库
- [ ] 添加 LICENSE 文件（MIT 或 Apache-2.0）
- [ ] 完善 README.md（添加安装说明）
- [ ] 编写 CHANGELOG.md
- [ ] 运行所有测试
- [ ] 提交所有代码到 GitHub

---

## 🚀 快速开始：5 分钟发布到 crates.io

```bash
# 1. 修改 Cargo.toml 中的作者信息
# 2. 添加 LICENSE 文件
# 3. 登录 crates.io
cargo login YOUR_TOKEN

# 4. 测试发布
cargo publish --dry-run

# 5. 正式发布
cargo publish

# 🎉 完成！
```

用户现在可以安装：
```bash
cargo install systemd-generator
```

---

需要帮助？查看：
- [crates.io 发布指南](https://doc.rust-lang.org/cargo/reference/publishing.html)
- [Rust 打包最佳实践](https://doc.rust-lang.org/cargo/guide/cargo-toml-vs-cargo-lock.html)

