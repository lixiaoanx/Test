class AddRedmineIssueIdToWorkflowInstances < ActiveRecord::Migration[6.0]
  def change
    change_table :workflow_instances do |t|
      t.bigint :redmine_issue_id
    end
  end
end
