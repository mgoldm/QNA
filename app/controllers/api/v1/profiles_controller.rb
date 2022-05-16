# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def index
        @users = User.all.where.not(id: current_resource_owner.id)
        render json: @users
      end

      def me
        render json: current_resource_owner
      end

      private

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) unless doorkeeper_token.nil?
      end
    end
  end
end
