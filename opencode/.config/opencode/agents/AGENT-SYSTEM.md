# OpenCode Multi-Agent Cost Optimization System

This document describes the cost-optimized multi-agent architecture for OpenCode.

## Overview

Our agent system is designed to minimize token costs while maintaining high code quality. We achieve this through:

1. **Tiered Model Assignment** - Different models for different task complexities
2. **Specialized Agents** - Purpose-built agents for specific tasks
3. **Smart Routing** - The architect routes tasks to the most cost-effective agent
4. **Escalation Paths** - Clear paths to more capable models when needed

## Cost Savings Summary

| Metric                 | Before | After    | Savings  |
| ---------------------- | ------ | -------- | -------- |
| Average Cost/1M tokens | ~$16   | ~$6.50   | **60%**  |
| Builder Agent          | $18/1M | $3.50/1M | **81%**  |
| Subagent Average       | $15/1M | $6/1M    | **60%**  |
| Free Tier Tasks        | $0     | $0       | **100%** |

## Agent Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│                    ARCHITECT AGENT                              │
│                 Claude Sonnet 4.5 ($18/1M)                     │
│     Routes tasks to appropriate agents based on complexity      │
└─────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│    BUILDER    │    │    FIXER      │    │   RESEARCH    │
│ Gemini Flash  │    │ Sonnet 4.5    │    │  Haiku 4.5    │
│  ($3.50/1M)   │    │  ($18/1M)     │    │   ($6/1M)     │
└───────────────┘    └───────────────┘    └───────────────┘
        │                     │
   ┌────┴────┐           ┌────┴────┐
   │         │           │         │
┌──────┐ ┌──────┐   ┌──────┐ ┌──────┐
│Budget│ │ Free │   │Escalate│ │     │
│$1.95 │ │ $0   │   │ $30   │ │     │
└──────┘ └──────┘   └──────┘ └──────┘
```

## Agent Tiers

### Tier 1: Strategic (Premium)

| Agent           | Model             | Cost   | Use For                                    |
| --------------- | ----------------- | ------ | ------------------------------------------ |
| @architect      | Claude Sonnet 4.5 | $18/1M | Planning, orchestration, complex decisions |
| @fixer          | Claude Sonnet 4.5 | $18/1M | Complex debugging, stuck situations        |
| @fixer-escalate | Claude Opus 4.5   | $30/1M | Impossible bugs (last resort)              |

### Tier 2: Primary (Standard)

| Agent           | Model            | Cost     | Use For                                 |
| --------------- | ---------------- | -------- | --------------------------------------- |
| @build          | Gemini 3 Flash   | $3.50/1M | Feature implementation, code generation |
| @review         | Claude Haiku 4.5 | $6/1M    | Code review, quality analysis           |
| @test-generator | Claude Haiku 4.5 | $6/1M    | Test creation                           |
| @security-audit | Claude Haiku 4.5 | $6/1M    | Security scanning                       |
| @docs           | Claude Haiku 4.5 | $6/1M    | Documentation                           |
| @research       | Claude Haiku 4.5 | $6/1M    | Documentation lookup                    |

### Tier 3: Budget (Cost-Sensitive)

| Agent                  | Model            | Cost     | Use For                |
| ---------------------- | ---------------- | -------- | ---------------------- |
| @build-budget          | Qwen3 Coder 480B | $1.95/1M | Simple code generation |
| @test-generator-budget | Qwen3 Coder 480B | $1.95/1M | Simple unit tests      |

### Tier 4: Free (Trivial Tasks)

| Agent                | Model      | Cost | Use For                  |
| -------------------- | ---------- | ---- | ------------------------ |
| @build-free          | GPT-5 Nano | $0   | Scaffolding, boilerplate |
| @quick-free          | GPT-5 Nano | $0   | Trivial edits            |
| @docs-free           | GLM-4.7    | $0   | Basic README             |
| @review-free         | GLM-4.7    | $0   | Style checks only        |
| @research-free       | GLM-4.7    | $0   | Simple lookups           |
| @test-generator-free | GPT-5 Nano | $0   | Test scaffolding         |

## Routing Decision Tree

```
START: What type of task?
│
├─ TRIVIAL (formatting, boilerplate, simple edits)?
│   └─ Use FREE tier
│       • @build-free for scaffolding
│       • @quick-free for trivial edits
│       • @docs-free for basic README
│
├─ SIMPLE (basic features, standard patterns)?
│   └─ Use BUDGET tier
│       • @build-budget for simple features
│       • @test-generator-budget for basic tests
│
├─ STANDARD (typical development)?
│   └─ Use PRIMARY tier
│       • @build for features
│       • @review for code review
│       • @test-generator for tests
│
├─ COMPLEX (architecture, security, debugging)?
│   └─ Use PRIMARY with full context
│       • @fixer for debugging
│       • @security-audit for security
│
└─ CRITICAL (impossible bugs, incidents)?
    └─ Use ESCALATE tier
        • @fixer-escalate (Opus $30/1M)
```

## Usage Examples

### Using Free Tier

```
# For scaffolding
@build-free Create a basic Express server with health endpoint

# For trivial edits
@quick-free Rename the variable 'foo' to 'userCount' in utils.ts

# For basic docs
@docs-free Update the README with installation instructions
```

### Using Budget Tier

```
# For simple features
@build-budget Add a GET /users endpoint that returns all users

# For basic tests
@test-generator-budget Create unit tests for the UserService class
```

### Using Primary Tier

```
# For complex features
@build Implement JWT authentication with refresh tokens and rate limiting

# For comprehensive review
@review Review the authentication module for security issues

# For full test suites
@test-generator Create comprehensive tests for the payment processing module
```

### Using Escalate Tier

```
# Only when @fixer fails multiple times
@fixer-escalate Debug this race condition that @fixer couldn't solve: [context]
```

## Architect Routing

The @architect agent automatically routes tasks to appropriate tiers. When using @architect:

1. **Describe your task** - The architect assesses complexity
2. **Architect chooses tier** - Based on task requirements
3. **Delegates to appropriate agent** - Using the Task tool
4. **Monitors results** - Escalates if needed

### Example Architect Workflow

```
User: "Add user authentication to the app"

Architect thinks:
- This is a COMPLEX task (security-sensitive)
- Needs @research first for best practices
- Then @build (primary tier) for implementation
- Then @security-audit for review
- Then @test-generator for tests

Architect delegates:
1. Task(subagent_type="research", prompt="Research JWT best practices...")
2. Task(subagent_type="build", prompt="Implement authentication...")
3. Task(subagent_type="security-audit", prompt="Review auth implementation...")
4. Task(subagent_type="test-generator", prompt="Create auth tests...")
```

## Switching Between Agents

### Via Tab Key (Primary Agents)

Press Tab to cycle through primary agents:

- @architect
- @build
- @quick
- @quick-free
- @prototype
- @study

### Via @mention (Any Agent)

Type @ followed by agent name:

- @build-budget
- @fixer-escalate
- @review-free
- etc.

### Via /models Command

Change model for current agent:

```
/models
```

## Best Practices

### 1. Start Low, Escalate as Needed

- Begin with the cheapest appropriate tier
- Only escalate if quality is insufficient
- Don't retry more than twice at the same tier

### 2. Batch Similar Tasks

- Group similar simple tasks together
- Use budget/free tiers for batches
- Example: Generate 10 test files with @test-generator-budget

### 3. Reserve Premium for Critical

- Use @fixer-escalate only for truly stuck situations
- Don't waste Opus on simple bugs
- Security reviews should use primary tier minimum

### 4. Consider Context Size

- Free models have smaller context windows
- Use primary tier for large file analysis
- Budget tier works for focused, small tasks

### 5. Monitor Quality

- If free/budget produces poor results, escalate
- Track which tiers work for which task types
- Adjust routing based on experience

## Configuration Files

### opencode.json

```json
{
  "model": "opencode/claude-sonnet-4-5",
  "small_model": "opencode/claude-haiku-4-5",
  "provider": {
    "anthropic": {
      "options": {
        "setCacheKey": true
      }
    }
  }
}
```

### Agent Files Location

```
~/.config/opencode/agent/
├── architect.md          # Strategic planning (Sonnet 4.5)
├── build.md              # Primary builder (Gemini Flash)
├── build-budget.md       # Budget builder (Qwen3)
├── build-free.md         # Free builder (GPT-5 Nano)
├── fixer.md              # Primary fixer (Sonnet 4.5)
├── fixer-escalate.md     # Escalated fixer (Opus 4.5)
├── review.md             # Primary review (Haiku 4.5)
├── review-free.md        # Free review (GLM-4.7)
├── test-generator.md     # Primary tests (Haiku 4.5)
├── test-generator-budget.md  # Budget tests (Qwen3)
├── test-generator-free.md    # Free tests (GPT-5 Nano)
├── docs.md               # Primary docs (Haiku 4.5)
├── docs-free.md          # Free docs (GLM-4.7)
├── research.md           # Primary research (Haiku 4.5)
├── research-free.md      # Free research (GLM-4.7)
├── quick.md              # Primary quick (Haiku 4.5)
├── quick-free.md         # Free quick (GPT-5 Nano)
└── ... (other specialized agents)
```

## Cost Tracking

To monitor your costs:

1. **OpenCode Zen Dashboard** - View usage at opencode.ai
2. **Per-Session Tracking** - Note which agents you use
3. **Monthly Review** - Compare costs before/after optimization

### Expected Monthly Savings

| Usage Level         | Before | After | Savings |
| ------------------- | ------ | ----- | ------- |
| Light (5M tokens)   | $80    | $32   | $48/mo  |
| Medium (10M tokens) | $160   | $65   | $95/mo  |
| Heavy (20M tokens)  | $320   | $130  | $190/mo |

## Troubleshooting

### Free Tier Produces Poor Results

- Escalate to budget or primary tier
- Free models have limitations
- Use for truly trivial tasks only

### Agent Not Found

- Check agent file exists in ~/.config/opencode/agent/
- Verify filename matches (case-sensitive)
- Restart OpenCode after adding new agents

### Model Unavailable

- Free models may have rate limits
- Try alternative free model
- Fall back to budget tier

### Task Too Complex for Tier

- Signs: incomplete output, errors, poor quality
- Solution: escalate to next tier
- Don't retry more than twice

## Changelog

- **v1.0** - Initial multi-agent system with tiered routing
- Added 9 new tiered agent variants
- Updated architect with smart routing logic
- Configured small_model for lightweight tasks
- Added comprehensive documentation

---

_Last Updated: January 2026_
_System Version: 1.0_
