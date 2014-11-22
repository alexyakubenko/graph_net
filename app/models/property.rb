class Property
  RELATIONS = {
      name: {
          title: 'Имя'
      },
      date_of_birth: {
          title: 'Дата Рождения'
      },
      interest: {
          title: 'Интересы',
          multiple: true
      },
      city_of_birth: {
          title: 'Родной город'
      }
  }

  include Neo4j::ActiveNode

  property :name
end
