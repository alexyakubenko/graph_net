class Attribute
  RELATIONS = {
      name: {
          title: 'Имя',
          weight: 1.0
      },
      date_of_birth: {
          title: 'Дата Рождения',
          weight: 1.2,
          type: :date
      },
      interest: {
          title: 'Интерес',
          multiple: true,
          weight: 3,
          autocomplete: true
      },
      home_city: {
          title: 'Родной город',
          weight: 2,
          autocomplete: true
      }
  }.with_indifferent_access

  include Neo4j::ActiveNode

  property :value

  def self.clear_free_nodes!
    Neo4j::Session.query("MATCH (a:Attribute) WHERE NOT (a)<-[]-(:User) DELETE a")
  end

  def self.find_or_create(value)
    find_by(value: value) || create(value: value)
  end
end
