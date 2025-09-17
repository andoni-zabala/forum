# Forum API

A small, production-style Rails 8 JSON API demonstrating clean layering (Controllers → DTOs → Repositories → Entities), type-safety with Sorbet, request/repository specs with RSpec, and live API docs with RSwag.

## Tech stack

- Ruby 3.3.x, Rails 8
- PostgreSQL
- RSpec + FactoryBot + RSwag (OpenAPI) for tests/docs
- Sorbet + tapioca for static typing
- Solid Queue / Solid Cache / Solid Cable
- Puma web server

## Quick start

1. Prerequisites

- Ruby 3.3.x (rbenv or asdf recommended)
- PostgreSQL 14+
- Bundler: `gem install bundler`

2. Setup

```bash
bundle install
bin/rails db:setup   # creates, loads schema, and seeds
bin/rails s          # http://localhost:3000
```

3. API docs

- Open `http://localhost:3000/api-docs` for interactive Swagger UI.

## Development

Run the test suite:

```bash
bundle exec rspec
```

Linting & security:

```bash
bin/rubocop
```

Static typing (Sorbet):

```bash
bundle exec srb tc
# Update RBIs when needed
bundle exec tapioca gem
bundle exec tapioca dsl
```

## Architecture

- `app/controllers` implements thin controllers. `AbstractBaseController` handles common CRUD flow.
- `app/dtos` defines DTOs (input to repositories), e.g. `Communities::CreateDto`, `Communities::UpdateDto`.
- `app/repositories` encapsulates data access and returns `T::Struct` entities (pure data) from models.
- `app/entities` holds API-safe entities, decoupled from ActiveRecord models.
- `app/models` contains ActiveRecord models and scopes only.

This separation keeps controllers small, enables easier testability, and avoids leaking persistence concerns.
