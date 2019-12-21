# frozen_string_literal: true

class Token
  class Payload < FieldOptions
    attribute :comment, type: :string
    attribute :action, type: :string
    attribute :decision, type: :string
  end
end
