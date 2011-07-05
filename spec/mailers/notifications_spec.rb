require "spec_helper"

describe Notifications do
  context "notify devs who have not signed in since last week" do
    before { @dev = Factory(:user, :username => 'crr', :last_sign_in_at => 1.month.ago) }
    let(:mail) { Notifications.has_not_signed_in_since_last_week(@dev) }

    it "renders the headers" do
      mail.subject.should include("#{@dev.username.upcase}: no se ha logueado en la última semana!")
      mail.to.should eq([@dev.email])
      mail.from.should eq([Conf.notifications_from])
    end

    it "renders the body" do
      mail.body.encoded.should match(new_user_session_url)
    end
  end
  
  context "notify devs whose projects' compl_perc has not updated since last week" do
    before do 
      @dev = find_dev('crr')
      @project = Factory(:project, :status => Project::Status::IN_DEV, :started_on => 1.week.ago.to_date, :dev => @dev)
      @project.update_attribute(:last_compl_perc_update_at, 2.weeks.ago)
    end
    let(:mail) { Notifications.compl_perc_has_not_been_updated_since_last_week(@dev, [@project]) }

    it "renders the headers" do
      mail.subject.should include("#{@dev.username.upcase}: no ha actualizado el estado de sus #{Project.model_name.human.pluralize}!")
      mail.to.should eq([@dev.email])
      mail.from.should eq([Conf.notifications_from])
    end

    it "renders the body" do
      mail.body.encoded.should match(project_url(@project))
    end
  end
end
