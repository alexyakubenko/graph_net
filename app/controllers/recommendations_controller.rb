class RecommendationsController < ApplicationController
  def index
    @recommendations = Neo4j::Session.query("MATCH (n) WHERE n._classname <> 'Attribute' AND ID(n) <> {my_id} RETURN n;", my_id: current_user.id)
  end
end
