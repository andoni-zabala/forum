---
name: forum-api
description: >
  Layered architecture patterns for Forum API (Controller, DTO, Repository, Entity, Interactor).
  Trigger: When creating new resources, endpoints, controllers, DTOs, repositories, entities, or interactors.
license: MIT
metadata:
  author: forum
  version: "1.0"
  scope: [app]
  auto_invoke:
    - "Adding a new resource/endpoint"
    - "Creating controllers, DTOs, repositories, entities"
    - "Creating interactors for business logic"
---

## Critical Rules

- ALWAYS: Follow the layered pattern: Controller → DTO → Repository → Entity
- ALWAYS: Controllers inherit from `AbstractBaseController`
- ALWAYS: Repositories inherit from `AbstractBaseRepository`
- ALWAYS: Interactors inherit from `AbstractBaseInteractor`
- ALWAYS: DTOs and entities are `T::Struct` with `const` fields
- ALWAYS: Repositories return entities, never ActiveRecord objects
- ALWAYS: Models contain scopes only, no business logic
- NEVER: Put business logic in controllers or models
- NEVER: Return raw ActiveRecord from repositories

---

## Adding a New Resource (Step-by-Step)

### 1. Model

```ruby
# typed: strict
# app/models/post.rb

class Post < ApplicationRecord
  scope :by_community, ->(community_id) do
    return all if community_id.blank?
    where(community_id: community_id)
  end
end
```

### 2. Entity

```ruby
# typed: strict
# app/entities/post_entity.rb

class PostEntity < T::Struct
  extend T::Sig

  const :id, Integer
  const :title, String
  const :body, String
  const :community_id, Integer
end
```

### 3. DTOs

```ruby
# typed: strict
# app/dtos/posts/read_dto.rb

module Posts
  class ReadDto < T::Struct
    extend T::Sig

    const :community_id, T.nilable(Integer)
  end
end
```

```ruby
# typed: strict
# app/dtos/posts/create_dto.rb

module Posts
  class CreateDto < T::Struct
    extend T::Sig

    const :title, String
    const :body, String
    const :community_id, Integer
  end
end
```

```ruby
# typed: strict
# app/dtos/posts/update_dto.rb

module Posts
  class UpdateDto < T::Struct
    extend T::Sig

    const :id, Integer
    const :title, String
    const :body, String
  end
end
```

### 4. Repository

```ruby
# typed: strict
# app/repositories/posts_repository.rb

class PostsRepository < AbstractBaseRepository
  extend T::Sig

  Entity = type_member { { fixed: PostEntity } }

  sig { override.params(dto: Posts::ReadDto).returns(T::Array[Entity]) }
  def read(dto:)
    posts = Post.by_community(dto.community_id)
    posts.map { |post| to_entity(post: post) }
  end

  sig { override.params(dto: IdDto).returns(T.nilable(Entity)) }
  def find(dto:)
    post = Post.find_by(id: dto.id)
    to_entity(post: post) if post
  end

  sig { override.params(dto: Posts::CreateDto).returns(Entity) }
  def create(dto:)
    post = Post.create!(title: dto.title, body: dto.body, community_id: dto.community_id)
    to_entity(post: post)
  end

  sig { override.params(dto: Posts::UpdateDto).returns(T.nilable(Entity)) }
  def update(dto:)
    post = Post.find_by(id: dto.id)
    if post
      post.update!(title: dto.title, body: dto.body)
      to_entity(post: post)
    end
  end

  sig { override.params(dto: IdDto).returns(T.nilable(Entity)) }
  def destroy(dto:)
    post = Post.find_by(id: dto.id)
    if post
      post.destroy!
      to_entity(post: post)
    end
  end

  private

  sig { params(post: Post).returns(Entity) }
  def to_entity(post:)
    PostEntity.new(
      id: post.id,
      title: post.title,
      body: post.body,
      community_id: post.community_id
    )
  end
end
```

### 5. Controller

```ruby
# typed: false
# app/controllers/posts_controller.rb

class PostsController < AbstractBaseController
  extend T::Sig

  sig { override.void }
  def index = super

  sig { override.void }
  def show = super

  sig { override.void }
  def create = super

  sig { override.void }
  def update = super

  sig { override.void }
  def destroy = super

  private

  sig { override.returns(Posts::ReadDto) }
  def read_dto
    Posts::ReadDto.new(community_id: params[:community_id]&.to_i)
  end

  sig { override.returns(Posts::CreateDto) }
  def create_dto
    Posts::CreateDto.new(
      title: params[:title],
      body: params[:body],
      community_id: params[:community_id].to_i
    )
  end

  sig { override.returns(Posts::UpdateDto) }
  def update_dto
    Posts::UpdateDto.new(
      id: params[:id].to_i,
      title: params[:title],
      body: params[:body]
    )
  end

  sig { override.returns(PostsRepository) }
  def repository
    @repository ||= T.let(PostsRepository.new, T.nilable(PostsRepository))
  end
end
```

### 6. Routes

```ruby
# config/routes.rb
scope path: :api do
  resources :posts do
    collection do
      post "/:rpc/(:id)", to: "posts#rpc"
    end
  end
end
```

### 7. Interactor (when business logic needs transactions)

```ruby
# typed: true
# app/interactors/posts/create_interactor.rb

module Posts
  class CreateInteractor < AbstractBaseInteractor
    extend T::Sig

    Model = type_member { { fixed: Post } }

    sig { params(dto: Posts::CreateDto).void }
    def initialize(dto:)
      @dto = dto
    end

    private

    sig { override.returns(Model) }
    def execute
      Post.new(title: dto.title, body: dto.body, community_id: dto.community_id)
    end

    attr_reader :dto
  end
end
```

---

## Decision Trees

### Where does this logic go?

```
HTTP params → DTO (T::Struct)
Data access → Repository
Business logic with transactions → Interactor
Query scopes → Model
Response shape → Entity (T::Struct)
```

### When to use an Interactor?

```
Simple CRUD (create/update/destroy) → Repository directly
Needs transaction wrapping → Interactor
Multi-step business logic → Interactor
Side effects (events, notifications) → Interactor
```

---

## Naming Conventions

| Entity | Pattern | Example |
|--------|---------|---------|
| Controller | `<Resources>Controller` | `PostsController` |
| DTO (read) | `<Resources>::ReadDto` | `Posts::ReadDto` |
| DTO (create) | `<Resources>::CreateDto` | `Posts::CreateDto` |
| DTO (update) | `<Resources>::UpdateDto` | `Posts::UpdateDto` |
| Repository | `<Resources>Repository` | `PostsRepository` |
| Entity | `<Resource>Entity` | `PostEntity` |
| Interactor | `<Resources>::<Action>Interactor` | `Posts::CreateInteractor` |
| Model | `<Resource>` (singular) | `Post` |

---

## File Structure for a New Resource

```
app/
├── controllers/<resources>_controller.rb
├── dtos/<resources>/
│   ├── read_dto.rb
│   ├── create_dto.rb
│   └── update_dto.rb
├── entities/<resource>_entity.rb
├── interactors/<resources>/
│   └── create_interactor.rb
├── models/<resource>.rb
└── repositories/<resources>_repository.rb
```

---

## Commands

```bash
# Generate migration
bin/rails generate migration Create<Resources> field:type

# Run migration
bin/rails db:migrate

# Check autoloading
bin/rails zeitwerk:check

# Type check
bundle exec srb tc
```
