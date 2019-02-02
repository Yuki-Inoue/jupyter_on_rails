require 'active_support/concern'

module JupyterOnRails
  module Daru
    module ActiveRecordExt
      extend ::ActiveSupport::Concern

      included do
        scope :to_df, -> {
          df = ::Daru::DataFrame.from_activerecord(self)
          df.set_index(primary_key.intern)
        }
      end
    end
  end
end
