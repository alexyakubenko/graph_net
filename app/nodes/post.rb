class Post
  include Neo4j::ActiveNode

  property :title
  property :body

  validates_presence_of :title, :body

  has_many :in, :liked_users, model_class: User, relation_class: LikeOf, type: :like_of
  has_many :out, :tags, model_class: Attribute, relation: TaggedBy, type: :tagged_by

  has_one :out, :creator, model_class: User, relation_class: PostedBy, type: :posted_by

  after_save :apply_tags

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

  def tag_values
    @tag_values ||= tags.map(&:value)
  end

  def tag_values=(values)
    @tag_values = values
  end

  private

  def clear_tags!
    Neo4j::Session.query(
        "MATCH (:Attribute)<-[r]-(p:Post) WHERE TYPE(r) = 'tagged_by' AND p.uuid = {p_id} DELETE r;",
        p_id: self.uuid
    )
    Attribute.clear_free_nodes!
  end

  def apply_tags
    clear_tags!

    tag_values.reject(&:blank?).each do |tag_value|
      TaggedBy.create(from_node: self, to_node: Attribute.find_or_create(tag_value))
    end
  end
end
