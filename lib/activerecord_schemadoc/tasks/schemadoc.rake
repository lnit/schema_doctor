# frozen_string_literal: true

namespace :schemadoc do
  desc "Analyze schema and Export yml files"
  task analyze: :environment do
    ActiveRecordSchemadoc::Analyzer.new.analyze_schema
  end

  desc "Export schema documentation"
  task export: :environment do
    exporter = ActiveRecordSchemadoc::Exporter.new
    exporter.export_adoc
    exporter.convert_adoc_to_html
  end
end
