class AttributesController < ApplicationController
  include AttributesHelper

  def destroy
    relation = Neo4j::Relationship.load(params[:id])
    if relation && relation.start_node == current_user
      relation.del
      render json: { success: true, undefined_attribute_types_html: undefined_attribute_types_html }
    else
      render json: { success: false }
    end

  end

  def create
    attribute = Attribute.find_by(value: params[:value]) || Attribute.create(value: params[:value])
    relation = current_user.create_rel(params[:type], attribute, weight: Attribute::RELATIONS[params[:type]][:weight])

    if relation
      render json: {
          success: true,
          html: render_to_string(partial: 'users/attribute', locals: { attribute: relation }, formats: [:html]),
          undefined_attribute_types_html: undefined_attribute_types_html
      }
    else
      render json: { success: false }
    end
  end
end