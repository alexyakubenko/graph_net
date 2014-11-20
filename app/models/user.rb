class User
  include Neo4j::ActiveNode

  authenticates_with_sorcery!

  property :email
  property :crypted_password
  property :salt

  validates_uniqueness_of :email, case_sensitive: false

  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
end
