module PgAudit
  def self.load
    ActiveRecord::ConnectionAdapters.module_eval do
      include PgAudit::ConnectionAdapters::SchemaStatements
      include PgAudit::ConnectionAdapters::SchemaDefinitions
    end

    ActiveRecord::SchemaDumper.class_eval do
      include PgAudit::SchemaDumper
    end

    if defined?(ActiveRecord::Migration::CommandRecorder)
      ActiveRecord::Migration::CommandRecorder.class_eval do
        include PgAudit::Migration::CommandRecorder
      end
    end

    PgAudit::Adapter.load!
  end
end