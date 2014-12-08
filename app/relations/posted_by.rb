class PostedBy
  include Neo4j::ActiveRel

  property :weight, type: Float, default: 4.0

  from_class Post
  to_class User

  type :posted_by
end
