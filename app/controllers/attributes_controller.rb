class AttributesController < ApplicationController
  autocomplete :attribute, :value

  def get_autocomplete_items(parameters)
    Attribute.query_as(:a).match("a<-[r]-()").where("TYPE(r) in ['where_was_born', 'tagged_by'] AND a.value =~ '#{ parameters[:term] }.*'").limit(10).pluck(:a)
  end
end
