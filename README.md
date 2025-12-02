# Systemd Service 文件生成器

一个用 Rust 编写的命令行工具，快速生成 Linux systemd service 文件。

[![Crates.io](https://img.shields.io/crates/v/systemd-generator.svg)](https://crates.io/crates/systemd-generator)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE-MIT)

## 📦 安装

### 方式 1: 使用 Cargo（推荐）

如果你已经安装了 Rust：

```bash
cargo install systemd-generator
```

### 方式 2: 下载预编译二进制文件

从 [Releases](https://github.com/yourusername/systemd-generator/releases) 页面下载最新版本：

```bash
# 下载
wget https://github.com/yourusername/systemd-generator/releases/latest/download/systemd-generator

# 添加执行权限
chmod +x systemd-generator

# 移动到系统路径
sudo mv systemd-generator /usr/local/bin/
```

### 方式 3: 从源码编译

```bash
git clone https://github.com/yourusername/systemd-generator.git
cd systemd-generator
cargo build --release
sudo cp target/release/systemd-generator /usr/local/bin/
```

## 🎯 项目目标

这是一个 Rust 入门学习项目，通过实现一个实用工具来学习 Rust 的核心概念：
- ✅ 所有权 (Ownership) 和借用 (Borrowing)
- ✅ 结构体 (Struct) 和方法 (Method)
- ✅ 错误处理 (Result 和 Option)
- ✅ 模式匹配 (Pattern Matching)
- ✅ 命令行参数解析

## 📦 安装 Rust 环境

如果还没有安装 Rust，运行以下命令：

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

验证安装：
```bash
rustc --version
cargo --version
```

## 🚀 使用方法

### 编译项目

```bash
cd systemd-generator
cargo build --release
```

### 运行示例

#### 基本用法
```bash
cargo run -- --name myapp --exec /usr/bin/python3
```

#### 完整参数
```bash
cargo run -- \
  --name myapp \
  --exec /usr/bin/python3 \
  --description "我的Python应用" \
  --working-dir /home/user/myapp \
  --user myuser \
  --output /tmp/myapp.service
```

#### 查看帮助
```bash
cargo run -- --help
```

### 生成后的安装步骤

工具会生成一个 `.service` 文件，然后：

```bash
# 1. 移动到 systemd 目录
sudo mv myapp.service /etc/systemd/system/

# 2. 重载 systemd
sudo systemctl daemon-reload

# 3. 启用服务（开机自启）
sudo systemctl enable myapp

# 4. 启动服务
sudo systemctl start myapp

# 5. 查看状态
sudo systemctl status myapp
```

## 📚 Rust 核心概念解析

### 1. 所有权系统 (Ownership)

Rust 最独特的特性，在编译时保证内存安全，无需 GC：

```rust
// 值的所有权会转移
let s1 = String::from("hello");
let s2 = s1;  // s1 的所有权转移到 s2
// println!("{}", s1);  // ❌ 编译错误！s1 已失效

// 使用借用（引用）避免所有权转移
let s1 = String::from("hello");
let s2 = &s1;  // s2 借用 s1
println!("{}, {}", s1, s2);  // ✅ 都可以使用
```

**对比其他语言：**
- **Python**: 一切都是引用，有 GC
- **Go**: 有值类型和指针，有 GC
- **Rust**: 通过所有权系统在编译时管理内存，零成本抽象

### 2. 借用和引用 (Borrowing)

```rust
// 不可变借用（可以有多个）
fn calculate_length(s: &String) -> usize {
    s.len()  // 只读访问
}

// 可变借用（同时只能有一个）
fn change(s: &mut String) {
    s.push_str(" world");
}
```

### 3. Option 和 Result

替代其他语言的 null/nil，强制处理错误：

```rust
// Option: 可能有值或无值
let maybe_number: Option<i32> = Some(5);
match maybe_number {
    Some(n) => println!("数字是: {}", n),
    None => println!("没有值"),
}

// Result: 成功或失败
fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        Err("除数不能为零".to_string())
    } else {
        Ok(a / b)
    }
}
```

### 4. 模式匹配 (Pattern Matching)

比其他语言的 switch 更强大：

```rust
match some_value {
    Some(x) if x > 10 => println!("大于10: {}", x),
    Some(x) => println!("其他值: {}", x),
    None => println!("无值"),
}
```

## 🎓 学习路径

这个项目涵盖了 Rust 的核心概念，建议学习顺序：

1. **阅读代码注释** - 每个概念都有详细说明
2. **运行程序** - 实际体验工具的使用
3. **修改代码** - 尝试添加新功能（见下方扩展建议）
4. **处理编译错误** - Rust 编译器错误信息非常友好，是最好的老师

## 🔧 扩展功能建议

完成基础版本后，可以尝试添加：

1. **交互式模式** - 不提供参数时进入问答模式
2. **配置文件** - 从 JSON/TOML 读取配置
3. **模板支持** - 支持自定义 service 模板
4. **验证功能** - 验证生成的 service 文件语法
5. **更多 systemd 选项** - 支持更多 systemd 配置项

## 📖 参考资源

- [Rust 官方书籍](https://doc.rust-lang.org/book/)（强烈推荐）
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/)
- [systemd.service 手册](https://www.freedesktop.org/software/systemd/man/systemd.service.html)

## 💡 小贴士

- Rust 编译器的错误提示很详细，仔细阅读能学到很多
- 使用 `cargo clippy` 获取代码改进建议
- 使用 `cargo fmt` 自动格式化代码
- 多写代码，让 Rust 编译器教你正确的用法

祝学习愉快！🦀

