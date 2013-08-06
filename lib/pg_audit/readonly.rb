module PgAudit::Readonly

  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods

    # Set up these methods to customize the audit columns
    def read_only_columns
      %w||
    end

    def exsiting_read_only_columns
      read_only_columns & self.column_names
    end

    #+++++++++

    def drop_readonly_trigger
      self.connection.execute "DROP TRIGGER IF EXISTS #{self.table_name}_readonly_columns ON #{self.table_name}"
    end

    def set_up_readonly_triggers
      drop_readonly_trigger
      self.connection.execute %|
        CREATE TRIGGER #{self.table_name}_readonly_columns
        BEFORE UPDATE ON #{self.table_name} FOR EACH ROW
        WHEN ( (#{exsiting_read_only_columns.map {|c| "OLD.#{c}"}.join(',')}) IS DISTINCT FROM (#{exsiting_read_only_columns.map {|c| "NEW.#{c}"}.join(',')}) )
        EXECUTE PROCEDURE msgfailerror('#{exsiting_read_only_columns.join(',')} are read only in #{self.table_name}');
        |
    end

    def reload_readonly_triggers
      drop_readonly_trigger
      set_up_readonly_triggers
    end

  end

end
