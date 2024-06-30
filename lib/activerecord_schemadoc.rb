# frozen_string_literal: true

require_relative "activerecord_schemadoc/version"

module ActiveRecordSchemadoc
  class Error < StandardError; end

  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "activerecord_schemadoc/tasks/schemadoc.rake"
    end
  end
end
