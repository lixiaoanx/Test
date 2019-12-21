# frozen_string_literal: true

module FormCore
  module LazyEvaluate
    extend ActiveSupport::Concern

    module ClassMethods
      def lazy_evaluate(attribute_name, script)
        before_validation do
          result = ScriptEngine.run_inline script, payload: serializable_hash

          if result.errors.any?
            result.errors.each do |error|
              errors.add(attribute_name, :invalid, message: error.message)
            end
          else
            write_attribute(attribute_name, result.output)
          end
        end
      end
    end
  end
end
