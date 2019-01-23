module JupyterOnRails
  module IRubyKernelExtention
    class << self
      attr_accesstor :root
    end

    def run
      root = ::JupyterOnRails::IRubyKernelExtention.root
      app_file = File.expand_path('config/application.rb', root)
      require app_file
      Rails.application.require_environment!
      super
    end
  end
end
