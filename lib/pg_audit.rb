require 'active_support/all'
require 'active_record'
require 'activerecord-postgres-hstore'
require "pg_audit/version"
require "pg_audit/audit"
require "pg_audit/logged_action"
require "pg_audit/readonly"

module PgAudit 	
  # Your code goes here...
end

require 'pg_audit/railtie' if defined?(Rails)
