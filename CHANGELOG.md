# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-12-02

### Added
- 初始发布
- 支持生成基础 systemd service 文件
- 命令行参数：
  - `--name`: 服务名称
  - `--exec`: 可执行文件路径
  - `--description`: 服务描述
  - `--working-dir`: 工作目录
  - `--user`: 运行用户（默认当前用户）
  - `--output`: 输出文件路径
- 自动验证可执行文件是否存在
- 提供安装步骤提示
- 完整的文档和示例

### Features
- ✅ 快速生成 systemd service 文件
- ✅ 友好的命令行界面
- ✅ 详细的错误提示
- ✅ 小体积可执行文件（~570KB）

