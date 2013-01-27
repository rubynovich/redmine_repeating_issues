class CreateRepeatingIssues < ActiveRecord::Migration
  def self.up
    create_table :repeating_issues do |t|
      t.column :issue_id, :integer
      t.column :periodicity, :string
      t.column :operation, :string
    end
  end

  def self.down
    drop_table :repeating_issues
  end
end
