# frozen_string_literal: true

require 'jupyter_on_rails/kernel'

JupyterOnRails::Kernel.new(sandbox: true).boot
