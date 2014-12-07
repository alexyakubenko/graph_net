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

  has_many :in, :posts, model_class: Post, relation_class: PostedBy, type: :posted_by
  has_many :out, :liked_posts, model_class: Post, relation_class: LikeOf, type: :like_of

  has_many :in, :friend_requests, model_class: User, relation_class: RequestedFriendship, type: :requested_friendship
  has_many :out, :friend_suggestions, model_class: User, relation_class: RequestedFriendship, type: :requested_friendship

  has_many :both, :friends, model_class: User, relation_class: AppliedFriendship, type: :applied_friendship

  def self.find_by_credentials(credentials)
    find_by(email: credentials.first) rescue nil
  end

  def name
    @name ||= rels(type: :name).first.try(:end_node).try(:value)
  end

  def any_name
    @any_name ||= name || self.email
  end

  def unread_messages
    @unread_messages ||= Neo4j::Session.query(
        "MATCH ()-[r:sent_message_to]->(i) WHERE i.uuid = {i_id} AND r.unread = true RETURN r",
        i_id: self.uuid
    )
  end

  def read_messages_by!(user)
    Neo4j::Session.query(
        "MATCH (u)-[r:sent_message_to]->(i) WHERE i.uuid = {i_id} AND u.uuid = {u_id} AND r.unread = true SET r.unread = false",
        i_id: self.uuid,
        u_id: user.uuid
    )
  end

  def request_friendship!(user)
    RequestedFriendship.create(from_node: self, to_node: user)
  end

  def reject_friendship!(user)
    Neo4j::Session.query(
        "MATCH (i:User)-[r]-(u:User) WHERE TYPE(r) in ['applied_friendship', 'requested_friendship'] AND u.uuid = {u_id} AND i.uuid = {i_id} DELETE r;",
        u_id: user.uuid,
        i_id: self.uuid
    )
  end

  def apply_friendship!(user)
    friendship_request = rels(dir: :incoming, type: :requested_friendship, between: user).first

    if friendship_request
      friendship_request.destroy
      AppliedFriendship.create(from_node: self, to_node: user, weight: 5.0)
    else
      false
    end
  end

  def requested_friendship_by?(user)
    rels(dir: :incoming, between: user, type: :requested_friendship).any?
  end

  def friend?(user)
    rels(type: :applied_friendship, between: user).any?
  end

  def suggested_friendship_for?(user)
    rels(dir: :outgoing, between: user, type: :requested_friendship).any?
  end

  def send_message!(message_body, recipient)
    SentMessageTo.create(from_node: self, to_node: recipient, body: message_body)
  end

  def profile_attributes(include_blank = false)
    profile_attrs = {}

    Attribute::RELATIONS.each do |k, v|
      rels = rels(dir: :outgoing, type: k).to_a
      if rels.any?
        profile_attrs[k] = rels.map { |r| r.end_node.value }
        profile_attrs[k] = profile_attrs[k].first unless Attribute::RELATIONS[k][:multiple]
      else
        profile_attrs[k] = nil if include_blank
      end
    end

    profile_attrs
  end

  def profile_attributes=(attributes)
    clear_profile_attributes!
    create_profile_attributes!(attributes)
  end

  private

  def create_profile_attributes!(attributes)
    attributes.each do |k, v|
      create_profile_attribute!(k, v)
    end
  end

  def create_profile_attribute!(k, v)
    if v.is_a? Array
      raise Exception.new("Only 1 value allowed for #{k }") unless Attribute::RELATIONS[k][:multiple]
      v.each do |value|
        create_profile_attribute!(k, value)
      end
    else
      create_rel(k, Attribute.find_or_create(v), weight: Attribute::RELATIONS[k][:weight]) if v.present?
    end
  end

  def clear_profile_attributes!
    Neo4j::Session.query(
        "MATCH (:Attribute)<-[r]-(i:User) WHERE TYPE(r) in {attribute_relation_types} AND i.uuid = {i_id} DELETE r;",
        i_id: self.uuid,
        attribute_relation_types: Attribute::RELATIONS.keys
    )
    Attribute.clear_free_nodes!
  end
end
