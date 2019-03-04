require 'active_support/concern'

module JupyterOnRails
  module Daru
    module ActiveRecordExt
      extend ::ActiveSupport::Concern

      class_methods do
        def to_df
          ::Daru::DataFrame.from_activerecord(all)
        end
      end
    end
  end
end
