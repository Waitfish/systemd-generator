# Rust 核心概念 - 对比 Go 和 Python

## 🔄 从 Go/Python 到 Rust 的概念对照

### 1. 变量和可变性

#### Python
```python
x = 5          # 可变
x = 6          # 可以重新赋值
```

#### Go
```go
var x int = 5  // 可变
x = 6          // 可以重新赋值

const y = 10   // 常量
```

#### Rust
```rust
let x = 5;         // 默认不可变（immutable）
// x = 6;          // ❌ 编译错误！

let mut x = 5;     // mut 关键字表示可变
x = 6;             // ✅ 可以修改

const Y: i32 = 10; // 编译时常量
```

**关键区别**: Rust 默认不可变，需要显式声明 `mut`

---

### 2. 所有权和移动 (Ownership & Move)

#### Python（引用语义 + GC）
```python
s1 = "hello"
s2 = s1        # s1 和 s2 指向同一对象
print(s1, s2)  # 都可用，GC 管理内存
```

#### Go（值拷贝 + GC）
```go
s1 := "hello"
s2 := s1       // 字符串不可变，实际是引用
fmt.Println(s1, s2)  // 都可用

// 对于切片/map，是引用
slice1 := []int{1, 2, 3}
slice2 := slice1       // 共享底层数组
slice2[0] = 999
fmt.Println(slice1[0]) // 999，两者共享数据
```

#### Rust（所有权系统，无 GC）
```rust
// 堆分配的数据会移动所有权
let s1 = String::from("hello");
let s2 = s1;        // 所有权移动到 s2
// println!("{}", s1);  // ❌ 编译错误！s1 已失效

// 栈上的数据会拷贝
let x = 5;
let y = x;          // 拷贝（实现了 Copy trait）
println!("{}, {}", x, y);  // ✅ 都可用

// 使用借用避免移动
let s1 = String::from("hello");
let s2 = &s1;       // 借用，不转移所有权
println!("{}, {}", s1, s2);  // ✅ 都可用
```

**关键区别**: 
- Rust 无 GC，通过所有权在编译时管理内存
- 默认移动语义，避免意外共享
- 借用系统让你明确控制数据访问

---

### 3. 函数参数传递

#### Python（一切都是引用）
```python
def process(data):
    data.append(1)  # 修改原数据

my_list = []
process(my_list)    # my_list 被修改
```

#### Go（值传递，但切片/map/指针会影响原数据）
```go
// 值传递
func process(n int) {
    n = n + 1  // 不影响原变量
}

// 指针传递
func processPtr(n *int) {
    *n = *n + 1  // 影响原变量
}

// 切片（引用语义）
func processSlice(s []int) {
    s[0] = 999  // 影响原切片
}
```

#### Rust（明确的所有权和借用）
```rust
// 获取所有权（值被移动）
fn process_owned(s: String) {
    println!("{}", s);
}  // s 在这里被释放

// 不可变借用（只读）
fn process_ref(s: &String) {
    println!("{}", s);
}  // 借用结束，原变量仍可用

// 可变借用（可修改）
fn process_mut(s: &mut String) {
    s.push_str(" world");
}

// 使用示例
let mut s = String::from("hello");
process_ref(&s);           // 借用，s 仍可用
process_mut(&mut s);       // 可变借用
process_owned(s);          // 移动所有权
// println!("{}", s);      // ❌ s 已失效
```

**关键区别**: Rust 在函数签名中明确表达所有权和借用意图

---

### 4. 错误处理

#### Python（异常）
```python
def divide(a, b):
    if b == 0:
        raise ValueError("除数不能为零")
    return a / b

try:
    result = divide(10, 0)
except ValueError as e:
    print(f"错误: {e}")
```

#### Go（返回错误值）
```go
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("除数不能为零")
    }
    return a / b, nil
}

result, err := divide(10, 0)
if err != nil {
    fmt.Println("错误:", err)
    return
}
fmt.Println("结果:", result)
```

#### Rust（Result 类型）
```rust
fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        Err("除数不能为零".to_string())
    } else {
        Ok(a / b)
    }
}

// 方式 1: match 匹配
match divide(10, 0) {
    Ok(result) => println!("结果: {}", result),
    Err(e) => println!("错误: {}", e),
}

// 方式 2: ? 操作符（类似 Go 的 if err != nil { return err }）
fn main() -> Result<(), String> {
    let result = divide(10, 2)?;  // 出错时自动返回 Err
    println!("结果: {}", result);
    Ok(())
}
```

**关键区别**: 
- Python: 运行时异常，可能忘记处理
- Go: 返回错误值，可能忘记检查
- Rust: 编译时强制处理错误

---

### 5. 空值处理

#### Python（None）
```python
def find_user(id):
    if id == 1:
        return {"name": "Alice"}
    return None

user = find_user(2)
if user is not None:
    print(user["name"])
else:
    print("用户不存在")
```

#### Go（nil）
```go
type User struct {
    Name string
}

func findUser(id int) *User {
    if id == 1 {
        return &User{Name: "Alice"}
    }
    return nil
}

user := findUser(2)
if user != nil {
    fmt.Println(user.Name)
} else {
    fmt.Println("用户不存在")
}
```

#### Rust（Option 类型）
```rust
struct User {
    name: String,
}

fn find_user(id: i32) -> Option<User> {
    if id == 1 {
        Some(User { name: "Alice".to_string() })
    } else {
        None
    }
}

// 方式 1: match
match find_user(2) {
    Some(user) => println!("{}", user.name),
    None => println!("用户不存在"),
}

// 方式 2: if let
if let Some(user) = find_user(1) {
    println!("{}", user.name);
}

// 方式 3: unwrap_or
let user = find_user(2).unwrap_or(User { 
    name: "Guest".to_string() 
});
```

**关键区别**: Rust 的 Option 在编译时强制处理空值情况

---

### 6. 字符串类型

#### Python（str）
```python
s = "hello"       # 不可变
s = s + " world"  # 创建新字符串
```

#### Go（string 和 []byte）
```go
s := "hello"           // 不可变
s = s + " world"       // 创建新字符串

// 可变操作用 strings.Builder
var builder strings.Builder
builder.WriteString("hello")
builder.WriteString(" world")
s = builder.String()
```

#### Rust（String 和 &str）
```rust
// &str: 字符串切片（不可变借用，通常指向字面量或其他字符串）
let s1: &str = "hello";       // 字符串字面量

// String: 可变的、堆分配的字符串
let mut s2 = String::from("hello");
s2.push_str(" world");        // 可以修改

// 转换
let s3: String = s1.to_string();  // &str -> String
let s4: &str = &s2;               // String -> &str

// 函数参数优先用 &str（更灵活）
fn print_string(s: &str) {
    println!("{}", s);
}

print_string("hello");        // &str
print_string(&s2);            // &String 自动转为 &str
```

**关键区别**: Rust 区分拥有的字符串和借用的字符串切片

---

### 7. 集合类型

#### Python
```python
# 列表
my_list = [1, 2, 3]
my_list.append(4)

# 字典
my_dict = {"key": "value"}
my_dict["key2"] = "value2"
```

#### Go
```go
// 切片
mySlice := []int{1, 2, 3}
mySlice = append(mySlice, 4)

// map
myMap := make(map[string]string)
myMap["key"] = "value"
```

#### Rust
```rust
// Vec (动态数组)
let mut my_vec = vec![1, 2, 3];
my_vec.push(4);

// HashMap
use std::collections::HashMap;
let mut my_map = HashMap::new();
my_map.insert("key", "value");

// 访问可能失败，返回 Option
match my_map.get("key") {
    Some(value) => println!("{}", value),
    None => println!("键不存在"),
}
```

---

### 8. 结构体和方法

#### Python（类）
```python
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def greet(self):
        print(f"Hello, I'm {self.name}")

p = Person("Alice", 30)
p.greet()
```

#### Go（结构体 + 方法）
```go
type Person struct {
    Name string
    Age  int
}

func (p Person) Greet() {
    fmt.Printf("Hello, I'm %s\n", p.Name)
}

// 值接收者 vs 指针接收者
func (p *Person) HaveBirthday() {
    p.Age++  // 修改原值
}

p := Person{Name: "Alice", Age: 30}
p.Greet()
p.HaveBirthday()
```

#### Rust（结构体 + impl 块）
```rust
struct Person {
    name: String,
    age: u32,
}

impl Person {
    // 关联函数（类似构造函数）
    fn new(name: String, age: u32) -> Self {
        Person { name, age }
    }
    
    // 不可变借用
    fn greet(&self) {
        println!("Hello, I'm {}", self.name);
    }
    
    // 可变借用
    fn have_birthday(&mut self) {
        self.age += 1;
    }
    
    // 获取所有权
    fn consume(self) {
        println!("{} is consumed", self.name);
    }  // self 在这里被释放
}

let mut p = Person::new("Alice".to_string(), 30);
p.greet();           // 借用
p.have_birthday();   // 可变借用
p.consume();         // 移动所有权
// p.greet();        // ❌ p 已失效
```

---

## 🎯 Rust 特有概念总结

### 借用规则（Borrowing Rules）

在任意时刻，你要么只能有：
1. **一个可变引用** (`&mut T`)
2. **任意数量的不可变引用** (`&T`)

```rust
let mut s = String::from("hello");

let r1 = &s;       // ✅ 不可变引用
let r2 = &s;       // ✅ 多个不可变引用
// let r3 = &mut s; // ❌ 不能同时有可变和不可变引用

println!("{}, {}", r1, r2);  // r1, r2 的作用域结束

let r3 = &mut s;   // ✅ 现在可以有可变引用了
r3.push_str(" world");
```

**为什么这样设计？**
- 防止数据竞争（编译时保证）
- 防止迭代器失效
- 无需 GC，零成本抽象

---

### 生命周期（Lifetime）

编译器确保引用总是有效的：

```rust
// 编译器自动推断生命周期
fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() { x } else { y }
}

// 需要显式标注生命周期
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    // 返回的引用生命周期不会超过 x 和 y
    if x.len() > y.len() { x } else { y }
}

// 使用
let s1 = String::from("long string");
let result;
{
    let s2 = String::from("short");
    result = longest(&s1, &s2);
    // println!("{}", result);  // ✅ s2 还在作用域内
}
// println!("{}", result);  // ❌ s2 已失效，result 不能使用
```

**大多数情况编译器会自动推断，不需要手写生命周期！**

---

### Trait（类似接口）

```rust
// 定义 trait
trait Greet {
    fn greet(&self);
}

// 实现 trait
struct Person {
    name: String,
}

impl Greet for Person {
    fn greet(&self) {
        println!("Hello, I'm {}", self.name);
    }
}

// trait 作为参数（静态分发）
fn say_hello(item: &impl Greet) {
    item.greet();
}

// 或者使用 trait bound
fn say_hello<T: Greet>(item: &T) {
    item.greet();
}
```

---

## 📚 学习建议

### 1. 不要害怕编译错误
Rust 编译器的错误信息非常友好，会告诉你：
- 哪里出错了
- 为什么出错
- 如何修复

### 2. 从小处着手
- 先理解所有权和借用
- 然后学习 Option 和 Result
- 最后再学生命周期和高级特性

### 3. 多写代码
- 让编译器教你正确的用法
- 尝试修改本项目的代码
- 遇到编译错误就是学习的机会

### 4. 利用工具
```bash
cargo build      # 编译
cargo run        # 运行
cargo check      # 快速检查（不生成可执行文件）
cargo clippy     # 代码质量检查
cargo fmt        # 格式化代码
cargo test       # 运行测试
```

---

## 🚀 下一步

1. **运行这个项目** - 看看实际效果
2. **修改代码** - 尝试添加新功能
3. **阅读错误信息** - 理解编译器的提示
4. **阅读官方书籍** - [The Rust Programming Language](https://doc.rust-lang.org/book/)

记住：Rust 的学习曲线比较陡峭，但一旦掌握，你会爱上它的安全性和性能！🦀

