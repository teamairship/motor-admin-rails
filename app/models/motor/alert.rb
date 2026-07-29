# frozen_string_literal: true

module Motor
  class Alert < ::Motor::ApplicationRecord
    audited

    belongs_to :query
    belongs_to :author, polymorphic: true, optional: true

    has_many :alert_locks, dependent: :destroy
    has_many :taggable_tags, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggable_tags, class_name: 'Motor::Tag'

    attribute :preferences, default: -> { ActiveSupport::HashWithIndifferentAccess.new }

    if Rails.version.to_f >= 7.1
      serialize :preferences, coder: HashSerializer
    else
      serialize :preferences, HashSerializer
    end

    scope :active, -> { where(deleted_at: nil) }
    scope :enabled, -> { where(is_enabled: true) }

    before_create :assign_uuid_id

    def cron
      @cron ||=
        Fugit::Nat.parse("#{preferences[:interval]} #{ActiveSupport::TimeZone::MAPPING[preferences[:timezone]]}")
    end

    private

    def assign_uuid_id
      self.id ||= SecureRandom.uuid
    end
  end
end
