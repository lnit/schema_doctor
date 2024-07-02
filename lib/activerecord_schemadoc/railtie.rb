module ActiveRecordSchemadoc
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__), "tasks/schemadoc.rake")
    end
  end
end
