class LikeOf
  include Neo4j::ActiveRel

  before_save -> { self.weight = 3.0 }

  property :weight, type: Float

  from_class User
  to_class Post

  type :like_of
end
