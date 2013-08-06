class AddPgAudit < ActiveRecord::Migration
  def up
    sql = File.read(Rails.root.join("db/raw_sql/pg_audit.sql"))
    execute sql
  end

  def down
    execute "DROP SCHEMA audit CASCADE;"
  end
end
