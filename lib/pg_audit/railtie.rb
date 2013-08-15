module PgAudit
  class Railtie < Rails::Railtie
    initializer 'foreigner.load_adapter' do
      ActiveSupport.on_load :active_record do
        PgAudit.load
      end
    end
  end
end