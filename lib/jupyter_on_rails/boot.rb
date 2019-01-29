root = ENV.fetch('RAILS_ROOT')

boot_file = File.expand_path('config/boot.rb', root)
require boot_file

require_relative 'iruby_kernel_extention'
JupyterOnRails::IRubyKernelExtention.root = root

require 'iruby'
IRuby::Kernel.after_initialize do
  original = Dir.pwd
  Dir.chdir root
  app_file = File.expand_path('config/application.rb', root)
  require app_file
  Rails.application.require_environment!
  Dir.chdir original
end
