module JupyterOnRails
  module Daru
    module DataFrameExt
      def write_model(model)
        if ActiveRecord.version >= Gem::Version.new('6.0.0.beta1')
          write_model_rails(model)
        else
          write_model_activerecord_import(model)
        end
      end

      private

      def write_model_activerecord_import(model)
        begin
          require 'activerecord-import'
        rescue LoadError
          raise 'write_model requires either Rails >= 6 or the activerecord-import gem'
        end

        records = map_rows(&:to_h).map(&model.method(:new))
        model.import(records)
      end

      def write_model_rails(model)
        model.insert_all(map_rows(&:to_h))
      end
    end
  end
end
