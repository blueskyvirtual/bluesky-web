# frozen_string_literal: true

class User < ApplicationRecord
  # Audits
  audited except: %i[home_airport_id sign_in_count]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :lockable, :registerable,
         :lockable, :recoverable, :rememberable, :trackable, :validatable

  # FriendlyID configuration
  extend FriendlyId
  friendly_id :pilot_id

  # Auto-increment PilotIDs
  auto_increment :pilot_id, initial: 'BLU001'

  # ActiveRecord associations
  belongs_to :home_airport,
             class_name: 'Airport',
             inverse_of: :users,
             optional:   true

  belongs_to :rank,   class_name: 'User::Rank', inverse_of: :users
  belongs_to :region, optional: true

  belongs_to :user_status, class_name: 'User::Status', inverse_of: :users

  has_many :user_networks,
           class_name: 'User::Network',
           inverse_of: :user,
           dependent: :destroy

  has_many :networks, through: :user_networks

  # ActiveRecord callbacks
  before_validation :assign_rank,   on: :create
  before_validation :assign_status, on: :create

  # ActiveRecord validations
  validates :pilot_id,
            presence:     true,
            allow_blank:  false,
            uniqueness:   true,
            on: :update

  validates :first_name, presence: true,   allow_blank: false
  validates :last_name,  presence: true,   allow_blank: false

  def first_name=(str)
    str.nil? ? super(str) : super(str.titleize)
  end

  def last_name=(str)
    str.nil? ? super(str) : super(str.titleize)
  end

  def region_display
    region.nil? ? 'Unspecified' : "#{region.name}, #{region.country.name}"
  end

  def to_display
    "#{rank} #{self} (#{pilot_id})"
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  private

  def assign_rank
    return if rank.present?
    self.rank = Rank.find_by(flight_count: 0, automatic: true)
  end

  def assign_status
    return if user_status.present?
    self.user_status = User::Status.find_by(name: 'Active')
  end
end
