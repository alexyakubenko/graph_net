class SentMessageTo
  include Neo4j::ActiveRel

  before_create -> {
    self.weight = 0.5
    self.unread = true
    self.created_at_str = Time.now.strftime('%c')
  }

  property :weight, type: Float
  property :body
  property :unread
  property :created_at_str

  from_class User
  to_class User

  type :sent_message_to

  def created_at
    @created_at ||= Time.parse(self.created_at_str)
  end
end