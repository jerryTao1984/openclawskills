#!/bin/bash
# 一键安装 OpenClaw Skills

set -e

SKILLS_DIR="$HOME/.openclaw/skills"
TEMP_DIR=$(mktemp -d)

echo "🚀 正在安装 OpenClaw Skills..."

# 下载
curl -L "https://github.com/jerryTao1984/openclawskills/archive/refs/heads/main.tar.gz" | tar -xz -C "$TEMP_DIR"

# 安装
mkdir -p "$SKILLS_DIR"
cp -r "$TEMP_DIR/openclawskills-main/skills/"* "$SKILLS_DIR/"

# 清理
rm -rf "$TEMP_DIR"

# 设置权限
find "$SKILLS_DIR" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

echo "✅ 安装完成！"
echo "📍 安装位置: $SKILLS_DIR"
echo ""
echo "已安装的 Skills："
echo "  - agent-creator: 创建 Agent 并绑定飞书群"
echo "  - feishu-bitable-manager: 飞书多维表格项目进度管理"
echo "  - prd-doc-creator: 创建飞书需求文档（PRD）"