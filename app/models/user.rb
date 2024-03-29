# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :organization_users, dependent: :destroy
  has_many :organizations, through: :organization_users

  def generate_jwt
    Warden::JWTAuth::UserEncoder
      .new
      .call(self, :user, nil)
      .first
  end

  def organization
    organizations.first
  end
end
