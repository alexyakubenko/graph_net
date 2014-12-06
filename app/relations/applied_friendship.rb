class AppliedFriendship
  include Neo4j::ActiveRel

  property :weight, type: Float

  from_class User
  to_class User

  type :applied_friendship
end
