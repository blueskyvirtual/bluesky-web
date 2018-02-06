# frozen_string_literal: true

module ControllerMacros
  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      user = FactoryBot.create(:user)
      user.confirm!
      sign_in user
    end
  end
end
