# frozen_string_literal: true

class User::Status < ApplicationRecord
  # Audits
  audited

  # ActiveRecord associations
  has_many :users,
           class_name:  'User',
           foreign_key: :user_status_id,
           inverse_of:  :user_status,
           dependent:   :destroy

  # ActiveRecord validations
  validates :name,
            presence: true,
            allow_blank: false,
            uniqueness: { case_sensitive: false }

  def name=(str)
    str.nil? ? super(str) : super(str.titleize)
  end

  def to_s
    name
  end
end
