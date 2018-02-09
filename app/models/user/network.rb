# frozen_string_literal: true

class User::Network < ApplicationRecord
  # Audit
  audited

  # ActiveRecord associations
  belongs_to :user
  belongs_to :network, class_name: '::Network', inverse_of: :user_networks

  # ActiveRecord validations
  validates :username, presence: true, allow_blank: false
  validates :user, uniqueness: { scope: :network }
end
