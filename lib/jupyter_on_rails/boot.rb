root = ENV.fetch('RAILS_ROOT')

APP_PATH = File.expand_path('../config/application', root)
boot_file = File.expand_path('config/boot.rb', root)
require boot_file

require_relative 'iruby_kernel_extention'

require 'iruby'
module IRuby
  class Kernel
    prepend JupyterOnRails::IRubyKernelExtention
  end
end
