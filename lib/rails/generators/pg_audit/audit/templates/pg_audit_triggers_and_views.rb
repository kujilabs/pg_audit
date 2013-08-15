class <%= migration_class_name %> < ActiveRecord::Migration
  def change
  	Rails.application.eager_load!		
    ActiveRecord::Base.descendants.map(&:name).each do |klass|
    	klass = klass.constantize rescue next
      klass.send(:reload_audit_triggers) if klass.respond_to?(:reload_audit_triggers) 
      klass.send(:reload_audit_view) if klass.respond_to?(:reload_audit_view) 
    end
  end

end

