class RepeatingIssuesController < ApplicationController
  unloadable

  before_filter :new_repeatind_issue, :only => [:new, :index, :create] 
  before_filter :find_repeating_issue, :only => [:edit, :update, :destroy]
  before_filter :require_repeating_issues_manager
  
  def index
    @repeating_issues = RepeatingIssue.all(:order => 'issues.project_id, issue_id', :include => 'issue')      
  end

  def new
  end
  
  def edit    
  end
  
  def update
    if @repeating_issue.update_attributes(params[:repeating_issue])
      flash[:notice] = l(:notice_successful_update)
      redirect_back_or_default :action => :index
    else
      render :action => :edit
    end
  end
  
  def create
    if @repeating_issue.present? && @repeating_issue.save
      flash[:notice] = l(:notice_successful_create)
      redirect_back_or_default :action => :index
    else
      render :action => :new
    end
  end
  
  def destroy
    if @repeating_issue.present? && @repeating_issue.destroy
      flash[:notice] = l(:notice_successful_delete)
    end
    redirect_back_or_default :action => :index
  end

  private
  
    def find_repeating_issue
      @repeating_issue = RepeatingIssue.find(params[:id])      
    end
    
    def new_repeatind_issue
      @repeating_issue = RepeatingIssue.new(params[:repeating_issue])
    end

    def require_repeating_issues_manager
      (render_403; return false) unless User.current.allowed_to?({:controller => :repeating_issues, :action => params[:action]}, nil, {:global => true})
    end
end
