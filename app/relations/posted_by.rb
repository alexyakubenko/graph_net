class PostedBy
  include Neo4j::ActiveRel

  before_save -> { self.weight = 4.0 }

  property :weight, type: Float

  from_class Post
  to_class User

  type :posted_by
end
