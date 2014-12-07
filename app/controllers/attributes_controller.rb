class AttributesController < ApplicationController
  autocomplete :attribute, :value

  def get_autocomplete_items(parameters)
    Attribute.query_as(:a).match("a<-[r:interest]-(:User)").where("a.value =~ '#{ parameters[:term] }.*'").limit(10).pluck(:a)
  end
end
