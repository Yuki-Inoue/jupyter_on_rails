root = ENV.fetch('RAILS_ROOT')

boot_file = File.expand_path('config/boot.rb', root)
require boot_file

require_relative 'iruby_kernel_extention'
kernel_ext = JupyterOnRails::IRubyKernelExtention
kernel_ext.root = root

require 'iruby'
module IRuby
  class Kernel
    prepend kernel_ext
  end
end
