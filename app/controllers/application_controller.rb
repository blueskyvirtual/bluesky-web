# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  before_action :authenticate_user!
  after_action :verify_authorized, unless: :devise_controller?

  protect_from_forgery with: :exception

  layout 'v1/application'

  # protected
  #
  # Path to redirect to after successful sign in
  # def after_sign_in_path_for(resource)
  #   home_path
  # end
end
