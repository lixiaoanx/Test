# frozen_string_literal: true

class Transition < WorkflowCore::Transition
  serialize :options, NonConfigurable

  def internal?
    false
  end

  def auto_forwardable?
    false
  end

  def options_configurable?
    options.attributes.any? || options.class.reflections.any?
  end

  def self.type_key
    model_name.name.split("::").last.underscore
  end

  def type_key
    self.class.type_key
  end

  def tenant
    workflow.tenant
  end

  def append_to_graph(g, prev: nil, arc_label: "", nodes: {})
    key = "t_#{id}"
    unless nodes[key]
      nodes[key] = Graphviz::Node.new("t.#{id}#{": #{title}" if title.present?}", shape: "box")
      g << nodes[key]
    end
    current = nodes[key]

    prev.connect(current, label: arc_label) if prev && !prev.connected?(current)

    output_places.each do |succ|
      succ.append_to_graph(g, prev: current, nodes: nodes)
    end

    g
  end

  protected

    def auto_forward(next_token, transaction_options, **options)
      transition = next_token.place.output_transition
      return unless transition
      return unless transition.auto_forwardable?

      transition.on_fire(next_token, transaction_options, options)
    end
end

require_dependency "transitions"
