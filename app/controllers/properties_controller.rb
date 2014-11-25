class PropertiesController < ApplicationController
  def destroy
  end

  def create
    attribute = Attribute.find_by(value: params[:value]) || Attribute.create(value: params[:value])
    r = current_user.create_rel(params[:type], attribute, weight: Attribute::RELATIONS[params[:type]][:weight])
    render json: { success: true }
  end
end