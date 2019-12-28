require 'shellwords'
require 'json'

namespace :jupyter do
  desc 'start jupyter notebook'
  task :notebook do
    root = Rails.root
    ipython_dir = ENV['JUPYTER_DATA_DIR'] || ENV['IPYTHONDIR'] || root / '.ipython'
    ipython_dir = File.absolute_path(ipython_dir.to_s)

    sh "bundle exec iruby register --force JUPYTER_DATA_DIR=#{Shellwords.shellescape(ipython_dir.to_s)}"

    sh "rm -rf #{Shellwords.shellescape(ipython_dir.to_s)}/kernels/rails"
    sh "cp -r #{Shellwords.shellescape(ipython_dir.to_s)}/kernels/ruby #{Shellwords.shellescape(ipython_dir.to_s)}/kernels/rails"

    kernel_file = File.expand_path('kernels/rails/kernel.json', ipython_dir.to_s)
    kernel_h = JSON.parse(File.read(kernel_file))
    kernel_h['argv'] << File.expand_path('../boot.rb', __dir__)
    kernel_h['display_name'] = "#{Rails.application.class.parent} (rails #{Rails.version})"
    kernel_h['env'] ||= {}
    kernel_h['env']['RAILS_ROOT'] = root.to_s

    File.write(kernel_file, JSON.dump(kernel_h))

    env = { 'JUPYTER_DATA_DIR' => ipython_dir.to_s }
    commands = %w[jupyter notebook]
    commands = %w[pipenv run] + commands if (root / 'Pipfile').exist?
    Process.exec(env, *commands)
  end
end
