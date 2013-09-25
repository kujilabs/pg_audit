module PgAudit
  class Railtie < Rails::Railtie
    initializer 'foreigner.load_methods' do
      ActiveSupport.on_load :active_record do
		    if defined?(ActiveRecord::Migration::CommandRecorder)
		      ActiveRecord::Migration::CommandRecorder.class_eval do
		        include PgAudit::Migration::CommandRecorder
		      end
		    end        
      end
    end
  end
end