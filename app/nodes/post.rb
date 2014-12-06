class Post
  include Neo4j::ActiveNode

  property :title
  property :body

  validates_presence_of :title, :body

  has_one :out, :creator, model_class: User, relation_class: PostedBy, type: :posted_by
end
