module Commentable
  
  def has_attachments?
    has_attachments = false
    1.upto(3) { |i| 
      has_attachments = send("attachment#{i}?")
      break if has_attachments
    }
    has_attachments
  end

end
