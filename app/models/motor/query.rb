# frozen_string_literal: true

module Motor
  class Query < ::Motor::ApplicationRecord
    audited

    belongs_to :author, polymorphic: true, optional: true

    has_many :taggable_tags, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggable_tags, class_name: 'Motor::Tag'
    has_many :alerts, dependent: :destroy

    attribute :preferences, default: -> { ActiveSupport::HashWithIndifferentAccess.new }

    if Rails.version.to_f >= 7.1
      serialize :preferences, coder: HashSerializer
    else
      serialize :preferences, HashSerializer
    end

    scope :active, -> { where(deleted_at: nil) }

    before_create :assign_uuid_id

    def result(variables_hash = {})
      result = Motor::Queries::RunQuery.call!(self, variables_hash: variables_hash)
      column_names = result.columns.pluck(:name)

      result.data.map { |row| column_names.zip(row).to_h }
    end
    alias run result

    private

    def assign_uuid_id
      self.id ||= SecureRandom.uuid
    end
  end
end

ActiveSupport.run_load_hooks(:motor_query, Motor::Query)
