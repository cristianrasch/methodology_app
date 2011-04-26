# coding: utf-8

require "spec_helper"

describe CommentNotifier do
  
  context "comment_created" do
    before { @comment = Factory(:comment) }
    let(:mail) { CommentNotifier.comment_saved(@comment) }

    it "renders the headers" do
      mail.to.should include(@comment.users.first.email)
      mail.to.should include(@comment.commentable.project.dev.email)
      mail.from.should eq(["desarrollo@consejo.org.ar"])
    end
    
    it "should display a subject for new comments" do
      mail.subject.should eq("Nuevo #{Comment.model_name.human}")
    end
    
    it "should display another one for existing comments" do
      @comment.touch
      mail.subject.should eq("Edición de #{Comment.model_name.human}")
    end

    it "renders the body" do
      mail.body.encoded.should match(/#{Comment.model_name.human}/)
    end
  end

end
