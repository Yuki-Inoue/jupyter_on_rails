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
      require_relative 'iruby_kernel_extention'
      JupyterOnRails::IRubyKernelExtention.root = @root
      JupyterOnRails::IRubyKernelExtention.sandbox = @sandbox

      require 'iruby'
      IRuby::Kernel.instance_eval { prepend JupyterOnRails::IRubyKernelExtention }
    end
  end
end
