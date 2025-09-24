# typed: strict

require 'rails_helper'
require 'rswag/specs'

RSpec.configure do |config|
  # configure rswag-specs - prefer new names but support older accessor via gem
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {}
    }
  }

  config.openapi_format = :yaml
  # Don't execute requests when generating docs; only collect metadata
  config.rswag_dry_run = true
end
