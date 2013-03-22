require_dependency 'watchers_helper'

module RepeatingIssuesPlugin
  module WatchersHelperPatch
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :watcher_tag, :repeating_issues
      end
    end

    module InstanceMethods
      def watcher_tag_with_repeating_issues(object, user, options={})
        if (object.class == Issue)&&(user.allowed_to?({:controller => :repeating_issues, :action => :new}, nil, {:global => true}))
          [watcher_tag_without_repeating_issues(object, user, options),
          content_tag("span", :class => :repeating_issues) do
            if object.repeating_issue.present?
              link_to(t(:button_repeating_issues_edit), {:action => :edit, :controller => :repeating_issues, :id => object.repeating_issue.id}, {:class => "icon icon-duplicate"}) + "<br>".html_safe
            else
              link_to(t(:button_repeating_issues_new), {:action => :new, :controller => :repeating_issues, :repeating_issue => {:issue_id => object.id}}, {:class => "icon icon-duplicate"}) + "<br>".html_safe
            end
          end].join(" ").html_safe
        else
          watcher_tag_without_repeating_issues(object, user, options)
        end
      end
    end
  end
end
