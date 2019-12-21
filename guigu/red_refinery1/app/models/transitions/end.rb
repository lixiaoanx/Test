# frozen_string_literal: true

class Transitions::End < Transition
  def on_fire(token, _transaction_options, **_options)
    instance = token.instance
    form = workflow.form
    virtual_model = form.to_virtual_model

    form_record = virtual_model.new instance.payload
    form.save_virtual_record!(form_record)

    token.completed!
    token.instance.completed!
  end

  def auto_forwardable?
    true
  end

  def options_configurable?
    false
  end

  def internal?
    true
  end
end
