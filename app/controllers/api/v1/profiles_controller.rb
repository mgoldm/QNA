# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      authorize_resource class: User

      def index
        @users = User.all.where.not(id: current_resource_owner.id)
        render json: @users
      end

      def me
        render json: current_resource_owner
      end
    end
  end
end
