module JupyterOnRails
  module Daru
    module DataFrameExt
      def write_model(model)
        require 'activerecord-import'

        objs = map_rows(&:to_h).map(&model.method(:new))
        model.import(objs)
      end
    end
  end
end
