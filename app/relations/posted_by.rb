class PostedBy
  include Neo4j::ActiveRel

  property :weight, type: Float

  from_class Post
  to_class User

  type :posted_by
end