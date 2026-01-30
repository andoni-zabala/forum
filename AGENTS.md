# Repository Guidelines

## How to Use This Guide

- Start here for project-wide norms. Forum is a Rails 8 API with clean architecture.
- Use the skills table below for detailed patterns on-demand.
- Skills override this file when guidance conflicts.

## Available Skills

Use these skills for detailed patterns on-demand:

### Generic Skills (Any Project)
| Skill | Description | URL |
|-------|-------------|-----|
| `ruby-sorbet` | Sorbet typing, T::Struct, sig blocks | [SKILL.md](skills/ruby-sorbet/SKILL.md) |
| `rspec` | RSpec patterns, FactoryBot, request specs | [SKILL.md](skills/rspec/SKILL.md) |
| `rails-8` | Rails 8 API-only, Solid Queue/Cache/Cable | [SKILL.md](skills/rails-8/SKILL.md) |

### Forum-Specific Skills
| Skill | Description | URL |
|-------|-------------|-----|
| `forum` | Project overview, component navigation | [SKILL.md](skills/forum/SKILL.md) |
| `forum-api` | Layered architecture (Controller, DTO, Repository, Entity, Interactor) | [SKILL.md](skills/forum-api/SKILL.md) |
| `forum-test` | Testing conventions (RSpec + FactoryBot + RSwag) | [SKILL.md](skills/forum-test/SKILL.md) |
| `forum-ci` | CI checks and PR gates (GitHub Actions) | [SKILL.md](skills/forum-ci/SKILL.md) |
| `skill-creator` | Create new AI agent skills | [SKILL.md](skills/skill-creator/SKILL.md) |

### Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action | Skill |
|--------|-------|
| Adding a new resource/endpoint | `forum-api` |
| Creating controllers, DTOs, repositories, entities | `forum-api` |
| Creating interactors for business logic | `forum-api` |
| Creating new skills | `skill-creator` |
| Debug why a GitHub Actions job is failing | `forum-ci` |
| General Forum development questions | `forum` |
| Inspect CI checks and workflows | `forum-ci` |
| Writing RSpec tests | `rspec` |
| Writing Forum request or repository specs | `forum-test` |
| Writing Sorbet type signatures | `ruby-sorbet` |
| Working with Rails 8 features | `rails-8` |

---

## Project Overview

Forum is a Rails 8 JSON API demonstrating clean architecture with strong static typing.

| Component | Location | Tech Stack |
|-----------|----------|------------|
| API | `app/` | Ruby 3.3.5, Rails 8.0.2.1, PostgreSQL 16 |
| Types | `sorbet/` | Sorbet, Tapioca |
| Tests | `spec/` | RSpec, FactoryBot, RSwag |
| CI/CD | `.github/` | GitHub Actions |
| Deploy | `.kamal/` | Kamal (Docker) |

### Architecture Layers

```
Request → Controller → DTO → Repository → Entity → Response
                                ↓
                           Interactor (business logic, transactions)
                                ↓
                            Model (ActiveRecord, scopes only)
```

---

## Ruby Development

```bash
# Setup
bundle install

# Development
bin/rails server
bin/rails console

# Code quality
bundle exec rubocop --parallel
bundle exec srb tc
bundle exec tapioca check

# Testing
bundle exec rspec --format documentation

# Database
bin/rails db:prepare
bin/rails db:migrate
```

---

## CRITICAL RULES - NON-NEGOTIABLE

### Typing
- ALWAYS: Use Sorbet `sig` blocks for public methods
- ALWAYS: Use `T::Struct` for DTOs and entities (immutable `const` fields)
- ALWAYS: Keep `# typed: strict` on new files (except controllers at `# typed: false`)
- NEVER: Skip type annotations on repository or entity methods

### Architecture
- ALWAYS: Follow the layered pattern: Controller → DTO → Repository → Entity
- ALWAYS: Use interactors for business logic that requires transactions
- ALWAYS: Models contain scopes only, no business logic
- ALWAYS: Entities are immutable `T::Struct` objects, decoupled from ActiveRecord
- NEVER: Put business logic in controllers or models
- NEVER: Return ActiveRecord objects from repositories (return entities)

### Naming Conventions

| Entity | Pattern | Example |
|--------|---------|---------|
| Controller | `<Resource>Controller` | `CommunitiesController` |
| DTO (read) | `<Resource>::ReadDto` | `Communities::ReadDto` |
| DTO (create) | `<Resource>::CreateDto` | `Communities::CreateDto` |
| DTO (update) | `<Resource>::UpdateDto` | `Communities::UpdateDto` |
| DTO (id) | `IdDto` | `IdDto` |
| Repository | `<Resource>Repository` | `CommunitiesRepository` |
| Entity | `<Resource>Entity` | `CommunityEntity` |
| Interactor | `<Resource>::<Action>Interactor` | `Communities::CreateInteractor` |
| Model | `<Resource>` (singular) | `Community` |
| Factory | `:<resource>` (singular, snake_case) | `:community` |

---

## QA CHECKLIST

- [ ] `bundle exec rubocop --parallel` passes
- [ ] `bundle exec srb tc` passes
- [ ] `bundle exec rspec` passes
- [ ] No `binding.pry` in committed code
- [ ] Zeitwerk autoloading check passes (`bin/rails zeitwerk:check`)
- [ ] New files have appropriate `# typed:` sigil
- [ ] New resources follow the layered architecture pattern
- [ ] Entities are immutable T::Struct with `const` fields only
