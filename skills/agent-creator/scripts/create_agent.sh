#!/bin/bash
# create_agent.sh - 创建 Agent 并绑定飞书群
# 用法: ./create_agent.sh <agent_id> <group_id> <work_description_file>

set -e

AGENT_ID="$1"
GROUP_ID="$2"
DESC_FILE="$3"
WORKSPACE_DIR="$HOME/.openclaw/workspace-${AGENT_ID}"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 开始创建 Agent: ${AGENT_ID}${NC}"

# Step 1: 创建 agent
if command -v openclaw &> /dev/null; then
    if openclaw agents list 2>/dev/null | grep -q "$AGENT_ID"; then
        echo -e "${YELLOW}⚠️  Agent ${AGENT_ID} 已存在，跳过创建${NC}"
    else
        echo -e "${GREEN}📁 创建 Agent 工作目录...${NC}"
        openclaw agents add "$AGENT_ID" --workspace "$WORKSPACE_DIR" || \
        clawdbot agents add "$AGENT_ID" --workspace "$WORKSPACE_DIR" || \
        mkdir -p "$WORKSPACE_DIR"
    fi
else
    echo -e "${YELLOW}⚠️  openclaw 命令不存在，直接创建目录${NC}"
    mkdir -p "$WORKSPACE_DIR"
fi

# Step 2: 创建工作区文件结构
echo -e "${GREEN}📝 生成引导文件...${NC}"

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/../assets"

# 复制模板并替换变量
if [ -f "$ASSETS_DIR/SOUL_TEMPLATE.md" ]; then
    cp "$ASSETS_DIR/SOUL_TEMPLATE.md" "$WORKSPACE_DIR/SOUL.md"
fi
if [ -f "$ASSETS_DIR/IDENTITY_TEMPLATE.md" ]; then
    cp "$ASSETS_DIR/IDENTITY_TEMPLATE.md" "$WORKSPACE_DIR/IDENTITY.md"
fi
if [ -f "$ASSETS_DIR/AGENTS_TEMPLATE.md" ]; then
    cp "$ASSETS_DIR/AGENTS_TEMPLATE.md" "$WORKSPACE_DIR/AGENTS.md"
fi

# 如果提供了工作说明文件，替换 SOUL.md 中的占位符
if [ -f "$DESC_FILE" ] && [ -f "$WORKSPACE_DIR/SOUL.md" ]; then
    WORK_DESC=$(cat "$DESC_FILE")
    # 使用 perl 替换，因为 macOS 的 sed 不支持 -i 直接替换
    if command -v perl &> /dev/null; then
        perl -i -pe "s|\{\{WORK_DESCRIPTION\}\}|$WORK_DESC|g" "$WORKSPACE_DIR/SOUL.md"
    fi
fi

# Step 3: 绑定飞书群
echo -e "${GREEN}🔗 绑定飞书群: ${GROUP_ID}${NC}"

CONFIG_FILE="$HOME/.openclaw/openclaw.json"

# 确保 openclaw 目录存在
mkdir -p "$(dirname "$CONFIG_FILE")"

# 检查是否已有配置文件
if [ ! -f "$CONFIG_FILE" ]; then
    echo '{"bindings": []}' > "$CONFIG_FILE"
fi

# 检查是否已安装 jq
if command -v jq &> /dev/null; then
    # 检查是否已存在相同绑定
    if jq -e ".bindings[] | select(.agentId == \"$AGENT_ID\")" "$CONFIG_FILE" > /dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Agent ${AGENT_ID} 已有绑定配置${NC}"
    else
        # 使用 jq 追加绑定
        jq ".bindings += [{\"agentId\": \"$AGENT_ID\", \"match\": {\"channel\": \"feishu\", \"peer\": {\"kind\": \"group\", \"id\": \"$GROUP_ID\"}}}]" \
            "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
        echo -e "${GREEN}✅ 飞书群绑定已添加${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  未安装 jq，请手动添加以下配置到 openclaw.json 的 bindings 数组中：${NC}"
    echo ""
    echo "{"
    echo "  \"agentId\": \"$AGENT_ID\","
    echo "  \"match\": {"
    echo "    \"channel\": \"feishu\","
    echo "    \"peer\": {"
    echo "      \"kind\": \"group\","
    echo "      \"id\": \"$GROUP_ID\""
    echo "    }"
    echo "  }"
    echo "}"
fi

# Step 4: 重启网关（如果可用）
if command -v openclaw &> /dev/null; then
    echo -e "${GREEN}🔄 重启 Gateway...${NC}"
    openclaw gateway restart 2>/dev/null || true
fi

# Step 5: 验证
echo -e "${GREEN}✅ 验证 Agent 状态...${NC}"
if [ -d "$WORKSPACE_DIR" ]; then
    echo -e "${GREEN}✅ 工作目录已创建: $WORKSPACE_DIR${NC}"
    ls -la "$WORKSPACE_DIR"
fi

echo ""
echo -e "${GREEN}🎉 Agent 创建完成！${NC}"
echo -e "工作目录: ${YELLOW}$WORKSPACE_DIR${NC}"
echo -e "请在飞书群 @机器人 发送消息测试"