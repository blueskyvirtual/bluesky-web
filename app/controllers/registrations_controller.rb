# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha,
                        only: [:create],
                        if: proc {
                          Rails.configuration.x.google_recaptcha.enabled
                        }

  # Handle the after registration message. If there are no messages
  # to display, redirect to the root path. Otherwise display the welcome
  # message
  #
  def show
    redirect_to(root_path) && return if flash.empty?
    render 'devise/registrations/welcome'
  end

  protected

  def after_inactive_sign_up_path_for(_resource)
    welcome_path
  end

  private

  def check_captcha
    return if verify_recaptcha

    flash.now[:recaptcha_error] = 'Error validating reCAPTCHA'
    self.resource = resource_class.new sign_up_params
    respond_with_navigational(resource) { render :new }
  end

  # Notice the name of the method
  def sign_up_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
