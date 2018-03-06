# frozen_string_literal: true

class ApplicationForm
  include ActiveModel::Conversion
  include ActiveModel::Naming
  include ActiveModel::Validations

  # Overrides <tt>ActiveModel::Naming#model_name</tt> to take <tt>resource_name</tt>
  # into account.
  #
  # @return [ActiveModel::Name]
  def self.model_name
    ActiveModel::Name.new(self, nil, resource_class.name)
  end

  # Sets or infers the resource name.
  #
  # @param resource [String] the name of the resource class
  # @return [String]
  # @example A class where the form object name does not match the resource:
  #   class SignupForm < ApplicationForm
  #     resource_class User
  #   end
  def self.resource_class(klass = nil)
    @resource_class ||= (klass || name.chomp('Form').constantize)
  end

  # The underlying model wrapped by the form.
  #
  # @return [Type<ApplicationRecord>]
  attr_accessor :resource
  private :resource=

  delegate :id, :persisted?, to: :resource

  def initialize(resource, attributes = {})
    self.resource = resource
    resource.assign_attributes(attributes)
  end
end
