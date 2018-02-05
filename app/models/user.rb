# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :lockable, :registerable,
         :lockable, :recoverable, :rememberable, :trackable, :validatable

  # ActiveRecord associations
  belongs_to :rank

  belongs_to :home_airport,
             class_name:  'Airport',
             inverse_of:  :users,
             optional:    true

  # ActiveRecord callbacks
  before_validation :assign_rank, on: :create

  # ActiveRecord validations
  validates :pilot_id,
            presence:     true,
            allow_blank:  false,
            uniqueness:   true,
            numericality: { is_greater_than_or_equal_to: 1 },
            on:           :update

  validates :first_name, presence: true,   allow_blank: false
  validates :last_name,  presence: true,   allow_blank: false

  def first_name=(str)
    str.nil? ? super(str) : super(str.titleize)
  end

  def last_name=(str)
    str.nil? ? super(str) : super(str.titleize)
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  private

  def assign_rank
    return if rank.present?
    self.rank = Rank.find_by(flight_count: 0, automatic: true)
  end
end