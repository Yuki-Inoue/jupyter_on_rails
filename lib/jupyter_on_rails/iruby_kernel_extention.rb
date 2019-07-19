# frozen_string_literal: true

module JupyterOnRails
  module IRubyKernelExtention
    class << self
      attr_accessor :root, :sandbox
    end

    def run
      original = Dir.pwd
      root = IRubyKernelExtention.root
      Dir.chdir root
      app_file = File.expand_path('config/environment.rb', root)
      require app_file
      Rails.application.require_environment!
      Dir.chdir original

      if IRubyKernelExtention.sandbox
        ActiveRecord::Base.connection.begin_transaction(joinable: false)

        at_exit do
          ActiveRecord::Base.connection.rollback_transaction
        end
      end

      super
    end
  end
end
