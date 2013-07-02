require 'redmine_repeating_issues/hooks'

Redmine::Plugin.register :redmine_repeating_issues do
  name 'Repeating issues'
  author 'Roman Shipiev'
  description 'Creating repeating issues through their recreate or reopen (after closing original issue)'
  version '0.0.1'
  url 'https://bitbucket.org/rubynovich/redmine_repeating_issues'
  author_url 'http://roman.shipiev.me'

  project_module :repeating_issues do
    permission :manage_repeating_issues,  :repeating_issues => [:index, :edit, :update, :destroy, :new, :create]
  end
end

Rails.configuration.to_prepare do
  [:watchers_helper, :issue].each do |cl|
    require "repeating_issues_#{cl}_patch"
  end

  [
#    [WatchersHelper, RepeatingIssuesPlugin::WatchersHelperPatch],
    [Issue, RepeatingIssuesPlugin::IssuePatch]
  ].each do |cl, patch|
    cl.send(:include, patch) unless cl.included_modules.include? patch
  end
end
