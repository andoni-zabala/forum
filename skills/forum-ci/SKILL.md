---
name: forum-ci
description: >
  CI checks and GitHub Actions workflow for Forum project.
  Trigger: When debugging CI failures, inspecting workflows, or understanding PR gates.
license: MIT
metadata:
  author: forum
  version: "1.0"
  scope: [root]
  auto_invoke:
    - "Debug why a GitHub Actions job is failing"
    - "Inspect CI checks and workflows"
---

## CI Pipeline Overview

The CI runs on push to `main` and on all pull requests. Three independent jobs:

| Job | What It Checks | Fails When |
|-----|----------------|------------|
| `lint` | RuboCop, Zeitwerk, debug statements | Code style violations, autoload issues, `binding.pry` found |
| `typecheck` | Tapioca RBI freshness, Sorbet TC | Stale RBIs, type errors |
| `test` | RSpec full suite | Any test failure |

---

## Job Details

### Lint Job

```bash
# 1. RuboCop (parallel)
bundle exec rubocop --parallel

# 2. Zeitwerk autoload check
bin/rails zeitwerk:check

# 3. Debug statement detection (binding.pry)
git grep -l -e "binding\.pry" -- app lib config db spec
```

### Typecheck Job

```bash
# 1. RBI freshness (tapioca)
bundle exec tapioca check

# 2. Sorbet static type checking
bundle exec srb tc
```

### Test Job

Requires PostgreSQL 16 service container.

```bash
# 1. Prepare database
bin/rails db:prepare

# 2. Truncate test data (no seeds in test)
bin/rails runner 'if Rails.env.test?; ...'

# 3. Run RSpec
bundle exec rspec --format documentation
```

---

## Debugging CI Failures

### RuboCop Failures

```bash
# Run locally to see all violations
bundle exec rubocop --parallel

# Auto-fix what's possible
bundle exec rubocop -a
```

### Sorbet Failures

```bash
# Check for stale RBIs
bundle exec tapioca check

# Regenerate if stale
bundle exec tapioca dsl
bundle exec tapioca gems

# Run type check
bundle exec srb tc
```

### Debug Statement Detection

```bash
# Find all binding.pry statements
grep -rn "binding\.pry" app/ lib/ config/ db/ spec/
```

### Test Failures

```bash
# Run specific failing spec
bundle exec rspec spec/path/to_spec.rb:LINE

# Run with full output
bundle exec rspec --format documentation
```

---

## Local CI Simulation

Run all three checks locally before pushing:

```bash
bundle exec rubocop --parallel && \
bin/rails zeitwerk:check && \
bundle exec tapioca check && \
bundle exec srb tc && \
bundle exec rspec --format documentation
```

---

## Configuration Files

- `.github/workflows/ci.yml` - GitHub Actions workflow
- `.rubocop.yml` - RuboCop configuration
- `sorbet/config` - Sorbet configuration
