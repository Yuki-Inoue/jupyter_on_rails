# frozen_string_literal: true

module JupyterOnRails
  module Initializer
    def self.run(root:, sandbox:)
      require 'active_support/lazy_load_hooks'

      ActiveSupport.on_load(:active_record) do
        # Load Daru extensions

        require 'daru'
      rescue LoadError
      else
        require 'jupyter_on_rails/daru/active_record_ext'
        require 'jupyter_on_rails/daru/data_frame_ext'

        include ::JupyterOnRails::Daru::ActiveRecordExt

        ::Daru::DataFrame.instance_eval do
          include ::JupyterOnRails::Daru::DataFrameExt
        end

        IRuby::Display::Registry.instance_eval do
          match do |obj|
            obj.is_a?(ActiveRecord::Relation) ||
              obj.is_a?(::Class) && obj < ActiveRecord::Base && !obj.abstract_class
          end
          priority 100
          format 'text/html' do |obj|
            n = 10
            puts "finding top #{n}"
            obj.limit(n).to_df.to_html
          end
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
