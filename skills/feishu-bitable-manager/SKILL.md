---
name: feishu-bitable-manager
description: >
  飞书多维表格项目进度管理。
  支持新增、修改、读取项目进度表。
  Use when: 用户说"查看进度"、"新增任务"、"更新进度"、"项目进度"、"飞书多维表格"、"修改需求"
---

# 飞书多维表格项目进度管理

## When to Run
- 用户说"查看项目进度"、"读取进度表"
- 用户说"新增任务"、"添加需求"
- 用户说"修改进度"、"更新状态"
- 用户说"在飞书多维表格中..."

## 项目进度表配置

**多维表格 URL**: https://ewbmxoqgfx.feishu.cn/wiki/T2FqwW8eji1yu7kogIlcmjm7nth?table=tblQzT4DZYnuPB8A&view=vewL6TrEga

| 参数 | 值 |
|-----|-----|
| app_token | `T2FqwW8eji1yu7kogIlcmjm7nth` |
| table_id | `tblQzT4DZYnuPB8A` |
| view_id | `vewL6TrEga` |

## 前置条件

确保已配置飞书应用权限：
- `bitable:record:read` - 读取多维表格记录
- `bitable:record:write` - 写入多维表格记录
- `bitable:app` - 获取多维表格信息
- `wiki:wiki:read` - 读取知识库（因为是知识库中的多维表格）

## 常用操作

### 1. 读取项目进度

**用户说**："查看项目进度"、"读取进度表"

**执行步骤**：

```bash
# 调用飞书 API 获取多维表格记录
curl -X GET "https://open.feishu.cn/open-apis/bitable/v1/apps/T2FqwW8eji1yu7kogIlcmjm7nth/tables/tblQzT4DZYnuPB8A/records" \
  -H "Authorization: Bearer {tenant_access_token}"
```

**输出格式**：
```
📋 项目进度一览

| 任务名称 | 负责人 | 状态 | 截止日期 | 备注 |
|---------|--------|------|---------|------|
| 用户登录功能 | 张三 | 进行中 | 2024-01-15 | 待联调 |
| 支付模块 | 李四 | 未开始 | 2024-01-20 | - |
```

---

### 2. 新增任务/需求

**用户说**："新增一个任务：xxx"、"添加需求：xxx"

**执行步骤**：

1. 从用户消息提取信息：
   - 任务名称
   - 负责人（可选）
   - 截止日期（可选）
   - 优先级（可选）

2. 调用 API 新增记录：

```bash
curl -X POST "https://open.feishu.cn/open-apis/bitable/v1/apps/T2FqwW8eji1yu7kogIlcmjm7nth/tables/tblQzT4DZYnuPB8A/records" \
  -H "Authorization: Bearer {tenant_access_token}" \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "任务名称": "用户注册功能",
      "负责人": "张三",
      "状态": "未开始",
      "截止日期": 1704067200000,
      "优先级": "高"
    }
  }'
```

**确认输出**：
```
✅ 任务已添加

📝 任务：用户注册功能
👤 负责人：张三
📅 截止日期：2024-01-01
🔴 优先级：高
```

---

### 3. 修改任务进度

**用户说**："把xxx改成进行中"、"更新xxx的状态为已完成"

**执行步骤**：

1. 先查询获取 record_id
2. 调用 API 更新记录：

```bash
curl -X PUT "https://open.feishu.cn/open-apis/bitable/v1/apps/T2FqwW8eji1yu7kogIlcmjm7nth/tables/tblQzT4DZYnuPB8A/records/{record_id}" \
  -H "Authorization: Bearer {tenant_access_token}" \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "状态": "已完成"
    }
  }'
```

**确认输出**：
```
✅ 任务状态已更新

📝 任务：用户登录功能
📊 状态：未开始 → 已完成
```

---

### 4. 按条件筛选

**用户说**："查看张三的任务"、"显示进行中的任务"

**执行 API**：

```bash
curl -X POST "https://open.feishu.cn/open-apis/bitable/v1/apps/T2FqwW8eji1yu7kogIlcmjm7nth/tables/tblQzT4DZYnuPB8A/records/search" \
  -H "Authorization: Bearer {tenant_access_token}" \
  -H "Content-Type: application/json" \
  -d '{
    "filter": {
      "conjunction": "and",
      "conditions": [
        {
          "field_name": "状态",
          "operator": "is",
          "value": ["进行中"]
        }
      ]
    }
  }'
```

---

## 获取 tenant_access_token

```bash
curl -X POST "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal" \
  -H "Content-Type: application/json" \
  -d '{
    "app_id": "{APP_ID}",
    "app_secret": "{APP_SECRET}"
  }'
```

---

## 错误处理

| 错误 | 解决方案 |
|-----|---------|
| 权限不足 | 检查飞书应用是否配置了对应权限 |
| token 过期 | 重新获取 tenant_access_token |
| 记录不存在 | 确认 record_id 是否正确 |
| 字段不存在 | 确认字段名称与多维表格一致 |

---

## 输出规范

- 使用表格展示列表数据
- 操作成功显示 ✅
- 操作失败显示 ❌ 并说明原因
- 日期格式：YYYY-MM-DD

---

## 字段规范

### 项目名称（必填）

只能是以下四个之一：
| 项目名称 |
|---------|
| 爱推广 |
| 涵兔兔 |
| 如涵播物馆 |
| 创享储蓄罐 |

**新建需求时必须询问用户选择哪个项目。**

### 需求状态

| 状态 | 说明 |
|-----|------|
| 收集需求 | 默认状态，需求刚录入 |
| 需求确定待制作方案 | 需求已明确，等待方案 |
| 方案中 | 正在制作方案 |
| 排期中 | 方案已定，等待排期 |
| 开发中 | 正在开发 |
| 测试中 | 开发完成，测试中 |
| 已上线 | 已发布上线 |
| 挂起 | 暂时搁置 |

**新建需求时默认状态为"收集需求"，如果用户明确指定状态则使用用户指定的值。**

### 产品PRD

用户可提供飞书在线文档链接作为产品PRD，格式如：
```
https://ewbmxoqgfx.feishu.cn/docx/xxx
```

---

## 新建需求流程

### Step 1: 收集信息

从用户消息中提取：
- **需求名称**（必填）
- **关联项目**（必填，询问用户选择）
- **负责人**（可选）
- **截止日期**（可选）
- **需求状态**（默认"收集需求"）
- **产品PRD链接**（可选，飞书文档链接）

### Step 2: 询问项目

如果用户未指定项目，询问：
```
请选择关联项目：
1. 爱推广
2. 涵兔兔
3. 如涵播物馆
4. 创享储蓄罐
```

### Step 3: 确认信息

新建前展示确认：
```
📝 请确认需求信息：

- 需求名称：xxx
- 关联项目：爱推广
- 负责人：张三
- 需求状态：收集需求
- 产品PRD：https://xxx

确认创建？(是/否)
```

### Step 4: 执行创建

用户确认后调用 API 创建记录：

```bash
curl -X POST "https://open.feishu.cn/open-apis/bitable/v1/apps/T2FqwW8eji1yu7kogIlcmjm7nth/tables/tblQzT4DZYnuPB8A/records" \
  -H "Authorization: Bearer {tenant_access_token}" \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "需求名称": "用户注册功能优化",
      "关联项目": "爱推广",
      "负责人": "张三",
      "需求状态": "收集需求",
      "产品PRD": "https://ewbmxoqgfx.feishu.cn/docx/xxx"
    }
  }'
```

---

## 示例对话

**用户**: 新增一个需求

**Agent**: 请提供需求信息：
1. 需求名称是什么？
2. 关联哪个项目？
   - 爱推广
   - 涵兔兔
   - 如涵播物馆
   - 创享储蓄罐

**用户**: 需求名称是首页banner优化，项目是爱推广

**Agent**:
```
📝 请确认需求信息：

- 需求名称：首页banner优化
- 关联项目：爱推广
- 需求状态：收集需求（默认）

确认创建？(是/否)
```

**用户**: 确认，负责人是张三，PRD链接是 https://ewbmxoqgfx.feishu.cn/docx/abc

**Agent**:
```
✅ 需求已创建

📝 需求名称：首页banner优化
📁 关联项目：爱推广
👤 负责人：张三
📊 需求状态：收集需求
📄 产品PRD：https://ewbmxoqgfx.feishu.cn/docx/abc
```

---

## 修改状态流程

**用户**: 把首页banner优化改成开发中

**Agent**:
```
✅ 需求状态已更新

📝 需求：首页banner优化
📊 状态：收集需求 → 开发中
```