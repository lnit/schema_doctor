# frozen_string_literal: true

require "asciidoctor"

module SchemaDoctor
  class Exporter
    attr_reader :schema_file

    def initialize
      @schema_file = SchemaFile.new
    end

    def export_adoc
      puts "== Loading model specifications..."
      specs = schema_file.load

      puts "== Exporting adoc file..."
      # TODO: Use template
      File.open(adoc_path, "w") do |f|
        f.puts <<~TEXT
          = Rails Model Specification
          :toc: left
          :toclevels: 1
          :toc-title: Table of Contents
          :linkattrs:
          :sectlinks:
          :sectanchors:

        TEXT

        specs.each_value do |model|
          f.puts <<~TEXT
            == #{model[:name]}
            * Table name: #{model[:table_name]}
            * Comment: #{model[:table_comment]}
            #{model[:extra_comment]}

            === Columns
            [cols="1,1,1,1,1,1,1,1,2"]
            |===
            |name|type|sql_type|default|null|limit|precision|scale|comment

          TEXT

          # Output columns schema
          model[:columns].each_value do |column|
            column[:column_comment] = column[:column_comment].to_s + column.delete(:extra_comment).to_s
            col_str = column.values.map do |v|
              escaped = v.to_s.gsub("|", "{vbar}") # "|" is table delimiter in asciidoc
              "|#{escaped}\n"
            end.join

            f.puts <<~TEXT
              #{col_str}
            TEXT
          end
          f.puts "|==="

          # Output indexes schema
          f.puts <<~TEXT

            === Indexes
          TEXT
          if model[:indexes].present?
            f.puts <<~TEXT
              [cols="2,2,1,1"]
              |===
              |name|columns|unique|using

            TEXT

            model[:indexes].each_value do |index|
              index_str = index.values.map do |v|
                escaped = v.to_s.gsub("|", "{vbar}") # "|" is table delimiter in asciidoc
                "|#{escaped}\n"
              end.join

              f.puts <<~TEXT
                #{index_str}
              TEXT
            end

            f.puts "|==="
          else
            f.puts <<~TEXT
              None

            TEXT
          end

          # Output associations schema
          f.puts <<~TEXT

            === Associations
          TEXT
          belongs = model[:associations][:belongs]
          if belongs.present?
            f.puts <<~TEXT
              [cols="1,1,1,1"]
              |===
              |macro|name|foreign_key|options

            TEXT

            belongs.each_value do |association|
              class_name = association.delete(:class_name).to_s
              polymorphic = association.delete(:polymorphic)
              # TODO: polymorphicのリンク先を特定できるようにする。今のところリンクを生成しないように。
              association[:name] = "link:#_#{class_name.downcase.gsub("::", "")}[#{association[:name]}]" unless polymorphic

              str = association.values.map do |v|
                escaped = v.to_s.gsub("|", "{vbar}")
                "|#{escaped}\n"
              end.join

              f.puts <<~TEXT
                #{str}
              TEXT
            end

            f.puts "|==="
          end

          has = model[:associations][:has]
          if has.present?
            f.puts <<~TEXT
              [cols="1,1,1"]
              |===
              |macro|name|options

            TEXT

            has.each_value do |association|
              class_name = association.delete(:class_name).to_s
              association[:name] = "link:#_#{class_name.gsub("::", "").downcase}[#{association[:name]}]"
              str = association.values.map do |v|
                escaped = v.to_s.gsub("|", "{vbar}")
                "|#{escaped}\n"
              end.join

              f.puts <<~TEXT
                #{str}
              TEXT
            end

            f.puts "|==="
          end

          if belongs.empty? & has.empty?
            f.puts <<~TEXT
              None

            TEXT
          end
        end
      end
      puts "Done! => #{adoc_path}"
    end

    def convert_adoc_to_html
      puts "== Converting to html..."
      Asciidoctor.convert_file adoc_path, to_file: html_path, standalone: true, safe: :server
      puts "Done! => #{html_path}"
    end

    private

    def export_dir
      "docs/models" # TODO: Configurable
    end

    def adoc_path
      "#{export_dir}/models.adoc" # TODO: Configurable
    end

    def html_path
      "#{export_dir}/index.html" # TODO: Configurable
    end
  end
end
