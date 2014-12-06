class User
  include Neo4j::ActiveNode
  extend Sorcery::Model

  authenticates_with_sorcery!

  property :email
  property :crypted_password
  property :salt

  #validates_uniqueness_of :email, case_sensitive: false

  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :email, presence: true

  has_many :in, :posts, model_class: Post, relation_class: PostedBy

  def self.find_by_credentials(credentials)
    find_by(email: credentials.first) rescue nil
  end

  def friend_requests
    @friend_requests ||= self.rels(dir: :incoming, type: :friend_request)
  end

  def friend_suggestions
    @friend_suggestions ||= self.rels(dir: :outgoing, type: :friend_request)
  end

  def friends
    @friends ||= self.rels(type: :friend).map { |r| r.end_node == self ? r.start_node : r.end_node }
  end

  def name
    @name ||= rels(type: :name).first.try(:end_node).try(:value)
  end

  def any_name
    @any_name ||= name || self.email
  end

  def unread_messages
    @unread_messages ||= Neo4j::Session.query(
        "MATCH ()-[r:message]->(i) WHERE i.uuid = {i_id} AND r.unread = true RETURN r",
        i_id: self.uuid
    )
  end
end
