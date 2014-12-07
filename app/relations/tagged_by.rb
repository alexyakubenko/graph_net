class TaggedBy
  include Neo4j::ActiveRel

  property :weight, type: Float, default: 3.0

  from_class Post
  to_class Attribute

  type :tagged_by
end
