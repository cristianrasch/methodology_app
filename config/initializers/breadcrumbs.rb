Breadcrumb.configure do
  # Specify name, link title and the URL to link to
  # crumb :profile, "Your Profile", :account_url
  # crumb :root, "Home", :root_url
  
  crumb :projects, '#{Project.model_name.human.pluralize.humanize}', :projects_path
  crumb :project, '##{@project.req_nbr}', :project_path, :project
  
  crumb :events, '#{Event.model_name.human.pluralize.humanize}', :project_events_path, :event => :project
  crumb :event, '#{@event.to_s(:short)}', :event_path, :event
  
  crumb :event_comments, '#{Comment.model_name.human.pluralize.humanize}', :event_comments_path, :commentable
  
  crumb :documents, '#{Document.model_name.human.pluralize.humanize}', :event_documents_path, :event
  crumb :document, '#{@document.name}', :document_path, :document
  
  crumb :tasks, '#{Task.model_name.human.pluralize.humanize}', :project_tasks_path, :task => :project
  crumb :task, '#{truncate(@task.description, :length => 10)}', :task_path, :task
  
  crumb :task_comments, '#{Comment.model_name.human.pluralize.humanize}', :task_comments_path, :commentable
  
  crumb :comment, '#{truncate(@comment.content, :length => 10)}', :comment_path, :comment
  
  crumb :reports, nil, :reports_path
  
  crumb :project_names, '#{ProjectName.model_name.human.pluralize.humanize}', :project_names_path
  crumb :project_name, '#{@project_name.text}', :project_name_path, :project_name
  
  crumb :org_units, '#{OrgUnit.model_name.human.pluralize.humanize}', :org_units_path
  crumb :org_unit, '#{@org_unit.text}', :org_unit_path, :org_unit
  
  crumb :users, '#{User.model_name.human.pluralize.humanize}', :users_path
  crumb :user, '#{@user.username.upcase}', :user_path, :user

  # Specify controller, action, and an array of the crumbs you specified above
  # trail :accounts, :show, [:root, :profile]
  # trail :home, :index, [:root]
  
  trail :projects_status, :index, [:projects]

  context "reports" do
    trail :reports, :index, [:projects]
    trail :reports, :new, [:projects, :reports]
  end
  
  context "project names" do
    trail :project_names, [:new, :show], [:project_names]
    trail :project_names, :edit, [:project_names, :project_name]
  end
  
  context "users" do
    trail :users, [:new, :show], [:users]
    trail :users, :edit, [:users, :user]
  end
  
  context "projects" do
    trail :projects, [:new, :show], [:projects]
    trail :projects, [:edit, :library], [:projects, :project]
  end
  
  context "events" do
    trail :events, :index, [:projects, :project]
    trail :events, [:new, :show], [:projects, :project, :events]
    trail :events, :edit, [:projects, :project, :events, :event]
  end
  
  context "events' comments" do
    trail :comments, :index, [:projects, :project, :events, :event], :if => lambda {|controller| controller.instance_variable_get(:@event)}
    trail :comments, [:new, :show], [:projects, :project, :events, :event, :event_comments], :if => lambda {|controller| controller.instance_variable_get(:@event)}
    trail :comments, :edit, [:projects, :project, :events, :event, :event_comments, :comment], :if => lambda {|controller| controller.instance_variable_get(:@event)}
  end
  
  context "documents" do
    trail :documents, :index, [:projects, :project, :events, :event]
    trail :documents, [:new, :show], [:projects, :project, :events, :event, :documents]
    trail :documents, :edit, [:projects, :project, :events, :event, :documents, :document]
  end
  
  context "tasks" do
    trail :tasks, :index, [:projects, :project]
    trail :tasks, [:new, :show], [:projects, :project, :tasks]
    trail :tasks, :edit, [:projects, :project, :tasks, :task]
  end
  
  context "tasks' comments" do
    trail :comments, :index, [:projects, :project, :tasks, :task], :if => lambda {|controller| controller.instance_variable_get(:@task)}
    trail :comments, [:new, :show], [:projects, :project, :tasks, :task, :task_comments], :if => lambda {|controller| controller.instance_variable_get(:@task)}
    trail :comments, :edit, [:projects, :project, :tasks, :task, :task_comments, :comment], :if => lambda {|controller| controller.instance_variable_get(:@task)}
  end

  # Specify the delimiter for the crumbs
  delimit_with " > "
end
