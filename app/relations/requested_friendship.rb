class RequestedFriendship
  include Neo4j::ActiveRel

  before_save -> { self.weight = 1.0 }

  property :weight, type: Float

  from_class User
  to_class User

  type :requested_friendship
end