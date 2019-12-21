# frozen_string_literal: true

module Transitions
  %w[
    sequence
    start end
    parallel_split synchronization
    exclusive_choice
  ].each do |type|
    require_dependency "transitions/#{type}"
  end

  %w[
    user_task assigning_assignees decision choice
    sync_to_redmine adding_observers
  ].each do |type|
    require_dependency "transitions/variants/#{type}"
  end
end
