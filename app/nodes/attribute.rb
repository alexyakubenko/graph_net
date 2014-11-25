class Attribute
  RELATIONS = {
      name: {
          title: 'Имя',
          weight: 1.0
      },
      date_of_birth: {
          title: 'Дата Рождения',
          weight: 1.2
      },
      interest: {
          title: 'Интересуется',
          multiple: true,
          weight: 3
      },
      home_city: {
          title: 'Родной город',
          weight: 2
      }
  }.with_indifferent_access

  include Neo4j::ActiveNode

  property :value
end
