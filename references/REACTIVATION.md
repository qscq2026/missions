# Missions 再次启动协议

> **场景**: 项目已存在 `.missions/` 目录，需要继续执行、修复卡死任务、或启动新 Mission  
> **核心原则**: 经验优先 — 启动时必须先读取经验库，避免重复踩坑

---

## 启动类型检测

Agent 执行启动时，首先检测当前状态：

```bash
# 检测 1: 是否存在运行时目录？
ls .missions/ 2>/dev/null

# 检测 2: 是否有进行中的任务？
ls .missions/03-running/ 2>/dev/null | grep -v ".gitkeep"

# 检测 3: 经验库是否存在？
ls .missions/logs/experience/INDEX.md 2>/dev/null

# 检测 4: 上次 Mission 是否完成？
cat .missions/README.md | grep "mission_status"
```

### 四种启动场景

| 场景 | 检测条件 | 启动方式 |
|------|---------|---------|
| **冷启动** | `.missions/` 不存在 | 全新初始化 + 读取 seed 经验 |
| **续执行** | `03-running/` 有文件 | 恢复执行 + 读取已有经验 |
| **新 Mission** | 上次已完成，用户有新目标 | 保留经验库，重置状态机 |
| **修复模式** | 任务卡死或 Agent 崩溃 | 诊断 + 回退 + 续执行 |

---

## 启动流程（Boot Sequence v2）

```
┌─────────────────────────────────────────────────────────────┐
│                    MISSION REACTIVATION                       │
│                      启动流程 v2.0                            │
└─────────────────────────────────────────────────────────────┘

STEP 0: 检测启动类型
    │
    ├──► 冷启动？ ──► 执行「全新初始化流程」
    │
    ├──► 续执行？ ──► 执行「续执行流程」
    │
    ├──► 新 Mission？ ──► 执行「新 Mission 流程」
    │
    └──► 修复模式？ ──► 执行「修复流程」


┌─────────────────────────────────────────────────────────────┐
│ 全新初始化流程（Cold Start）                                 │
├─────────────────────────────────────────────────────────────┤
│  1. READ {baseDir}/SKILL.md                                  │
│  2. READ {baseDir}/references/AGENTS.md                      │
│  3. READ {baseDir}/references/CONFIG.md                      │
│  4. CREATE .missions/ directory structure                    │
│  5. COPY seed experiences:                                   │
│     .missions/logs/experience/ ← {baseDir}/references/examples/experience/│
│  6. READ .missions/logs/experience/INDEX.md                  │
│  7. REPORT: "已加载 N 条经验记录"                            │
│  8. ASK user for project goal                                │
│  9. SWITCH to Orchestrator                                   │
└─────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────┐
│ 续执行流程（Resume Execution）                               │
├─────────────────────────────────────────────────────────────┤
│  1. READ {baseDir}/SKILL.md                                  │
│  2. READ .missions/README.md （获取当前状态）                │
│  3. READ .missions/config.yaml （获取用户配置）              │
│  4. *** READ .missions/logs/experience/INDEX.md ***          │
│     └── 这是强制步骤，不可跳过                                │
│  5. *** READ relevant experiences ***                        │
│     └── 根据当前任务类型，读取相关经验                        │
│  6. REPORT: "已加载 N 条经验，发现 X 条相关记录"             │
│  7. READ .missions/03-running/*.md （恢复上下文）            │
│  8. SWITCH to 对应角色（Worker/Validator/Fix）               │
│  9. EXECUTE with experience applied                          │
└─────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────┐
│ 新 Mission 流程（New Mission）                               │
├─────────────────────────────────────────────────────────────┤
│  1. READ {baseDir}/SKILL.md                                  │
│  2. READ .missions/logs/experience/INDEX.md                  │
│  3. *** READ all experiences ***                             │
│     └── 新 Mission 可能涉及任何领域，需要全量经验             │
│  4. REPORT: "已加载 N 条历史经验"                            │
│  5. ARCHIVE old state:                                       │
│     mv .missions/05-done/ .missions/archive/old-mission/     │
│     mv .missions/08-merged/ .missions/archive/old-mission/   │
│  6. RESET state folders (keep 01-contract/ as reference)     │
│  7. ASK user for new project goal                            │
│  8. SWITCH to Orchestrator                                   │
└─────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────┐
│ 修复流程（Recovery Mode）                                    │
├─────────────────────────────────────────────────────────────┤
│  1. READ .missions/README.md                                 │
│  2. DIAGNOSE: 检测卡死原因                                   │
│     - 03-running/ 文件年龄 > 20min？                        │
│     - 04-review/ 长期未处理？                               │
│     - 06-fix/ 循环超过 3 次？                               │
│  3. READ .missions/logs/experience/anti-patterns/            │
│     └── 查找类似卡死场景的经验                                │
│  4. APPLY recovery strategy:                                 │
│     - 卡死 → mv 03-running/X.md 02-ready/X.md               │
│     - 循环 → 拆分为更小任务                                   │
│     - 崩溃 → 从上次成功 commit 恢复                          │
│  5. LOG recovery action to audit/                            │
│  6. RESUME normal execution                                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 经验读取保证机制

### 机制 1: 启动时强制读取

在 `AGENTS.md` 的 **Shared Rules** 中添加：

```markdown
## Shared Rules (All Roles) — Updated with Experience

1. **Experience First**: Before executing any task, the agent MUST:
   - Read `.missions/logs/experience/INDEX.md`
   - Identify experiences matching current task category
   - Read relevant experience records
   - Apply learned patterns and avoid documented anti-patterns

2. **Serial Write, Parallel Read**: ...
3. **No Long-term Memory**: ...
```

### 机制 2: 任务卡片中嵌入经验提醒

任务卡片模板自动附加经验提示：

```markdown
## Experience Check（自动附加）

Before starting this task, check:
- [ ] Read `.missions/logs/experience/INDEX.md`
- [ ] Search for experiences in category: {{task_category}}
- [ ] Apply any relevant patterns
- [ ] Avoid any documented anti-patterns

### Relevant Experiences Found:
{{#each relevant_experiences}}
- [{{id}}]({{path}}): {{title}} ({{type}})
{{/each}}

### Warnings:
{{#each relevant_anti_patterns}}
⚠️ **{{title}}**: {{description}}
{{/each}}
```

### 机制 3: 启动自检清单

Agent 启动时必须完成的检查：

```markdown
## Reactivation Checklist

- [ ] Detected start type: [cold/resume/new/recovery]
- [ ] Loaded config from: `.missions/config.yaml`
- [ ] **Read experience INDEX: `.missions/logs/experience/INDEX.md`**
- [ ] **Loaded N relevant experiences**
- [ ] Current state: [status from README.md]
- [ ] Ready to execute as: [role]
```

### 机制 4: 经验应用验证

Validator 验证时，增加经验应用检查：

```markdown
## Validation Report — Experience Section

- [ ] Worker read relevant experiences before implementation
- [ ] No documented anti-patterns were repeated
- [ ] Documented patterns were correctly applied
- [ ] If new issue found: trigger Experience Curator to record
```

---

## 经验匹配算法

```python
# 伪代码：经验匹配
def match_experiences(task_card, experience_index):
    matches = []

    # 1. 按类别匹配
    task_category = task_card.get('category', 'general')
    for exp in experience_index.by_category.get(task_category, []):
        matches.append(exp)

    # 2. 按技术栈匹配
    task_tech = f"{task_card.project.language}/{task_card.project.framework}"
    for exp in experience_index.all:
        if task_tech in exp.context.get('tech_stack', []):
            matches.append(exp)

    # 3. 按断言匹配
    for assertion in task_card.contract_assertions:
        for exp in experience_index.by_assertion.get(assertion, []):
            matches.append(exp)

    # 4. 去重 + 按 severity 排序
    matches = deduplicate(matches)
    matches.sort(key=lambda e: e.severity_priority, reverse=True)

    # 5. 返回 top 5
    return matches[:5]
```

---

## 经验更新触发条件

Experience Curator 在以下时机自动运行：

| 时机 | 动作 | 生成的经验 |
|------|------|-----------|
| Feature 首次通过验证 | 记录成功模式 | pattern |
| Feature 出现 blocking | 记录失败教训 | anti-pattern |
| Fix 成功解决 blocking | 记录修复策略 | fix-strategy |
| 同一问题出现 2 次 | 升级为经验 | anti-pattern |
| 同一方案成功 3 次 | 升级为模式 | pattern |
| Mission 完成 | 全面复盘，生成所有类型 | all |

---

## 人类查看经验

```bash
# 查看所有经验
cat .missions/logs/experience/INDEX.md

# 查看特定类别
cat .missions/logs/experience/patterns/*.md
cat .missions/logs/experience/anti-patterns/*.md
cat .missions/logs/experience/fixes/*.md

# 查看最近更新
ls -lt .missions/logs/experience/*/

# 查看经验应用统计
cat .missions/logs/experience/INDEX.md | grep "applied"
```

---

## 经验质量保障

1. **去重**: 相同根因的经验合并，增加 `apply_count`
2. **验证**: 经验必须被后续 Mission 验证才标记为 confirmed
3. **淘汰**: `apply_count=0` 且超过 30 天的经验标记为 stale
4. **人工审核**: 用户可手动编辑/删除经验，添加 `# human-verified` 标签
