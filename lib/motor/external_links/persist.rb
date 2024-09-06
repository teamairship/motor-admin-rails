module Motor
  module ExternalLinks
    module Persist
      ASSOCIATION_ATTRS = %w[icon visible].freeze

      module_function

      def create(external_link_params, current_user)
        link = Motor::ExternalLink.new(external_link_params)
        link.author ||= current_user

        ActiveRecord::Base.transaction do
          link.save!
          add_to_resources_order(link)
        end

        link
      end

      def add_to_resources_order(link)
        config = Motor::Config.find_by(key: 'resources.order')
        config.value << link.name unless config.value.include?(link.name)
        config.save!
      end

      def update(id, external_link_params, current_user)
        link = Motor::ExternalLink.find(id)
        link.assign_attributes(external_link_params.except(:preferences))
        link.author = current_user if current_user.present?

        existing_preferences = link.preferences || {}
        new_preferences ||= external_link_params[:preferences] || {}
        link.preferences = existing_preferences.merge(new_preferences)

        ActiveRecord::Base.transaction do
          link.save!
          update_resources_order(link)
        end

        link
      end

      def update_resources_order(link)
        return unless link.saved_change_to_name?

        config = Motor::Config.find_by(key: 'resources.order')

        order_idx = config.value.find_index(link.name_previously_was)
        return unless order_idx

        config.value[order_idx] = link.name
        config.save!
      end

      def destroy(id)
        link = Motor::ExternalLink.find(id)

        ActiveRecord::Base.transaction do
          link.destroy!
          remove_from_resources_order(link)
        end
      end

      def remove_from_resources_order(link)
        config = Motor::Config.find_by(key: 'resources.order')
        config.value.delete(link.name)
        config.save!
      end
    end
  end
end
