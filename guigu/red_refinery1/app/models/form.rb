# frozen_string_literal: true

class Form < MetalForm
  has_many :custom_queries, foreign_key: "form_id", dependent: :destroy

  validates :title,
            presence: true
end
