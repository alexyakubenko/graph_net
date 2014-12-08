class RequestedFriendship
  include Neo4j::ActiveRel

  property :weight, type: Float, default: 1.0

  from_class User
  to_class User

  type :requested_friendship
end
