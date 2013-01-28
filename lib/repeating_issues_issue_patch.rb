require_dependency 'issue'

module RepeatingIssuesPlugin
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)
      
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        has_one :repeating_issue, :dependent => :destroy

        after_save :repeate_issue, :if => "self.closed? && self.repeating_issue.present?"
      end

    end
      
    module ClassMethods

    end
    
    module InstanceMethods
      def repeate_issue
        start_date = self.start_date
        case self.repeating_issue.periodicity
          when "weekly"
            start_date += 1.week
          when "monthly"
            start_date += 1.month
          when "yearly"
            start_date += 1.year
        end until start_date >= Date.today
        due_date = start_date + (self.due_date - self.start_date)
        case self.repeating_issue.operation
          when "reopen"
            self.status = IssueStatus.default
            self.start_date = start_date
            self.due_date = due_date
            self.save
          when "recreate"
            new_issue = self.copy
            new_issue.status = IssueStatus.default
            new_issue.start_date = start_date
            new_issue.due_date = due_date
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
