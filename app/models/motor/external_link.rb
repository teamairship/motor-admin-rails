module Motor
  class ExternalLink < ::Motor::ApplicationRecord
    audited

    belongs_to :author, polymorphic: true, optional: true

    scope :active, -> { where(deleted_at: nil) }

    attribute :preferences, default: -> { ActiveSupport::HashWithIndifferentAccess.new }

    if Rails.version.to_f >= 7.1
      serialize :preferences, coder: HashSerializer
    else
      serialize :preferences, HashSerializer
    end

    def to_display_h
      { id: id,
        name: name,
        url: url,
        relative: relative,
        icon: preferences[:icon] || 'database',
        visible: preferences[:visible] }
    end
  end
end
