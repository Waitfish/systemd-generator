# 🚀 快速开始指南

## 第一步：确认 Rust 环境

```bash
# 检查是否安装了 Rust
rustc --version
cargo --version
```

如果没有安装，运行：
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

---

## 第二步：进入项目目录

```bash
cd /home/daiwj/wkspace/learn_rust/systemd-generator
```

---

## 第三步：首次编译

```bash
# 下载依赖并编译（第一次会比较慢）
cargo build

# 或者直接运行（会自动编译）
cargo run -- --help
```

你会看到帮助信息：
```
生成 systemd service 文件的小工具

Usage: systemd-generator [OPTIONS] --name <NAME> --exec <EXEC>

Options:
  -n, --name <NAME>                  服务名称（例如：myapp）
  -e, --exec <EXEC>                  可执行文件的完整路径
  -d, --description <DESCRIPTION>    服务描述（可选） [default: My Service]
  -w, --working-dir <WORKING_DIR>    工作目录（可选）
  -u, --user <USER>                  运行用户（可选，默认 root） [default: root]
  -o, --output <OUTPUT>              输出文件路径（可选，默认当前目录）
  -h, --help                         Print help
  -V, --version                      Print version
```

---

## 第四步：创建第一个 Service 文件

```bash
# 最简单的示例（需要一个真实存在的可执行文件）
cargo run -- \
  --name test-service \
  --exec /bin/bash \
  --description "测试服务"
```

会生成 `test-service.service` 文件在当前目录。

---

## 第五步：查看生成的文件

```bash
cat test-service.service
```

输出类似：
```ini
[Unit]
Description=测试服务
After=network.target

[Service]
Type=simple
User=root
ExecStart=/bin/bash
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

---

## 第六步：理解代码

打开 `src/main.rs`，从上到下阅读：

1. **第 15-45 行**: 命令行参数定义（Struct + Derive 宏）
2. **第 51-68 行**: ServiceConfig 结构体定义（Option 类型）
3. **第 74-88 行**: `new` 关联函数（类似构造函数）
4. **第 104-136 行**: 生成 service 内容（借用 &self）
5. **第 152-184 行**: 保存文件（Result 错误处理）
6. **第 193-220 行**: main 函数（? 操作符）

**重点关注注释中标注的 Rust 概念！**

---

## 第七步：修改代码试试

尝试添加一个新的可选参数，比如 `--restart-sec`：

### 7.1 在 Args 结构体中添加字段

```rust
#[derive(Parser, Debug)]
struct Args {
    // ... 其他字段 ...
    
    /// 重启等待时间（秒）
    #[arg(short = 'r', long, default_value = "5")]
    restart_sec: u32,
}
```

### 7.2 在 ServiceConfig 中添加字段

```rust
struct ServiceConfig {
    // ... 其他字段 ...
    restart_sec: u32,
}
```

### 7.3 更新 new 函数

```rust
fn new(
    name: String,
    description: String,
    exec_start: String,
    working_directory: Option<String>,
    user: String,
    restart_sec: u32,  // 新增参数
) -> Self {
    ServiceConfig {
        name,
        description,
        exec_start,
        working_directory,
        user,
        restart_sec,  // 新增字段
    }
}
```

### 7.4 在生成函数中使用

```rust
fn generate_service_content(&self) -> String {
    // ... 前面的代码 ...
    
    content.push_str(&format!(
        "Restart=always\n\
         RestartSec={}\n\
         \n\
         [Install]\n\
         WantedBy=multi-user.target\n",
        self.restart_sec  // 使用新字段
    ));
    
    content
}
```

### 7.5 在 main 函数中传递参数

```rust
let config = ServiceConfig::new(
    args.name,
    args.description,
    args.exec,
    args.working_dir,
    args.user,
    args.restart_sec,  // 传递新参数
);
```

### 7.6 测试修改

```bash
cargo run -- \
  --name test \
  --exec /bin/bash \
  --restart-sec 10
```

---

## 第八步：使用 Rust 工具

```bash
# 快速检查代码（不生成可执行文件，速度快）
cargo check

# 代码质量检查（会给出改进建议）
cargo clippy

# 自动格式化代码
cargo fmt

# 编译发布版本（会优化，速度更快）
cargo build --release

# 运行发布版本
./target/release/systemd-generator --help
```

---

## 第九步：常见编译错误和解决

### 错误 1: 借用冲突
```rust
let mut s = String::from("hello");
let r1 = &s;
let r2 = &mut s;  // ❌ 错误：不能同时有不可变和可变引用
```

**解决**：确保可变引用独占访问
```rust
let mut s = String::from("hello");
let r1 = &s;
println!("{}", r1);  // r1 的作用域结束
let r2 = &mut s;     // ✅ 现在可以了
```

### 错误 2: 值被移动后使用
```rust
let s1 = String::from("hello");
let s2 = s1;
println!("{}", s1);  // ❌ 错误：s1 已被移动
```

**解决**：使用借用或克隆
```rust
let s1 = String::from("hello");
let s2 = &s1;        // 借用
// 或
let s2 = s1.clone(); // 克隆
println!("{}", s1);  // ✅ 都可以
```

### 错误 3: 未处理 Result/Option
```rust
let result = divide(10, 2);
println!("{}", result);  // ❌ 错误：Result 必须被处理
```

**解决**：使用 match、unwrap 或 ?
```rust
// 方式 1
match divide(10, 2) {
    Ok(v) => println!("{}", v),
    Err(e) => println!("错误: {}", e),
}

// 方式 2（确定不会失败时）
let result = divide(10, 2).unwrap();

// 方式 3（在返回 Result 的函数中）
let result = divide(10, 2)?;
```

---

## 第十步：继续学习

1. **阅读 `RUST_CONCEPTS.md`** - 详细的概念对比
2. **查看 `examples.md`** - 更多使用示例
3. **修改代码** - 添加新功能
4. **阅读 Rust 官方书籍** - https://doc.rust-lang.org/book/

---

## 💡 小贴士

1. **编译器是你的朋友** - 仔细阅读错误信息
2. **多用 `cargo check`** - 比 `cargo build` 快很多
3. **善用 clippy** - 学习最佳实践
4. **从错误中学习** - 每个编译错误都是学习机会
5. **不要怕问** - Rust 社区非常友好

祝你学习愉快！🦀

