# frozen_string_literal: true

class RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

  def sign_up_params
    params.permit(:name, :surname, :nickname, :email, :password, :password_confirmation)
  end
end
