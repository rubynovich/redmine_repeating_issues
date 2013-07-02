module RedmineRepeatingIssues
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_sidebar_planning_bottom,
              :partial => 'repeating_issues/sidebar'
  end
end 
