require_relative 'daru/active_record_ext'
require_relative 'daru/data_frame_ext'

module JupyterOnRails
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'jupyter_on_rails/railtie/jupyter.rake'
    end

    config.before_configuration do
      if defined?(::Daru) && defined?(::ActiveRecord)
        class ::ActiveRecord::Base
          include ::JupyterOnRails::Daru::ActiveRecordExt
        end
        class ::Daru::DataFrame
          include ::JupyterOnRails::Daru::DataFrameExt
        end
      end
    end
  end
end
