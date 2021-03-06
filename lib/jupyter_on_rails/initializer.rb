# frozen_string_literal: true

module JupyterOnRails
  module Initializer
    def self.run(root:, sandbox:)
      # Load Daru extensions
      begin
        require 'daru'
        require 'active_record'
      rescue LoadError
      else
        require 'jupyter_on_rails/daru/active_record_ext'
        require 'jupyter_on_rails/daru/data_frame_ext'

        ::ActiveRecord::Base.instance_eval do
          include ::JupyterOnRails::Daru::ActiveRecordExt
        end
        ::Daru::DataFrame.instance_eval do
          include ::JupyterOnRails::Daru::DataFrameExt
        end
      end

      original = Dir.pwd
      Dir.chdir root
      app_file = File.expand_path('config/environment.rb', root)
      require app_file
      Rails.application.require_environment!
      Dir.chdir original

      return unless sandbox

      ActiveRecord::Base.connection.begin_transaction(joinable: false)
      at_exit do
        ActiveRecord::Base.connection.rollback_transaction
      end
    end
  end
end
