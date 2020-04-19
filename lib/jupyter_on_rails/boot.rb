# frozen_string_literal: true

root = ENV.fetch('RAILS_ROOT')

boot_file = File.expand_path('config/boot.rb', root)
require boot_file

require_relative 'iruby_kernel_extention'
JupyterOnRails::IRubyKernelExtention.root = root

require 'iruby'
module IRuby
  class Kernel
    prepend JupyterOnRails::IRubyKernelExtention
  end
end
