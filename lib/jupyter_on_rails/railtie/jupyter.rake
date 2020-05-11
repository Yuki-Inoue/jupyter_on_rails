# frozen_string_literal: true

require 'shellwords'
require 'json'
require 'ostruct'

namespace :jupyter do
  desc 'start jupyter notebook'
  task :notebook do
    root = Rails.root
    ipython_dir = ENV['JUPYTER_DATA_DIR'] || ENV['IPYTHONDIR'] || root / '.ipython'
    ipython_dir = File.absolute_path(ipython_dir.to_s)

    sh "JUPYTER_DATA_DIR=#{Shellwords.shellescape(ipython_dir.to_s)} bundle exec iruby register --force"

    [
      OpenStruct.new(kernel_name: 'rails',         boot_file: '../boot.rb',         name_ext: ''),
      OpenStruct.new(kernel_name: 'rails-sandbox', boot_file: '../boot_sandbox.rb', name_ext: ', sandbox'),
    ].each do |cfg|
      sh "rm -rf #{Shellwords.shellescape(ipython_dir.to_s)}/kernels/#{cfg.kernel_name}"

      sh "cp -r #{Shellwords.shellescape(ipython_dir.to_s)}/kernels/ruby #{Shellwords.shellescape(ipython_dir.to_s)}/kernels/#{cfg.kernel_name}"

      kernel_file = File.expand_path("kernels/#{cfg.kernel_name}/kernel.json", ipython_dir.to_s)
      kernel_h = JSON.parse(File.read(kernel_file))
      kernel_h['argv'] << File.expand_path(cfg.boot_file, __dir__)
      kernel_h['display_name'] = "#{Rails.application.class.parent} (rails #{Rails.version}#{cfg.name_ext})"
      kernel_h['env'] ||= {}
      kernel_h['env']['RAILS_ROOT'] = root.to_s

      File.write(kernel_file, JSON.dump(kernel_h))
    end

    env = { 'JUPYTER_DATA_DIR' => ipython_dir.to_s }
    commands = %w[jupyter notebook]
    commands = %w[pipenv run] + commands if (root / 'Pipfile').exist?
    Process.exec(env, *commands)
  end
end
