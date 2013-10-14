module PgAudit::Audit

  extend ActiveSupport::Concern

  included do
    has_many :audit_updates, -> { where(:action => 'U').order("scope_version DESC") }, :class_name => "Audit::#{self}", :foreign_key => :id
  end

  def history
    LoggedAction.for_model(self.class).with_id(self.id)
  end

  module ClassMethods
    def columns_for_audit
      %w||
    end

    def columns_to_ignore_for_audit
       %w|created_at updated_at id|
    end

    #this allows migrations to run when an audited column is added/removed in a later migration
    def exsiting_columns_for_audit
      columns_for_audit & self.column_names
    end

    def audit_delete
      false
    end

    def audit_create
      false
    end

    #+++++++++

    def drop_audit_triggers
      self.connection.execute "DROP TRIGGER IF EXISTS #{self.table_name}_audit_update ON #{self.table_name}"
      self.connection.execute "DROP TRIGGER IF EXISTS #{self.table_name}_audit_update_selective ON #{self.table_name}"
      self.connection.execute "DROP TRIGGER IF EXISTS #{self.table_name}_audit_delete ON #{self.table_name}"
      self.connection.execute "DROP TRIGGER IF EXISTS #{self.table_name}_audit_insert ON #{self.table_name}"
    end

    def set_up_audit_triggers
      drop_audit_triggers
      if audit_delete
        self.connection.execute %|
          CREATE TRIGGER #{self.table_name}_audit_delete
          AFTER DELETE ON #{self.table_name} FOR EACH ROW
          EXECUTE PROCEDURE audit.if_modified_func();
        |
      end

      if audit_create
        self.connection.execute %|
          CREATE TRIGGER #{self.table_name}_audit_insert
          AFTER INSERT ON #{self.table_name} FOR EACH ROW
          EXECUTE PROCEDURE audit.if_modified_func();
        |
      end

      if exsiting_columns_for_audit.empty?
        self.connection.execute %|
          CREATE TRIGGER #{self.table_name}_audit_update
          AFTER UPDATE ON #{self.table_name} FOR EACH ROW
          EXECUTE PROCEDURE audit.if_modified_func('t', '{#{columns_to_ignore_for_audit.join(',')}}');
        |        
      else
        self.connection.execute %|
        CREATE TRIGGER #{self.table_name}_audit_update_selective
        AFTER UPDATE ON #{self.table_name} FOR EACH ROW
        WHEN ( (#{exsiting_columns_for_audit.map {|c| "OLD.#{c}"}.join(',')}) IS DISTINCT FROM (#{exsiting_columns_for_audit.map {|c| "NEW.#{c}"}.join(',')}) )
        EXECUTE PROCEDURE audit.if_modified_func('t', '{#{columns_to_ignore_for_audit.join(',')}}');
        |
      end

    end

    def reload_audit_triggers
      drop_audit_triggers
      set_up_audit_triggers
    end

    def drop_audit_view
      self.connection.execute %|
      DROP VIEW IF EXISTS audit_#{self.table_name};
      |
    end

    def set_up_audit_view
      self.connection.execute %|
      CREATE OR REPLACE VIEW audit_#{self.table_name} AS (
        (SELECT (populate_record(null::public.#{self.table_name}, logged_actions.row_data)).*, logged_actions.action, logged_actions.changed_fields, logged_actions.action_tstamp_tx as occurred_at
        FROM audit.logged_actions
        WHERE audit.logged_actions.action IN ('U','D') AND audit.logged_actions.table_name = '#{self.table_name}') 
        UNION (select *, 'P' as action, '' as changed_fields, updated_at as occurred_at from #{self.table_name})
      );
      |
      #P for present
    end

    def reload_audit_view
      drop_audit_view
      set_up_audit_view
    end

  end
end

