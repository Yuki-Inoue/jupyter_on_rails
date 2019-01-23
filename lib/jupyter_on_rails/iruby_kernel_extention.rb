module JupyterOnRails
  module IRubyKernelExtention
    class << self
      attr_accessor :root
    end

    def run
      root = ::APP_PATH
      app_file = File.expand_path('config/application.rb', root)
      require app_file
      Rails.application.require_environment!
      super
    end
  end
end
