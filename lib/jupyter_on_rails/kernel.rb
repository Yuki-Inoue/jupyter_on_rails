# frozen_string_literal: true

module JupyterOnRails
  class Kernel
    def initialize(sandbox: false)
      @root = ENV.fetch('RAILS_ROOT')
      @sandbox = sandbox
    end

    def boot
      boot_rails
      load_extensions
    end

    private

    def boot_rails
      boot_file = File.expand_path('config/boot.rb', @root)
      require boot_file
    end

    def load_extensions
      require_relative 'initializer'

      require 'iruby'
      IRuby::Kernel.events.register(:initialized) do |_kernel|
        JupyterOnRails::Initializer.run(root: @root, sandbox: @sandbox)
      end
    end
  end
end
