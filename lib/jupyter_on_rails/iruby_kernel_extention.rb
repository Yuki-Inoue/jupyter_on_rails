module JupyterOnRails
  module IRubyKernelExtention
    class << self
      attr_accessor :root
    end

    def run
      original = Dir.pwd
      root = IRubyKernelExtention.root
      Dir.chdir root
      app_file = File.expand_path('config/environment.rb', root)
      require app_file
      Rails.application.require_environment!
      Dir.chdir original
      super
    end
  end
end
