# frozen_string_literal: true

require_relative "activerecord_schemadoc/version"
require_relative "activerecord_schemadoc/schema_file"
require_relative "activerecord_schemadoc/analyzer"
require_relative "activerecord_schemadoc/exporter"
require_relative "activerecord_schemadoc/railtie"

module ActiveRecordSchemadoc
  class Error < StandardError; end
end
