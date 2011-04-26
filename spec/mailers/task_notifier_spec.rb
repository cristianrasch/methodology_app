require "spec_helper"

describe TaskNotifier do
  describe "task_saved" do
    let(:mail) { TaskNotifier.task_saved }

    it "renders the headers" do
      mail.subject.should eq("Task saved")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
