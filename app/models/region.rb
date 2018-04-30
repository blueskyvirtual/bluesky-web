# frozen_string_literal: true

class Region < ApplicationRecord
  # Audits
  audited

  # FriendlyID configuration
  extend FriendlyId
  friendly_id :code

  # ActiveRecord callbacks
  before_destroy :ensure_no_users

  # ActiveRecord associations
  belongs_to :country
  has_many   :airports, dependent: :destroy
  has_many   :users,    dependent: :destroy

  # ActiveRecord validations
  validates :code,
            presence:     true,
            allow_blank:  false,
            uniqueness:   { case_sensitive: false }

  validates :local_code,
            presence:     true,
            allow_blank:  false,
            uniqueness:   { case_sentitive: false, scope: :code }

  validates :name, presence: true, allow_blank: false

  def to_s
    "#{name} (#{local_code})"
  end

  private

  def ensure_no_users
    return if users.empty?
    errors.add :users, 'are still dependent'
    throw :abort
  end
end
