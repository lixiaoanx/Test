# frozen_string_literal: true

class Token < WorkflowCore::Token
  include EnumAttributeLocalizable

  belongs_to :tenant
  belongs_to :project

  belongs_to :assignable, polymorphic: true, optional: true
  belongs_to :forwardable, polymorphic: true, optional: true
  belongs_to :processable, polymorphic: true, optional: true

  serialize :payload, Payload

  def readable?(member)
    return false if place.internal?
    assignable == member || assignable.in?(member.groups)
  end

  def title
    if payload.decision.present?
      I18n.t("decisions.#{payload.decision}")
    elsif place.title.present?
      place.title
    else
      output_transition = place.output_transition
      if output_transition.is_a? Transitions::Variants::AssigningAssignees
        output_transition = output_transition.output_places.first&.output_transition
      end
      output_transition&.title
    end
  end
end
