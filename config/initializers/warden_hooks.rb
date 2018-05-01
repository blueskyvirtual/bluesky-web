# frozen_string_literal: true

# Set a cookie on sign in to verify socket connections
#
Warden::Manager.after_set_user do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.encrypted["#{scope}.id"] = user.id
  auth.cookies.encrypted["#{scope}.expires_at"] = 30.minutes.from_now
end

# Invalidate cookies on sign out
#
Warden::Manager.before_logout do |_user, auth, opts|
  scope = opts[:scope]
  auth.cookies.encrypted["#{scope}.id"] = nil
  auth.cookies.encrypted["#{scope}.expires_at"] = nil
end
