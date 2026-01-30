---
name: forum
description: >
  Main entry point for Forum development - quick reference for all components.
  Trigger: General Forum development questions, project overview, component navigation.
license: MIT
metadata:
  author: forum
  version: "1.0"
  scope: [root]
  auto_invoke: "General Forum development questions"
---

## Components

| Component | Stack | Location |
|-----------|-------|----------|
| API | Ruby 3.3.5, Rails 8.0.2.1, PostgreSQL 16 | `app/` |
| Types | Sorbet, Tapioca | `sorbet/` |
| Tests | RSpec, FactoryBot, RSwag | `spec/` |
| CI/CD | GitHub Actions | `.github/workflows/` |
| Deploy | Kamal (Docker) | `.kamal/` |

## Architecture

```
Controller → DTO → Repository → Entity → JSON Response
                       ↓
                  Interactor (transactions)
                       ↓
                  Model (scopes only)
```

## Quick Commands

```bash
# Development
bundle install
bin/rails server
bin/rails console

# Database
bin/rails db:prepare
bin/rails db:migrate

# Testing
bundle exec rspec --format documentation

# Code Quality
bundle exec rubocop --parallel
bundle exec srb tc
bundle exec tapioca check

# Zeitwerk
bin/rails zeitwerk:check
```

## API Endpoints

All endpoints under `/api` scope:
- `GET /api/<resources>` - List (with optional filters)
- `GET /api/<resources>/:id` - Show
- `POST /api/<resources>` - Create
- `PATCH /api/<resources>/:id` - Update
- `DELETE /api/<resources>/:id` - Destroy
- `POST /api/<resources>/:rpc/(:id)` - Custom RPC operations

## Key Directories

```
app/
├── controllers/       # Thin controllers (AbstractBaseController)
├── dtos/              # Typed parameter objects (T::Struct)
├── entities/          # Immutable response objects (T::Struct)
├── events/            # Domain events
├── interactors/       # Business logic with transactions
├── jobs/              # Background jobs (Solid Queue)
├── mailers/           # Email delivery
├── models/            # ActiveRecord (scopes only)
└── repositories/      # Data access layer
```

## Related Skills

- `forum-api` - Layered architecture patterns
- `forum-test` - Testing conventions
- `forum-commit` - Commit conventions
- `forum-ci` - CI pipeline
- `ruby-sorbet` - Sorbet typing
- `rspec` - RSpec patterns
- `rails-8` - Rails 8 features
