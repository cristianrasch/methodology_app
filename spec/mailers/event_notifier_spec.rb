# coding: utf-8

require "spec_helper"

describe EventNotifier do
  
  context "event_saved" do
    before { @event = Factory(:event) }
    let(:mail) { EventNotifier.event_saved(@event) }

    it "renders the headers" do
      mail.to.should include(@event.project.users.first.email)
      mail.to.should include(@event.project.dev.email)
      mail.from.should eq([Conf.notifications_from])
    end
    
    it "should display a subject for new events" do
      mail.subject.should include("Nuevo #{Event.model_name.human}")
    end
    
    it "should display another one for existing events" do
      @event.touch
      mail.subject.should include("Edición de #{Event.model_name.human}")
    end

    it "renders the body" do
      mail.body.encoded.should include(Event.model_name.human)
    end
  end

end
