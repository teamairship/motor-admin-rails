module Motor
  class ExternalLinksController < ApiBaseController
    wrap_parameters :data, except: %i[include fields]
    load_and_authorize_resource

    def index
      render json: { data: Motor::ApiQuery::BuildJson.call(@external_links, params, current_ability) }
    end

    def create
      link = Motor::ExternalLinks::Persist.create(external_link_params, current_user)

      render json: link.to_display_h
    end

    def update
      link = Motor::ExternalLinks::Persist.update(params[:id], external_link_params, current_user)

      render json: link.to_display_h
    end

    def destroy
      Motor::ExternalLinks::Persist.destroy(params[:id])

      head :no_content
    end

    private

    def external_link_params
      params.require(:data).permit(:name, :url, :relative, preferences: [:icon, :visible])
    end
  end
end
