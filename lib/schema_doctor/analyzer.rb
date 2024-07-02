# frozen_string_literal: true

require "active_record"

module SchemaDoctor
  class Analyzer
    attr_reader :schema_file

    def initialize
      @schema_file = SchemaFile.new
    end

    def analyze_schema
      existing_schema = schema_file.load

      puts "== Analyzing model schema..."
      new_schema = model_schema(existing_schema || {})

      puts "== Exporting Specification files..."
      schema_file.dump(new_schema)
    end

    def model_schema(schema = {})
      models.each do |model|
        next if model.table_name.blank?

        puts "Processing #{model.name}..."
        schema[model.name] =
          {
            name: model.name,
            table_name: model.table_name,
            table_comment: connection.table_comment(model.table_name),
            extra_comment: schema.dig(model.name, :extra_comment),
            columns: columns(model, schema.dig(model.name, :columns) || {}),
            indexes: indexes(model)
          }
      rescue ActiveRecord::TableNotSpecified
        nil
      end

      schema
    end

    private

    def connection
      @connection ||= ActiveRecord::Base.connection
    end

    def models
      return @models if @models

      Rails.application.eager_load! if defined?(Rails)
      @models = ActiveRecord::Base.descendants.sort_by!(&:name)
    end

    def columns(model, columns = {})
      model.columns.each do |column|
        columns[column.name] =
          {
            name: column.name,
            type: column.type,
            sql_type: column.sql_type,
            default: column.default,
            null: column.null,
            limit: column.limit,
            precision: column.precision,
            scale: column.scale,
            column_comment: column.comment,
            extra_comment: columns.dig(column.name, :extra_comment)
          }
      end
      columns
    end

    def indexes(model)
      connection.indexes(model.table_name).each_with_object({}) do |index, hash|
        hash[index.name] = {
          name: index.name,
          columns: index.columns,
          unique: index.unique,
          using: index.using
        }
      end
    end
  end
end
