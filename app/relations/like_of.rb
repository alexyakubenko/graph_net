class LikeOf
  include Neo4j::ActiveRel

  property :weight, type: Float

  from_class User
  to_class Post

  type :like_of
end
