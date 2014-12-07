class AppliedFriendship
  include Neo4j::ActiveRel

  property :weight, type: Float, default: 5.0

  from_class User
  to_class User

  type :applied_friendship
end
