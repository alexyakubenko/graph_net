class PropertyOfUserRelation
  include Neo4j::ActiveRel

  from_class User

  to_class Property

  property :weight, default: 2.0
end