# frozen_string_literal: true

require_relative "activerecord_schemadoc/version"
require_relative "activerecord_schemadoc/schema_file"
require_relative "activerecord_schemadoc/analyzer"
require_relative "activerecord_schemadoc/exporter"

module ActiveRecordSchemadoc
  class Error < StandardError; end

  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "activerecord_schemadoc/tasks/schemadoc.rake"
    end
  end
end
