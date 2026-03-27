# OpenClaw Skills

OpenClaw Skills 集合，每个 skill 独立存放在 `skills/` 目录下。

## Skills 列表

| Skill | 描述 |
|-------|------|
| [agent-creator](./skills/agent-creator) | 一键创建 Agent 并绑定飞书群 |

## 只下载特定 Skill

### 方法一：Sparse Checkout（推荐）

```bash
# 1. 创建空仓库
git init openclawskills
cd openclawskills

# 2. 添加远程仓库
git remote add origin https://github.com/你的用户名/openclawskills.git

# 3. 启用 sparse checkout
git config core.sparseCheckout true

# 4. 指定只下载的 skill 目录
echo "skills/agent-creator/*" >> .git/info/sparse-checkout

# 5. 拉取
git pull origin main
```

### 方法二：下载特定目录（需要 svn）

```bash
svn export https://github.com/你的用户名/openclawskills/trunk/skills/agent-creator
```

### 方法三：GitHub API 下载 ZIP

```bash
# 下载单个目录的 zip（需要第三方工具如 downgit）
# 或直接在 GitHub 网页点击目录 -> Download
```

## 安装 Skill

将下载的 skill 目录复制到 OpenClaw 的 skills 目录：

```bash
cp -r skills/agent-creator ~/.openclaw/skills/
```

## 贡献

欢迎提交新的 skill！

1. Fork 本仓库
2. 在 `skills/` 下创建新目录
3. 提交 Pull Request