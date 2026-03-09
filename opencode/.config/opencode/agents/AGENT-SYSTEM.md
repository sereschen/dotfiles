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
| Average Cost/1M tokens | ~$16   | ~$3.60   | **78%**  |
| Builder Agent          | $18/1M | $3.60/1M | **80%**  |
| Subagent Average       | $15/1M | $3.60/1M | **76%**  |
| Free Tier Tasks        | $0     | $0       | **100%** |

## Agent Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│                    ARCHITECT AGENT                              │
│                 Kimi K2.5 ($3.60/1M)                            │
│     Routes tasks to appropriate agents based on complexity      │
└─────────────────────────────────────────────────────────────────┘
                               │
         ┌─────────────────────┼─────────────────────┐
         │                     │                     │
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│    BUILDER    │    │    FIXER      │    │   RESEARCH    │
│  Kimi K2.5    │    │  Kimi K2.5    │    │  Kimi K2.5    │
│  ($3.60/1M)   │    │  ($3.60/1M)   │    │  ($3.60/1M)   │
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

| Agent           | Model               | Cost     | Use For                                         |
| --------------- | ------------------- | -------- | ----------------------------------------------- |
| @architect      | Kimi K2.5           | $3.60/1M | Planning, orchestration, complex decisions      |
| @fixer          | Kimi K2.5           | $3.60/1M | Complex debugging, stuck situations             |
| @fixer-escalate | Claude Opus 4.5     | $30/1M   | Impossible bugs, last resort when Kimi fails    |

### Tier 2: Primary (Standard)

| Agent           | Model            | Cost     | Use For                                 |
| --------------- | ---------------- | -------- | --------------------------------------- |
| @build          | Kimi K2.5        | $3.60/1M | Feature implementation, code generation |
| @review         | Kimi K2.5        | $3.60/1M | Code review, quality analysis           |
| @test-generator | Kimi K2.5        | $3.60/1M | Test creation                           |
| @security-audit | Kimi K2.5        | $3.60/1M | Security scanning                       |
| @docs           | Kimi K2.5        | $3.60/1M | Documentation                           |
| @research       | Kimi K2.5        | $3.60/1M | Documentation lookup                    |
| @prototype      | Kimi K2.5        | $3.60/1M | UI prototyping                          |
| @study          | Kimi K2.5        | $3.60/1M | Learning and exploration                |

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
│   └─ Use PRIMARY tier (Kimi K2.5)
│       • @build for features
│       • @review for code review
│       • @test-generator for tests
│
├─ COMPLEX (architecture, security, debugging)?
│   └─ Use PRIMARY tier with Kimi K2.5
│       • @fixer for debugging
│       • @security-audit for security
│       • @architect for planning
│
└─ CRITICAL (impossible bugs, incidents)?
    └─ Use ESCALATE tier
        • @fixer-escalate (Opus $30/1M) - Only when Kimi K2.5 fails
```

## Model Configuration

### Primary Model: Kimi K2.5

- **Cost**: $0.60/M input, $3.00/M output
- **Context Window**: 256K tokens
- **Strengths**:
  - State-of-the-art coding performance
  - 256K context window for large codebases
  - Matches or exceeds GPT-5/Codex on coding tasks
  - 3-6x cheaper than Claude alternatives

### Fallback Model: Claude Opus 4.5

- **Cost**: $30/1M tokens
- **Use Case**: Only for @fixer-escalate when Kimi K2.5 cannot solve a problem
- **Strengths**:
  - Ultimate debugging capability
  - Best for impossible race conditions and concurrency issues
  - Critical production incident response

### Budget Model: Qwen3 Coder 480B

- **Cost**: $1.95/1M tokens
- **Use Case**: Simple code generation and unit tests
- **Strengths**: Cost-effective for straightforward tasks

### Free Models: GPT-5 Nano / GLM-4.7

- **Cost**: $0
- **Use Case**: Trivial tasks, scaffolding, basic documentation
- **Limitations**: Smaller context windows, less sophisticated reasoning

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

### Using Primary Tier (Kimi K2.5)

```
# For complex features
@build Implement JWT authentication with refresh tokens and rate limiting

# For comprehensive review
@review Review the authentication module for security issues

# For full test suites
@test-generator Create comprehensive tests for the payment processing module

# For debugging (start with fixer)
@fixer Debug this race condition in the payment processing module
```

### Using Escalate Tier (Claude Opus)

```
# Only when @fixer (Kimi K2.5) fails multiple times
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
- Then @build (Kimi K2.5) for implementation
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

### 1. Start with Kimi K2.5, Escalate to Opus Only When Necessary

- **Begin with Kimi K2.5** ($3.60/1M) for most tasks
- **Escalate to Opus** ($30/1M) only when Kimi truly cannot solve the problem
- Don't waste Opus on problems Kimi can handle
- Kimi K2.5 has excellent coding performance at a fraction of the cost

### 2. Batch Similar Tasks

- Group similar simple tasks together
- Use budget/free tiers for batches
- Example: Generate 10 test files with @test-generator-budget

### 3. Reserve Opus for Truly Critical Issues

- Use @fixer-escalate only for truly stuck situations
- Signs you need Opus: race conditions, complex concurrency, impossible bugs
- Kimi K2.5 handles 95% of debugging tasks effectively

### 4. Consider Context Size

- Kimi K2.5 has a 256K context window - excellent for large codebases
- Free models have smaller context windows
- Use Kimi for large file analysis

### 5. Monitor Quality

- If free/budget produces poor results, escalate to Kimi K2.5
- If Kimi K2.5 struggles after 2-3 attempts, escalate to Opus via @fixer-escalate
- Track which tiers work for which task types
- Adjust routing based on experience

## Configuration Files

### opencode.json

```json
{
  "model": "opencode-go/KIMI-k2.5",
  "small_model": "opencode-go/KIMI-k2.5",
  "fallback_model": "opencode/claude-opus-4-6",
  "provider": {
    "opencode": {
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
├── architect.md              # Strategic planning (Kimi K2.5)
├── build.md                  # Primary builder (Kimi K2.5)
├── build-budget.md           # Budget builder (Qwen3)
├── build-free.md             # Free builder (GPT-5 Nano)
├── fixer.md                  # Primary fixer (Kimi K2.5)
├── fixer-escalate.md         # Escalated fixer (Opus 4.5)
├── review.md                 # Primary review (Kimi K2.5)
├── review-free.md            # Free review (GLM-4.7)
├── test-generator.md         # Primary tests (Kimi K2.5)
├── test-generator-budget.md  # Budget tests (Qwen3)
├── test-generator-free.md    # Free tests (GPT-5 Nano)
├── docs.md                   # Primary docs (Kimi K2.5)
├── docs-free.md              # Free docs (GLM-4.7)
├── research.md               # Primary research (Kimi K2.5)
├── research-free.md          # Free research (GLM-4.7)
├── quick.md                  # Primary quick (Kimi K2.5)
├── quick-free.md             # Free quick (GPT-5 Nano)
└── ... (other specialized agents)
```

## Cost Tracking

To monitor your costs:

1. **OpenCode Zen Dashboard** - View usage at opencode.ai
2. **Per-Session Tracking** - Note which agents you use
3. **Monthly Review** - Compare costs before/after optimization

### Expected Monthly Savings

| Usage Level         | Before | After  | Savings |
| ------------------- | ------ | ------ | ------- |
| Light (5M tokens)   | $80    | $18    | $62/mo  |
| Medium (10M tokens) | $160   | $36    | $124/mo |
| Heavy (20M tokens)  | $320   | $72    | $248/mo |

### Cost Breakdown by Agent

| Agent Tier    | Model            | Cost/1M | Typical Monthly Use | Monthly Cost |
| ------------- | ---------------- | ------- | ------------------- | ------------ |
| Primary       | Kimi K2.5        | $3.60   | 10M tokens          | $36.00       |
| Budget        | Qwen3 Coder 480B | $1.95   | 2M tokens           | $3.90        |
| Free          | GPT-5 Nano       | $0      | 1M tokens           | $0           |
| Escalate      | Claude Opus 4.5  | $30     | 0.1M tokens         | $3.00        |
| **TOTAL**     |                  |         |                     | **$42.90**   |

## Troubleshooting

### Free Tier Produces Poor Results

- Escalate to budget or primary tier (Kimi K2.5)
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
- Don't retry more than twice with the same tier

### Kimi K2.5 Struggles with a Task

- After 2-3 attempts, escalate to @fixer-escalate (Claude Opus)
- Document what Kimi tried so Opus can focus on new approaches
- Use for: race conditions, complex concurrency, production incidents

## Changelog

- **v2.0** - Switched primary model from Gemini to Kimi K2.5
  - Updated all primary agents to use Kimi K2.5 ($3.60/1M)
  - Reserved Claude Opus ($30/1M) for @fixer-escalate only
  - Maintained budget and free tiers for cost-sensitive tasks
  - Achieved ~78% cost savings vs previous configuration

- **v1.0** - Initial multi-agent system with tiered routing
  - Added 9 new tiered agent variants
  - Updated architect with smart routing logic
  - Configured small_model for lightweight tasks
  - Added comprehensive documentation

---

_Last Updated: March 2026_
_System Version: 2.0_
