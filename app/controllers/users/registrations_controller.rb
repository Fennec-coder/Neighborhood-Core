# frozen_string_literal: true

class Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(:name, :surname, :nickname, :email, :password, :password_confirmation)
  end
end
