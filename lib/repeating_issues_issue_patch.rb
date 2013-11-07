require_dependency 'issue'
require_dependency 'issue_status'

module RepeatingIssuesPlugin
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      base.class_eval do
        has_one :repeating_issue, dependent: :destroy

        after_save :repeate_issue, if: -> { self.closed? && self.repeating_issue.present? }
      end

    end

    module ClassMethods

    end

    module InstanceMethods
      def case_periodicity
        case self.repeating_issue.periodicity
          when "daily"
            1.day
          when "weekly"
            1.week
          when "monthly"
            1.month
          when "yearly"
            1.year
        end
      end

      def repeate_issue
        new_start_date = self.start_date
        new_start_date += case_periodicity
        new_start_date += case_periodicity until new_start_date > Date.today
        new_due_date = new_start_date + (self.due_date - self.start_date)
        case self.repeating_issue.operation
          when "reopen"
            self.status = IssueStatus.default
            self.start_date = new_start_date
            self.due_date = new_due_date
            self.save
          when "recreate"
            new_issue = self.copy({status: IssueStatus.default, start_date: new_start_date, due_date: new_due_date}, {subtasks: false})
#            new_issue.status = IssueStatus.default
#            new_issue.start_date = new_start_date
#            new_issue.due_date = new_due_date
            if new_issue.save
              rep_issue = self.repeating_issue
              rep_issue.issue = new_issue
              rep_issue.save
            end
        end
      end
    end
  end
end
