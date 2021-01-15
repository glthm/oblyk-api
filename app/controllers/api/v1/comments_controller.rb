# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApiController
      before_action :protected_by_session, only: %i[create update destroy]
      before_action :set_comment, only: %i[show update destroy]
      before_action :protected_by_owner, only: %i[update destroy]

      def index
        @comments = Comment.where(
          commentable_type: params[:commentable_type],
          commentable_id: params[:commentable_id]
        )
      end

      def show; end

      def create
        @comment = Comment.new(comment_params)
        @comment.user = @current_user
        if @comment.save
          render 'api/v1/comments/show'
        else
          render json: { error: @comment.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @comment.update(comment_params)
          render 'api/v1/comments/show'
        else
          render json: { error: @comment.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if @comment.delete
          render json: {}, status: :ok
        else
          render json: { error: @comment.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_comment
        @comment = Comment.find params[:id]
      end

      def comment_params
        params.require(:comment).permit(
          :commentable_type,
          :commentable_id,
          :body
        )
      end

      def protected_by_owner
        not_authorized if @current_user.id != @comment.user_id
      end
    end
  end
end
