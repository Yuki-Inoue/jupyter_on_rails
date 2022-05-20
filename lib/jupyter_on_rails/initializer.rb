# frozen_string_literal: true

module JupyterOnRails
  class Initializer
    def self.run(**opts)
      new(**opts).run
    end

    def initialize(root:, sandbox:)
      @root = root
      @sandbox = sandbox
    end

    attr_reader :root, :sandbox

    def run
      setup_daru
      load_rails_environment
      setup_console_methods
      setup_sandbox_transaction if sandbox
    end

    def setup_daru
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
    end

    def load_rails_environment
      app_file = File.expand_path('config/environment.rb', root)
      Dir.chdir(root) do
        require app_file
      end
    end

    def setup_console_methods
      require 'rails/console/app'
      IRuby::Kernel
        .instance
        .instance_variable_get(:@backend)
        .instance_variable_get(:@main)
        .extend(Rails::ConsoleMethods)
    end

    def setup_sandbox_transaction
      ActiveRecord::Base.connection.begin_transaction(joinable: false)
      at_exit do
        ActiveRecord::Base.connection.rollback_transaction
      end
    end
  end
end
