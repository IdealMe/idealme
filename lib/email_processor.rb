class EmailProcessor
  def self.process(email)
    token       = email.to.first[:token]
    token_parts = token.split('+')
    question    = Comment.find token_parts.last.to_i
    responder   = User.where(email: email.from).first
    course      = Course.where(slug: token_parts.first).first

    if responder == course.owner || responder.access_admin?
      reply = question.replies.build
      reply.content  = email.body
      reply.owner = responder
      reply.save!
    end
  end
end
