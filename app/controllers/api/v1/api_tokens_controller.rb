module Api
  module V1
    class ApiTokensController < ApplicationController
      before_action :authenticate_user

      def revoke
        token = params[:token]
        if token.present?
          begin
            ApiTokenService.revoke_token(token)
            render json: { message: "Token revoked successfully" }, status: :ok
          rescue ActiveRecord::RecordNotFound => e
            render json: { error: e.message }, status: :not_found
          end
        else
          render json: { error: "Token not provided" }, status: :bad_request
        end
      end
    end
  end
end
