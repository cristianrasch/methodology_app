require "spec_helper"

describe ProjectNotifier do
  
  context "project_created" do
    let(:mail) do 
      @project = Factory(:project)
      ProjectNotifier.project_created(@project)
    end

    it "renders the headers" do
      mail.subject.should match(/project/i)
      mail.to.should include(@project.dev.email)
      mail.to.should include(@project.users.first.email)
      mail.from.should eq(["desarrollo@consejo.org.ar"])
    end

    it "renders the body" do
      mail.body.encoded.should match(/dado de alta/)
    end
  end

end
