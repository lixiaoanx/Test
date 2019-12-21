# frozen_string_literal: true

module Fields
  class MultipleResourceField < Field
    serialize :validations, Validations::MultipleResourceField
    serialize :options, Options::MultipleResourceField

    include Fields::MultipleResourceField::Fake
    include Fields::MultipleResourceField::Postgres
    include Fields::MultipleResourceField::CustomQuery

    def stored_type
      :string
    end

    def data_source
      options.data_source
    end

    def collection
      data_source.scoped_records
    end

    def attached_data_source?
      true
    end

    def array?
      true
    end

    protected

      def interpret_extra_to(model, accessibility, overrides = {})
        # return if accessibility != :read_and_write

        # TODO: performance
        # model.validates name, subset: {in: collection}, allow_blank: true
      end
  end
end
