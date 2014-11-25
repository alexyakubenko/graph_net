class UserToAttribute
  include Neo4j::ActiveRel

  from_class User
  to_class Attribute

  type 'user_has_property'

  property :type
  property :weight, default: 2.0
end