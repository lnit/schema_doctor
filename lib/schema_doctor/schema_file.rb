# frozen_string_literal: true

require "fileutils"

module SchemaDoctor
  class SchemaFile
    def load
      return unless Dir.exist?(schema_dir)

      # Load schema specification files and merge them into a single hash
      Dir.glob("#{schema_dir}/*").inject({}) do |hash, file|
        hash.merge(YAML.load_file(file, symbolize_names: true))
      end
    end

    def dump(specs)
      # Output specification files for each model
      FileUtils.mkdir_p(schema_dir)
      Utils.deep_stringify(specs).each do |name, spec|
        File.open("#{schema_dir}/#{name}.yml", "w") do |f|
          YAML.dump({name => spec}, f)
        end
      end
    end

    def delete
      FileUtils.rm_rf(schema_dir)
    end

    private

    def export_dir
      "docs/models" # TODO: Configurable
    end

    def schema_dir
      "#{export_dir}/specs" # TODO: Configurable
    end
  end
end
