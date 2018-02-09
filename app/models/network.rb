# frozen_string_literal: true

class Network < ApplicationRecord
  # Audits
  audited

  # ActiveRecord associations
  has_many :user_networks,
           class_name: 'User::Network',
           inverse_of: :network,
           dependent:  :destroy

  has_many :users, through: :user_networks

  # ActiveRecord validations
  validates :name,
            presence: true,
            allow_blank: false,
            uniqueness: { case_sensitive: false }

  def to_s
    name
  end
end
