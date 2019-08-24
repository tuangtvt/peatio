module Avro
  module ActiveRecord
    # TODO: Doc.
    module Extension
      extend ActiveSupport::Concern

      def avro_schema_name
        self.class.name.gsub(/::/, '_')
      end
    end
  end
end

class BigDecimal
  # Not sure about this one.
  def as_avro
    self.to_f
  end
end

ActiveSupport.on_load(:active_record) { ActiveRecord::Base.include Avro::ActiveRecord::Extension }
