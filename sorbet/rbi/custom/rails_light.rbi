# typed: true

# Minimal reopenings to satisfy app type checking without conflicting with tapioca check.
module ActionController; end
class ActionController::API; end
module ActiveJob; end
class ActiveJob::Base; end

class ActionMailer::Base
  def self.default(arg = T.unsafe(nil)); end
  def self.layout(arg = T.unsafe(nil)); end
end

class ActiveRecord::Base
  def self.all; end
  def self.where(arg0 = T.unsafe(nil), arg1 = T.unsafe(nil)); end
  def self.find_by(arg0 = T.unsafe(nil)); end
  def self.scope(name, callable = T.unsafe(nil)); end

  def initialize(*args, **kwargs); end
  def save!; end
  def update!(attrs = T.unsafe(nil)); end
  def destroy!; end
end

class ApplicationRecord < ActiveRecord::Base
  def self.primary_abstract_class; end
end
