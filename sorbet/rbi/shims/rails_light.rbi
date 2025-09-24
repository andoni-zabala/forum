# typed: true

module ActionController; end
class ActionController::API; end

module ActionMailer; end
class ActionMailer::Base
  def self.default(arg = T.unsafe(nil)); end
  def self.layout(arg = T.unsafe(nil)); end
end

module ActiveJob; end
class ActiveJob::Base; end

module ActiveRecord; end
class ActiveRecord::Base
  # class-level query-ish methods used in this app
  def self.all; end
  def self.where(arg0 = T.unsafe(nil), arg1 = T.unsafe(nil)); end
  def self.find_by(arg0 = T.unsafe(nil)); end
  def self.scope(name, callable = T.unsafe(nil)); end

  # instance-level persistence methods used in this app
  def initialize(*args, **kwargs); end
  def save!; end
  def update!(attrs = T.unsafe(nil)); end
  def destroy!; end
end

# Minimal ApplicationRecord shim with primary_abstract_class
class ApplicationRecord < ActiveRecord::Base
  def self.primary_abstract_class; end
end
