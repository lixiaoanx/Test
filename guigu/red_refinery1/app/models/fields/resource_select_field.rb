# frozen_string_literal: true

module Fields
  class ResourceSelectField < Field
    serialize :options, Options::ResourceSelectField
    serialize :validations, Validations::ResourceSelectField

    include Fields::ResourceSelectField::Fake
    include Fields::ResourceSelectField::Postgres
    include Fields::ResourceSelectField::CustomQuery

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

    protected

      def interpret_extra_to(model, accessibility, overrides = {})
        # return if accessibility != :read_and_write || !options.strict_select

        # TODO: performance
        # model.validates name, inclusion: {in: collection}, allow_blank: true
      end
  end
end
