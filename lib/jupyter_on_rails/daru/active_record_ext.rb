require 'active_support/concern'

module JupyterOnRails
  module Daru
    module ActiveRecordExt
      extend ::ActiveSupport::Concern

      included do
        scope :to_df, -> { ::Daru::DataFrame.from_activerecord(self) }
      end
    end
  end
end
