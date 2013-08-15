# encoding: utf-8
require 'rails/generators/active_record'

module PgAudit
  module Generators
    class AuditGenerator < ActiveRecord::Generators::Base
      desc 'Create triggers for audited tables'

      def self.source_root
        @_pg_audit_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def create_migration_file
        migration_template "pg_audit_triggers_and_views.rb", "db/migrate/#{file_name}.rb"
      end
    end
  end
end

