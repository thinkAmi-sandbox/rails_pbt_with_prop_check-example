class OrdersController < ApplicationController
  def index
  end

  def create
    form = ::OrdersForm.new(create_params)
    if form.invalid?
      render json: {
        total: nil,
        message: form.errors.full_messages
      }
    else
      render json: {
        total: form.total,
        message: form.errors.full_messages
      }
    end
  end

  private def create_params
    params.permit(:quantity, :unit_price)
  end
end
