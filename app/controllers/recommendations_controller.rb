class RecommendationsController < ApplicationController
  def index
    @recommendations = Neo4j::Session.query("MATCH (n) WHERE n._classname <> 'Attribute' AND n.uuid <> {my_id} RETURN n;", my_id: current_user.id)
  end
end
