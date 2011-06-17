Breadcrumb.configure do
  # Specify name, link title and the URL to link to
  # crumb :profile, "Your Profile", :account_url
  # crumb :root, "Home", :root_url
  
  crumb :projects_status, nil, :projects_status_index_path
  
  crumb :methodology, nil, :methodology_index_path
  
  crumb :projects, '#{Project.model_name.human.pluralize.humanize}', :projects_path
  crumb :on_course_projects, nil, :projects_path
  crumb :project, '##{@project.req_nbr}', :project_path, :project
  crumb :new_project, nil, :new_project_path
  crumb :edit_project, nil, :edit_project_path, :project
  crumb :library, nil, :library_project_path, :project
  
  crumb :events, '#{Event.model_name.human.pluralize.humanize}', :project_events_path, :project
  crumb :event, '#{@event.to_s(:short)}', :event_path, :event
  crumb :new_event, nil, :new_project_event_path, :project
  crumb :edit_event, nil, :edit_event_path, :event
  
  crumb :event_comments, '#{Comment.model_name.human.pluralize.humanize}', :event_comments_path, :commentable
  crumb :new_event_comment, nil, :new_event_comment_path, :commentable
  
  crumb :documents, '#{Document.model_name.human.pluralize.humanize}', :event_documents_path, :event
  crumb :document, '#{@document.name}', :document_path, :document
  crumb :new_document, nil, :new_event_document_path, :event
  crumb :edit_document, nil, :edit_document_path, :document
  
  crumb :tasks, '#{Task.model_name.human.pluralize.humanize}', :project_tasks_path, :task => :project
  crumb :task, '#{truncate(@task.description, :length => 10)}', :task_path, :task
  crumb :new_task, nil, :new_project_task_path, :project
  crumb :edit_task, nil, :edit_task_path, :task
  
  crumb :task_comments, '#{Comment.model_name.human.pluralize.humanize}', :task_comments_path, :commentable
  crumb :new_task_comment, nil, :new_task_comment_path, :commentable
  
  crumb :comment, '#{truncate(@comment.content, :length => 10)}', :comment_path, :comment
  crumb :edit_comment, nil, :comment_path, :comment
  
  crumb :reports, nil, :reports_path
  crumb :new_report, nil, :new_report_path
  
  crumb :project_names, '#{ProjectName.model_name.human.pluralize.humanize}', :project_names_path
  crumb :project_name, '#{@project_name.text}', :project_name_path, :project_name
  crumb :new_project_name, nil, :new_project_name_path
  crumb :edit_project_name, nil, :edit_project_name_path, :project_name
  
  crumb :org_units, '#{OrgUnit.model_name.human.pluralize.humanize}', :org_units_path
  crumb :org_unit, '#{@org_unit.text}', :org_unit_path, :org_unit
  crumb :new_org_unit, nil, :new_org_unit_path
  crumb :edit_org_unit, nil, :edit_org_unit_path, :org_unit
  
  crumb :users, '#{User.model_name.human.pluralize.humanize}', :users_path
  crumb :user, '#{@user.username.upcase}', :user_path, :user
  crumb :new_user, nil, :new_user_path
  crumb :edit_user, nil, :edit_user_path, :user

  # Specify controller, action, and an array of the crumbs you specified above
  # trail :accounts, :show, [:root, :profile]
  # trail :home, :index, [:root]
  
  trail :projects_status, :index, [:projects, :projects_status]

  trail :methodology, :index, [:methodology]

  context "reports" do
    trail :reports, :index, [:projects, :reports]
    trail :reports, :new, [:projects, :reports, :new_report]
  end
  
  context "project names" do
    trail :project_names, :index, [:project_names]
    trail :project_names, :new, [:project_names, :new_project_name]
    trail :project_names, :show, [:project_names, :project_name]
    trail :project_names, :edit, [:project_names, :project_name, :edit_project_name]
  end
  
  context "users" do
    trail :users, :index, [:users]
    trail :users, :new, [:users, :new_user]
    trail :users, :show, [:users, :user]
    trail :users, :edit, [:users, :user, :edit_user]
  end
  
  context "org units" do
    trail :org_units, :index, [:org_units]
    trail :org_units, :new, [:org_units, :new_org_unit]
    trail :org_units, :show, [:org_units, :org_unit]
    trail :org_units, :edit, [:org_units, :org_unit, :edit_org_unit]
  end
  
  context "projects" do
    trail :projects, :index, [:on_course_projects]
    trail :projects, :new, [:projects, :new_project]
    trail :projects, :show, [:projects, :project]
    trail :projects, :edit, [:projects, :project, :edit_project]
    trail :projects, :library, [:projects, :project, :library]
  end
  
  context "events" do
    trail :events, :index, [:projects, :project, :events]
    trail :events, :new, [:projects, :project, :events, :new_event]
    trail :events, :show, [:projects, :project, :events, :event]
    trail :events, :edit, [:projects, :project, :events, :event, :edit_event]
  end
  
  context "events' comments" do
    trail :comments, :index, [:projects, :project, :events, :event, :event_comments], :if => lambda {|controller| controller.instance_variable_get(:@event)}
    trail :comments, :new, [:projects, :project, :events, :event, :event_comments, :new_event_comment], :if => lambda {|controller| controller.instance_variable_get(:@event)}
    trail :comments, :show, [:projects, :project, :events, :event, :event_comments, :comment], :if => lambda {|controller| controller.instance_variable_get(:@event)}
    trail :comments, :edit, [:projects, :project, :events, :event, :event_comments, :comment, :edit_comment], :if => lambda {|controller| controller.instance_variable_get(:@event)}
  end
  
  context "documents" do
    trail :documents, :index, [:projects, :project, :events, :event, :documents]
    trail :documents, :new, [:projects, :project, :events, :event, :documents, :new_document]
    trail :documents, :show, [:projects, :project, :events, :event, :documents, :document]
    trail :documents, :edit, [:projects, :project, :events, :event, :documents, :document, :edit_document]
  end
  
  context "tasks" do
    trail :tasks, :index, [:projects, :project, :tasks]
    trail :tasks, :new, [:projects, :project, :tasks, :new_task]
    trail :tasks, :show, [:projects, :project, :tasks, :task]
    trail :tasks, :edit, [:projects, :project, :tasks, :task, :edit_task]
  end
  
  context "tasks' comments" do
    trail :comments, :index, [:projects, :project, :tasks, :task, :task_comments], :if => lambda {|controller| controller.instance_variable_get(:@task)}
    trail :comments, :new, [:projects, :project, :tasks, :task, :task_comments, :new_task_comment], :if => lambda {|controller| controller.instance_variable_get(:@task)}
    trail :comments, :show, [:projects, :project, :tasks, :task, :task_comments, :comment], :if => lambda {|controller| controller.instance_variable_get(:@task)}
    trail :comments, :edit, [:projects, :project, :tasks, :task, :task_comments, :comment, :edit_comment], :if => lambda {|controller| controller.instance_variable_get(:@task)}
  end

  # Specify the delimiter for the crumbs
  delimit_with " > "
  
  dont_link_last_crumb
end
