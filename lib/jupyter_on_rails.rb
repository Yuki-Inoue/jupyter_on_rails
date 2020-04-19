# frozen_string_literal: true

require 'jupyter_on_rails/version'

module JupyterOnRails
  class Error < StandardError; end
end

require 'jupyter_on_rails/railtie' if defined?(Rails)
