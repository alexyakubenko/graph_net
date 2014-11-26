module AttributesHelper
  include ActionView::Helpers::FormOptionsHelper

  def undefined_attribute_types_html
    options_for_select(Attribute::RELATIONS.select do |k, v|
      if v[:multiple]
        true
      else
        current_user.query_as(:me).match("me-[r:#{ k }]->(p:Attribute)").limit(1).pluck(:r).blank?
      end
    end.map { |k, v| [v[:title], k] })
  end
end
