require "spec_helper"

describe Notifications do
  
  context "notify devs who have not signed in since last week" do
    before { @dev = Factory(:user, :username => 'crr', :last_sign_in_at => 1.month.ago) }
    let(:mail) { Notifications.has_not_signed_in_since_last_week(@dev) }

    it "renders the headers" do
      mail.subject.should eq("#{@dev.username.upcase}: no se ha logueado en la última semana!")
      mail.to.should eq([@dev.email])
      mail.from.should eq([Conf.notifications_from])
    end

    it "renders the body" do
      mail.body.encoded.should match(new_user_session_url)
    end
  end

end
