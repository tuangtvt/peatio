module Avro
  module ActiveRecord
    # TODO: Doc.
    module Extension
      extend ActiveSupport::Concern

      def as_avro
        as_json
      end

      def avro_schema_name
        self.class.name.gsub(/::/, '_')
      end
    end
  end
end

ActiveSupport.on_load(:active_record) { ActiveRecord::Base.include Avro::ActiveRecord::Extension }
