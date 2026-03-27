# OpenClaw Skills

## 一键安装 agent-creator

```bash
curl -fsSL https://raw.githubusercontent.com/jerryTao1984/openclawskills/main/install.sh | bash
```

安装后，在 OpenClaw 中说：
```
帮我创建一个 agent，绑定飞书群 oc_xxx，这个 agent 的工作是：xxx
```

---

## Skills 列表

| Skill | 描述 |
|-------|------|
| [agent-creator](./skills/agent-creator) | 一键创建 Agent 并绑定飞书群 |
| [feishu-bitable-manager](./skills/feishu-bitable-manager) | 飞书多维表格项目进度管理（新增/修改/读取） |
| [prd-doc-creator](./skills/prd-doc-creator) | 创建飞书需求文档（PRD），支持流程图生成 |

---

## 手动安装

如果一键安装失败，可以手动操作：

```bash
# 1. 创建目录
mkdir -p ~/.openclaw/skills

# 2. 下载并解压
curl -L https://github.com/jerryTao1984/openclawskills/archive/refs/heads/main.tar.gz | tar -xz

# 3. 复制 skill
cp -r openclawskills-main/skills/agent-creator ~/.openclaw/skills/

# 4. 清理
rm -rf openclawskills-main
```