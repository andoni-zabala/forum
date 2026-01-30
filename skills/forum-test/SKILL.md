---
name: forum-test
description: >
  Forum-specific testing conventions using RSpec, FactoryBot, and RSwag.
  Trigger: When writing request specs, repository specs, integration tests, or factories for Forum resources.
license: MIT
metadata:
  author: forum
  version: "1.0"
  scope: [spec]
  auto_invoke:
    - "Writing Forum request or repository specs"
---

## Critical Rules

- ALWAYS: Use FactoryBot for test data (`create`, `create_list`, `build`)
- ALWAYS: Request specs test full HTTP round-trips (no mocking)
- ALWAYS: Repository specs test data access with real database
- ALWAYS: Parse JSON responses with `JSON.parse(response.body)`
- ALWAYS: Test both success and not-found/edge cases
- NEVER: Mock ActiveRecord or repository internals in request specs
- NEVER: Use fixtures (use FactoryBot factories instead)

---

## Test Structure

```
spec/
├── factories/              # FactoryBot factories
│   └── <resources>.rb
├── requests/               # HTTP request specs (controller layer)
│   └── <resources>_controller_spec.rb
├── repositories/           # Repository unit specs
│   └── <resources>_repository_spec.rb
├── integration/            # RSwag/OpenAPI integration specs
│   └── <resources>_spec.rb
├── rails_helper.rb         # Rails test configuration
├── spec_helper.rb          # RSpec configuration
└── swagger_helper.rb       # RSwag configuration
```

---

## Factory Pattern

```ruby
# spec/factories/<resources>.rb
FactoryBot.define do
  factory :<resource> do
    sequence(:title) { |n| "<Resource> #{n}" }
    description { "A default description" }
  end
end
```

---

## Request Spec Pattern

```ruby
# spec/requests/<resources>_controller_spec.rb
require 'rails_helper'

RSpec.describe "<Resources>Controller", type: :request do
  describe "GET /api/<resources>" do
    it "lists all <resources>" do
      create_list(:<resource>, 3)
      get "/api/<resources>", as: :json

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(3)
    end

    it "filters by <field> when <field>[] is provided" do
      create(:<resource>, title: "Match One")
      create(:<resource>, title: "Match Two")
      create(:<resource>, title: "No Match")

      get "/api/<resources>", params: { titles: ["Match"] }

      expect(response).to have_http_status(:ok)
      titles = JSON.parse(response.body).map { |r| r["title"] }
      expect(titles).to match_array(["Match One", "Match Two"])
    end
  end

  describe "GET /api/<resources>/:id" do
    it "returns the <resource>" do
      record = create(:<resource>)
      get "/api/<resources>/#{record.id}", as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(record.id)
    end

    it "returns null body when not found" do
      get "/api/<resources>/0", as: :json

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq("null")
    end
  end

  describe "POST /api/<resources>" do
    it "creates a <resource> and returns 201" do
      expect {
        post "/api/<resources>",
             params: { title: "New", description: "Desc" },
             as: :json
      }.to change(<Model>, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq("New")
    end
  end

  describe "PATCH /api/<resources>/:id" do
    it "updates a <resource> and returns 200" do
      record = create(:<resource>, title: "Old")
      patch "/api/<resources>/#{record.id}",
            params: { title: "Updated", description: "Updated" },
            as: :json

      expect(response).to have_http_status(:ok)
      record.reload
      expect(record.title).to eq("Updated")
    end
  end

  describe "DELETE /api/<resources>/:id" do
    it "deletes a <resource> and returns the deleted entity" do
      record = create(:<resource>)
      expect {
        delete "/api/<resources>/#{record.id}", as: :json
      }.to change(<Model>, :count).by(-1)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(record.id)
    end
  end
end
```

---

## Repository Spec Pattern

```ruby
# spec/repositories/<resources>_repository_spec.rb
require 'rails_helper'

RSpec.describe <Resources>Repository, type: :model do
  subject(:repo) { described_class.new }

  describe "#read" do
    it "returns all entities when no filter provided" do
      record_one = create(:<resource>)
      record_two = create(:<resource>)

      dto = <Resources>::ReadDto.new(<filter_field>: nil)
      entities = repo.read(dto: dto)

      expect(entities.map(&:id)).to match_array([record_one.id, record_two.id])
      expect(entities).to all(be_a(<Resource>Entity))
    end
  end

  describe "#find" do
    it "returns entity when found" do
      record = create(:<resource>)
      dto = IdDto.new(id: record.id)
      entity = repo.find(dto: dto)

      expect(entity&.id).to eq(record.id)
      expect(entity).to be_a(<Resource>Entity)
    end

    it "returns nil when not found" do
      dto = IdDto.new(id: 0)
      expect(repo.find(dto: dto)).to be_nil
    end
  end

  describe "#create" do
    it "persists and returns entity" do
      dto = <Resources>::CreateDto.new(title: "New", description: "Desc")
      entity = repo.create(dto: dto)

      expect(entity).to be_a(<Resource>Entity)
      expect(<Model>.exists?(entity.id)).to be true
    end
  end

  describe "#update" do
    it "updates and returns entity when found" do
      record = create(:<resource>, title: "Old")
      dto = <Resources>::UpdateDto.new(id: record.id, title: "New", description: "New")
      entity = repo.update(dto: dto)

      expect(entity).to be_a(<Resource>Entity)
      record.reload
      expect(record.title).to eq("New")
    end

    it "returns nil when not found" do
      dto = <Resources>::UpdateDto.new(id: 0, title: "X", description: "Y")
      expect(repo.update(dto: dto)).to be_nil
    end
  end

  describe "#destroy" do
    it "destroys and returns entity when found" do
      record = create(:<resource>)
      dto = IdDto.new(id: record.id)
      entity = repo.destroy(dto: dto)

      expect(entity).to be_a(<Resource>Entity)
      expect(<Model>.exists?(record.id)).to be false
    end

    it "returns nil when not found" do
      dto = IdDto.new(id: 0)
      expect(repo.destroy(dto: dto)).to be_nil
    end
  end
end
```

---

## Commands

```bash
# Run all tests
bundle exec rspec

# Run with documentation format
bundle exec rspec --format documentation

# Run specific spec file
bundle exec rspec spec/requests/<resources>_controller_spec.rb

# Run specific test by line
bundle exec rspec spec/requests/<resources>_controller_spec.rb:10

# Generate Swagger docs
bundle exec rails rswag:specs:swaggerize
```
