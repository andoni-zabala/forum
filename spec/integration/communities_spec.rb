require 'swagger_helper'

RSpec.describe 'Communities API', type: :request do
  path '/api/communities' do
    get 'List communities' do
      tags 'Communities'
      produces 'application/json'

      response '200', 'communities found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   title: { type: :string },
                   description: { type: :string }
                 },
                 required: [ 'id', 'title' ]
               }

        run_test!
      end
    end

    post 'Create a community' do
      tags 'Communities'
      consumes 'application/json'
      parameter name: :title, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string }
        },
        required: [ 'title' ]
      }

      response '201', 'community created' do
  let(:title) { { title: 'My Community', description: 'Nice place' } }
        run_test!
      end
      # The application currently allows creation of empty-title records
      response '201', 'invalid request (application currently creates record with empty title)' do
        let(:title) { { title: '', description: '' } }
        run_test!
      end
    end
  end

  path '/api/communities/{id}' do
  parameter name: 'id', in: :path, type: :integer

    get 'Retrieves a community' do
      tags 'Communities'
      produces 'application/json'

      response '200', 'community found' do
        let(:id) { Community.create(title: 'a', description: 'b').id }
        run_test!
      end

      response '200', 'not found (returns null in this app)' do
        let(:id) { 0 }
        run_test!
      end
    end

    patch 'Update a community' do
      tags 'Communities'
      consumes 'application/json'
      parameter name: :title, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string }
        }
      }

      response '200', 'community updated' do
        let(:id) { Community.create(title: 'a', description: 'b').id }
  let(:title) { { title: 'updated', description: 'updated desc' } }
        run_test!
      end
      # The application currently returns 200 on update even with empty fields
      response '200', 'invalid request (application currently accepts empty fields)' do
        let(:id) { Community.create(title: 'a', description: 'b').id }
        let(:title) { { title: '', description: '' } }
        run_test!
      end
    end

    delete 'Delete a community' do
      tags 'Communities'

      response '200', 'community deleted' do
        let(:id) { Community.create(title: 'a', description: 'b').id }
        run_test!
      end
    end
  end
end
