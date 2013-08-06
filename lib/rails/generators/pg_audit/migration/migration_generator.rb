# encoding: utf-8

module PgAudit
  module Generators
    class MigrationGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      desc 'Creates a migration that will add the auditing table to the database'

      def self.source_root
        @_pg_audit_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def create_migration_file
        migration_template "pg_audit_migration.rb", "db/migrate/add_pg_audit.rb"
      end

      def self.next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def create_initializer_file
        copy_file "audit.sql", "db/raw_sql/pg_audit.sql"
      end
    end
  end
end

