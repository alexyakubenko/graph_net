class RequestedFriendship
  include Neo4j::ActiveRel

  property :weight, type: Float

  from_class User
  to_class User

  type :requested_friendship
end