require "spec_helper"

describe EventNotifier do
  describe "event_saved" do
    let(:mail) { EventNotifier.event_saved }

    it "renders the headers" do
      mail.subject.should eq("Event saved")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
