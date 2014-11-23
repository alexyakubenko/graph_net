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
      home_city: {
          title: 'Родной город'
      }
  }

  include Neo4j::ActiveNode

  property :name
end
