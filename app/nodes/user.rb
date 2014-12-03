class User
  include Neo4j::ActiveNode
  extend Sorcery::Model

  authenticates_with_sorcery!

  property :email
  property :crypted_password
  property :salt

  #validates_uniqueness_of :email, case_sensitive: false

  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :email, presence: true

  def self.find_by_credentials(credentials)
    find_by(email: credentials.first) rescue nil
  end

  def friend_requests
    @friend_requests ||= self.rels(dir: :incoming, type: :friend_request)
  end

  def name
    @name ||= rels(dir: :outgoing, type: :name).first.try(:value)
  end

  def pretty_name
    name ? "#{ name }(#{ self.email })" : self.eamil
  end
end
