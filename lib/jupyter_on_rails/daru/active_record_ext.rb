require 'active_support/concern'

module JupyterOnRails
  module Daru
    module ActiveRecordExt
      extend ::ActiveSupport::Concern

      unless respond_to?(:class_methods)
        def self.class_methods(&class_methods_module_definition)
          mod = const_defined?(:ClassMethods, false) ?
                  const_get(:ClassMethods) :
                  const_set(:ClassMethods, Module.new)

          mod.module_eval(&class_methods_module_definition)
        end
      end

      class_methods do
        def to_df
          relation = all
          loaded_associations =
            %i[includes_values preload_values eager_load_values]
            .map(&relation.method(:send)).reduce(&:|)

          datas = relation.flat_map do |record|
            ret = [record.attributes.symbolize_keys]
            loaded_associations.each do |assoc|
              ret = ret.flat_map do |attrs|
                assocs = record.send(assoc)
                next [attrs] unless assocs.present?

                assocs = [assocs] unless assocs.is_a?(ActiveRecord::Associations::CollectionProxy)
                assocs.map(&:attributes).map do |assoc_attrs|
                  new_attrs = assoc_attrs.transform_keys do |key|
                    "#{assoc}.#{key}".to_sym
                  end
                  attrs.merge(new_attrs)
                end
              end
            end
            ret
          end

          ::Daru::DataFrame.new(datas)
        end
      end
    end
  end
end
