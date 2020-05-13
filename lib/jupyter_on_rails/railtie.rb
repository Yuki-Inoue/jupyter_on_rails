# frozen_string_literal: true

require_relative 'daru/active_record_ext'
require_relative 'daru/data_frame_ext'

module JupyterOnRails
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'jupyter_on_rails/railtie/jupyter.rake'
    end
  end
end
