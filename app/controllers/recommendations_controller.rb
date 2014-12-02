class RecommendationsController < ApplicationController
  def index
    @recommendations = Neo4j::Session.query(
        "MATCH n, i WHERE NOT (i)-[]-(n) AND i.uuid = {my_id} AND n <> i AND n._classname in ['User', 'Post'] RETURN n;",
        my_id: current_user.id
    )
  end
end
