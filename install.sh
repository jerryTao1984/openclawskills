#!/bin/bash
# 一键安装 agent-creator skill

set -e

INSTALL_DIR="$HOME/.openclaw/skills/agent-creator"
TEMP_DIR=$(mktemp -d)

echo "🚀 正在安装 agent-creator skill..."

# 下载
curl -L "https://github.com/jerryTao1984/openclawskills/archive/refs/heads/main.tar.gz" | tar -xz -C "$TEMP_DIR"

# 安装
mkdir -p "$HOME/.openclaw/skills"
cp -r "$TEMP_DIR/openclawskills-main/skills/agent-creator" "$INSTALL_DIR"

# 清理
rm -rf "$TEMP_DIR"

# 设置权限
chmod +x "$INSTALL_DIR/scripts/create_agent.sh" 2>/dev/null || true

echo "✅ 安装完成！"
echo "📍 安装位置: $INSTALL_DIR"
echo ""
echo "使用方法："
echo "  在 OpenClaw 中说：帮我创建一个 agent，绑定飞书群 xxx，工作说明是..."