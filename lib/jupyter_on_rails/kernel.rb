module JupyterOnRails
  module Kernel
    module_function def boot(sandbox: false)
      root = ENV.fetch('RAILS_ROOT')

      boot_file = File.expand_path('config/boot.rb', root)
      require boot_file

      require_relative 'iruby_kernel_extention'
      JupyterOnRails::IRubyKernelExtention.root = root
      JupyterOnRails::IRubyKernelExtention.sandbox = sandbox

      require 'iruby'

      IRuby::Kernel.instance_eval { prepend JupyterOnRails::IRubyKernelExtention }
    end
  end
end
