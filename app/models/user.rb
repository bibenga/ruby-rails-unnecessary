class User < ApplicationRecord
  # include Devise::JWT::RevocationStrategies::Null
  # include Devise::JWT::RevocationStrategies::Allowlist

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_many :comments, dependent: :destroy
  # has_many :sessions, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }
  validates :nikname, allow_nil: true, uniqueness: { case_sensitive: false }

  def active_for_authentication?
    super && active?
  end

  def on_jwt_dispatch(_token, _payload)
  end

  def update_tracked_fields(request)
    if request.headers["Authorization"]&.start_with?("Bearer ")
      return
    end
    super
  end
end
