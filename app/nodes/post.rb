class Post
  include Neo4j::ActiveNode

  property :title
  property :body

  validates_presence_of :title, :body

  has_many :in, :liked_users, model_class: User, relation_class: LikeOf, type: :like_of

  has_one :out, :creator, model_class: User, relation_class: PostedBy, type: :posted_by

  def likes_count
    @likes_count ||= liked_users.count
  end

  def liked_by?(user)
    Neo4j::Session.query(
        "MATCH (u:User)-[r:like_of]->(p:Post) WHERE u.uuid = {u_id} AND p.uuid = {p_id} RETURN r",
        u_id: user.uuid,
        p_id: self.uuid
    ).first.present?
  end
end
