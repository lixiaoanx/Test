# frozen_string_literal: true

class RedmineRecord < ActiveRecord::Base
  self.abstract_class = true

  # IMPORTANT: Assume all Redmine relates model under `Redmine::` namespace
  def self.sti_name
    to_s[9..-1]
  end

  def self.find_sti_class(type_name)
    type_name = base_class.type_for_attribute(inheritance_column).cast(type_name)
    type_name = "Redmine::#{type_name}"

    subclass = begin
      if store_full_sti_class
        ActiveSupport::Dependencies.constantize(type_name)
      else
        compute_type(type_name)
      end
    rescue NameError
      raise SubclassNotFound,
            "The single-table inheritance mechanism failed to locate the subclass: '#{type_name}'. " \
              "This error is raised because the column '#{inheritance_column}' is reserved for storing the class in case of inheritance. " \
              "Please rename this column if you didn't intend it to be used for storing the inheritance class " \
              "or overwrite #{name}.inheritance_column to use another column for that information."
    end
    unless subclass == self || descendants.include?(subclass)
      raise SubclassNotFound, "Invalid single-table inheritance type: #{subclass.name} is not a subclass of #{name}"
    end
    subclass
  end

  def self.refresh_redmine_connections!
    connects_to database: Tenant.all.map { |t| ["tenant_#{t.id}", t.redmine_database_url] }.to_h
  end

  refresh_redmine_connections!
end
