# 🚀 5分钟快速发布指南

## 准备工作（只需一次）

### 1. 修改 Cargo.toml
打开 `Cargo.toml`，修改这几行：

```toml
authors = ["你的名字 <your.email@example.com>"]  # 改成你的信息
repository = "https://github.com/你的用户名/systemd-generator"  # 改成你的仓库地址
homepage = "https://github.com/你的用户名/systemd-generator"
documentation = "https://github.com/你的用户名/systemd-generator#readme"
```

### 2. 创建 GitHub 仓库
```bash
# 在项目目录下
git init
git add .
git commit -m "Initial commit"

# 在 GitHub 上创建仓库，然后：
git remote add origin https://github.com/你的用户名/systemd-generator.git
git push -u origin main
```

### 3. 获取 crates.io Token
1. 访问 https://crates.io/
2. 用 GitHub 账号登录
3. 访问 https://crates.io/settings/tokens
4. 点击 "New Token"，创建一个新的 API token
5. 复制 token

```bash
cargo login 你的_TOKEN_粘贴在这里
```

## 🎯 开始发布！

### 方式 1: 使用自动化脚本

```bash
./publish.sh
```

选择选项 2 或 4，就完成了！

### 方式 2: 手动发布

```bash
# 1. 测试是否能发布
cargo publish --dry-run

# 2. 如果没问题，正式发布
cargo publish

# 3. 创建 Git 标签（用于 GitHub Release）
git tag v0.1.0
git push origin v0.1.0
```

## ✅ 完成！

现在任何人都可以安装你的工具：

```bash
cargo install systemd-generator
```

## 📝 更新版本

修改代码后，更新版本号：

```bash
# 1. 修改 Cargo.toml 中的版本号
version = "0.1.1"  # 或 "0.2.0", "1.0.0"

# 2. 更新 CHANGELOG.md

# 3. 提交代码
git add .
git commit -m "Release v0.1.1"
git push

# 4. 发布
cargo publish

# 5. 创建标签
git tag v0.1.1
git push origin v0.1.1
```

## 🤔 版本号规则

- `0.1.0` → `0.1.1`: 修复 bug
- `0.1.0` → `0.2.0`: 添加新功能
- `0.9.0` → `1.0.0`: 重大变更或稳定版本

## 📊 查看下载量

访问：https://crates.io/crates/systemd-generator

可以看到：
- 下载次数
- 版本历史
- 依赖关系
- 使用文档

## 🎉 恭喜！

你已经成功发布了第一个 Rust 包！🦀

---

需要更详细的信息？查看 [PUBLISH.md](PUBLISH.md)

