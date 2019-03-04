require 'active_support/concern'

module JupyterOnRails
  module Daru
    module ActiveRecordExt
      extend ::ActiveSupport::Concern

      class_methods do
        def to_df
          relation = all
          loaded_associations =
            %i[includes_values preload_values eager_load_values]
            .map(&relation.method(:send))
            .reduce(&:union)

          datas = relation.flat_map do |record|
            ret = [record.attributes.symbolize_keys]
            loaded_associations.each do |assoc|
              ret = ret.flat_map do |attrs|
                record.send(assoc).map(&:attributes).flat_map do |assoc_attrs|
                  assoc_attrs.transform_keys { |key| "#{assoc}.#{key}".to_sym }
                  attrs.merge(assoc_attrs)
                end
              end
            end
            ret
          end

          ::Daru::DataFrame.from_activerecord(datas)
        end
      end
    end
  end
end
