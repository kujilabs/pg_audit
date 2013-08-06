class PgAudit::LoggedAction < ActiveRecord::Base
  self.table_name = 'audit.logged_actions'
  self.primary_key = "event_id"
  serialize :changed_fields, ActiveRecord::Coders::Hstore
  serialize :row_data, ActiveRecord::Coders::Hstore

  scope :for_model, -> model { where(:table_name => model.table_name) }
  scope :with_id, -> id { 
    id = (id.respond_to?(:id) ? id.id : id)
    where("row_data @> 'id=>?'", id) 
  }
  scope :deletes,  -> { where(:action => "D") }
  scope :inserts,  -> { where(:action => "I") }
  scope :updates,  -> { where(:action => "U") }
end
