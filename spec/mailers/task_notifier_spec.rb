# coding: utf-8

require "spec_helper"

describe TaskNotifier do
  
  context "task_saved" do
    before { @task = Factory(:task) }
    let(:mail) { TaskNotifier.task_saved(@task) }

    it "renders the headers" do
      mail.to.should include(@task.author.email)
      mail.to.should include(@task.owner.email)
      mail.to.should include(@task.project.dev.email)
      mail.from.should eq([Conf.notifications_from])
    end
    
    it "should display a subject for new tasks" do
      mail.subject.should include("Nueva #{Task.model_name.human}")
    end
    
    it "should display another one for existing tasks" do
      @task.touch
      mail.subject.should include("Edición de #{Task.model_name.human}")
    end

    it "renders the body" do
      mail.body.encoded.should include(Task.model_name.human)
    end
  end

end
