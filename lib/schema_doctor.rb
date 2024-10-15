# frozen_string_literal: true

require_relative "schema_doctor/version"
require_relative "schema_doctor/schema_file"
require_relative "schema_doctor/analyzer"
require_relative "schema_doctor/exporter"
require_relative "schema_doctor/utils"
require_relative "schema_doctor/railtie" if defined?(Rails::Railtie)

module SchemaDoctor
  class Error < StandardError; end
end
