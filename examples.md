# 使用示例

## 示例 1: 为 Python Web 应用创建 Service

假设你有一个 Flask 应用：

```bash
cargo run -- \
  --name flask-app \
  --exec "/usr/bin/python3 /home/user/myapp/app.py" \
  --description "Flask Web Application" \
  --working-dir /home/user/myapp \
  --user www-data
```

生成的 `flask-app.service`:
```ini
[Unit]
Description=Flask Web Application
After=network.target

[Service]
Type=simple
User=www-data
ExecStart=/usr/bin/python3 /home/user/myapp/app.py
WorkingDirectory=/home/user/myapp
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

---

## 示例 2: 为 Go 服务创建 Service

```bash
cargo run -- \
  --name go-api \
  --exec /opt/myapp/server \
  --description "Go API Server" \
  --working-dir /opt/myapp \
  --user apiuser
```

---

## 示例 3: 为 Node.js 应用创建 Service

```bash
cargo run -- \
  --name node-app \
  --exec "/usr/bin/node /home/user/app/server.js" \
  --description "Node.js Application" \
  --working-dir /home/user/app \
  --user nodeuser
```

---

## 示例 4: 简单的后台脚本

```bash
cargo run -- \
  --name backup-script \
  --exec /usr/local/bin/backup.sh \
  --description "Daily Backup Script"
```

---

## 完整工作流示例

```bash
# 1. 生成 service 文件
cd systemd-generator
cargo run -- \
  --name myapp \
  --exec /usr/local/bin/myapp \
  --description "My Application" \
  --user myuser

# 2. 安装 service
sudo mv myapp.service /etc/systemd/system/

# 3. 重载 systemd
sudo systemctl daemon-reload

# 4. 启用并启动服务
sudo systemctl enable myapp
sudo systemctl start myapp

# 5. 检查状态
sudo systemctl status myapp

# 6. 查看日志
sudo journalctl -u myapp -f
```

---

## 测试用例

在没有 sudo 权限的情况下测试：

```bash
# 生成 service 文件到临时目录
cargo run -- \
  --name test-service \
  --exec /bin/sleep \
  --output /tmp/test-service.service

# 查看生成的文件
cat /tmp/test-service.service
```

