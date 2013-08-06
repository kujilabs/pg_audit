# encoding: utf-8

module PgAudit
  module Generators
    class MigrationGenerator < Rails::Generators::Base
      desc 'Creates a migration that will add the auditing table to the database'

      def self.source_root
        @_pg_audit_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def create_initializer_file
        copy_file "audit.sql", "db/raw_sql/audit.sql"
      end
    end
  end
end

