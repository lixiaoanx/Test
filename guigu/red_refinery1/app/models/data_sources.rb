# frozen_string_literal: true

module DataSources
  %w[empty dictionary form redmine_user].each do |type|
    require_dependency "data_sources/#{type}"
  end
end
