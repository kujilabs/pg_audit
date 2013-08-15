module PgAudit
  module ConnectionAdapters    
    module SchemaDefinitions
      def self.included(base)
        base::Table.class_eval do
          include PgAudit::ConnectionAdapters::Table
        end

        base::TableDefinition.class_eval do
          include PgAudit::ConnectionAdapters::TableDefinition
        end
      end
    end
  end
end
