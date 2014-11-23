class PropertiesController < ApplicationController
  def destroy
  end

  def create
    render json: { success: true }
  end
end