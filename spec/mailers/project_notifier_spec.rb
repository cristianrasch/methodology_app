# coding: utf-8

require "spec_helper"

describe ProjectNotifier do
  
  context "project_saved" do
    before { @project = Factory(:project) }
    let(:mail) { ProjectNotifier.project_saved(@project) }

    it "renders the headers" do
      mail.to.should include(@project.users.first.email)
      mail.to.should include(@project.dev.email)
      mail.to.should include(@project.owner.email)
      mail.from.should eq([Conf.notifications_from])
    end
    
    it "should display a subject for new projects" do
      mail.subject.should include("Nuevo #{Project.model_name.human}")
    end
    
    it "should display another one for existing projects" do
      @project.touch
      mail.subject.should include("Edición de #{Project.model_name.human}")
    end

    it "renders the body" do
      mail.body.encoded.should include(Project.model_name.human)
    end
  end

end
