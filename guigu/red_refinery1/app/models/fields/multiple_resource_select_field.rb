# frozen_string_literal: true

module Fields
  class MultipleResourceSelectField < Field
    serialize :validations, Validations::MultipleResourceSelectField
    serialize :options, Options::MultipleResourceSelectField

    include Fields::MultipleResourceSelectField::Fake
    include Fields::MultipleResourceSelectField::Postgres
    include Fields::MultipleResourceSelectField::CustomQuery

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
        # return if accessibility != :read_and_write || !options.strict_select

        # TODO: performance
        # model.validates name, subset: {in: collection}, allow_blank: true
      end
  end
end
