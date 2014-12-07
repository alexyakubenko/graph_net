class Attribute
  RELATIONS = {
      has_name: {
          title: 'Имя',
          weight: 1.0
      },
      when_was_born: {
          title: 'Дата Рождения',
          weight: 1.2,
          type: :date
      },
      tagged_by: {
          title: 'Интерес',
          multiple: true,
          weight: 3,
          autocomplete: true
      },
      where_was_born: {
          title: 'Родной город',
          weight: 2,
          autocomplete: true
      }
  }.with_indifferent_access

  include Neo4j::ActiveNode

  property :value

  class << self
    def clear_free_nodes!
      Neo4j::Session.query("MATCH (a:Attribute) WHERE NOT (a)<-[]-(:User) DELETE a")
    end

    def find_or_create(value)
      find_by(value: value) || create(value: value)
    end
  end
end
