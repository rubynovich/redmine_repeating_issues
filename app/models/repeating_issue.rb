class RepeatingIssue < ActiveRecord::Base
  unloadable

  belongs_to :issue

  validates_presence_of :issue_id, :periodicity, :operation
  validates_uniqueness_of :issue_id

  @@periodicity_variants = ["daily", "weekly", "monthly", "yearly"]
  @@operation_variants   = ["reopen", "recreate"]

  cattr_accessor :periodicity_variants, :operation_variants
end
