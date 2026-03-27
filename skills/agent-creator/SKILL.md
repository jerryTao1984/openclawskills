---
name: agent-creator
description: >
  一键创建 OpenClaw Agent 并绑定飞书群。
  自动生成工作目录、SOUL.md 人设文件、IDENTITY.md 身份文件、AGENTS.md 工作流文件。
  自动完成飞书群与 Agent 的绑定配置。
  Use when: 用户说"创建agent"、"新建智能体"、"配置飞书群"、"绑定群到agent"
  NOT for: 修改已有agent配置、删除agent、手动编辑配置文件
---

# Agent Creator - 智能体创建器

## When to Run
- 用户说"创建一个 agent 绑定飞书群"
- 用户提供飞书群 ID 和 agent 工作说明
- 用户说"帮我配置一个专门做XX的agent"

## Input Required
用户需要提供：
1. **飞书群 ID**：群聊的唯一标识（如何获取见下方说明）
2. **Agent 工作说明**：描述这个 agent 要做什么、有什么性格、什么红线

## Workflow

### Step 1: 解析用户输入
从用户消息中提取：
- `group_id`: 飞书群 ID（格式通常是 `oc_xxxxxx` 或数字）
- `work_description`: Agent 的工作说明（用于生成 SOUL.md）

如果信息不完整，向用户提问补全：
- "请提供飞书群 ID（可以在飞书群设置中复制）"
- "请描述这个 agent 的工作职责和性格特点"

### Step 2: 生成 Agent 名称
根据工作说明生成英文 agent id（如 `content_writer`、`data_analyst`、`customer_service`）

命名规则：小写字母+下划线，不超过 32 字符

### Step 3: 创建工作目录并执行创建
执行以下命令序列：

```bash
# 创建 agent
openclaw agents add {agent_id} --workspace ~/.openclaw/workspace-{agent_id}

# 如果命令不存在则使用 clawdbot
clawdbot agents add {agent_id} --workspace ~/.openclaw/workspace-{agent_id}
```

### Step 4: 生成引导文件
根据用户提供的工作说明，在 `~/.openclaw/workspace-{agent_id}/` 目录下生成：

**SOUL.md** - 核心人设文件（使用脚本生成）

**IDENTITY.md** - 身份定义

**AGENTS.md** - 工作流程定义

### Step 5: 绑定飞书群
获取当前 bindings 配置并追加新绑定：

```bash
# 查看当前配置
openclaw config get bindings
```

修改 `~/.openclaw/openclaw.json`，在 `bindings` 数组中添加：

```json
{
  "agentId": "{agent_id}",
  "match": {
    "channel": "feishu",
    "peer": {
      "kind": "group",
      "id": "{group_id}"
    }
  }
}
```

### Step 6: 验证配置
```bash
openclaw gateway restart
openclaw agents list --bindings
```

验证成功后，告知用户：
- Agent 已创建
- 工作目录位置
- 绑定状态

### Step 7: 测试确认
建议用户在飞书群 @机器人 发送一条测试消息，确认 agent 正常响应。

## Output Format
创建完成后，返回以下格式的确认信息：

```
✅ Agent 创建成功！

📋 Agent 信息：
- 名称：{agent_id}
- 工作目录：~/.openclaw/workspace-{agent_id}
- 绑定飞书群：{group_id}

📄 已生成配置文件：
- SOUL.md - 核心人设与价值观
- IDENTITY.md - 角色身份定义
- AGENTS.md - 工作流程说明

🔧 后续操作：
1. 在飞书群 @机器人 发送测试消息
2. 如需修改配置，编辑工作目录下的对应文件
3. 修改后执行 openclaw gateway restart 生效
```

## 获取飞书群 ID 的方法

1. 打开飞书桌面端或 Web 端
2. 进入目标群聊
3. 点击群设置
4. 复制群 ID（通常在群信息底部）

或通过命令行获取：
```bash
openclaw logs --follow
# 在群里 @机器人 发一条消息，终端日志中会显示 peer.id
```

## 注意事项
- 确保飞书机器人已添加到目标群
- 确保飞书应用已正确配置（App ID、App Secret）
- 如果绑定不生效，检查 `openclaw.json` 中 bindings 的缩进格式
- 每个 agent 对应唯一的工作目录，不要复用

## Error Handling
- 如果 agent 已存在，提示用户选择覆盖或使用其他名称
- 如果飞书群 ID 无效，提示重新获取
- 如果绑定失败，显示当前 bindings 配置供用户检查