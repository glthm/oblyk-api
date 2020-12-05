# frozen_string_literal: true

module Api
  module V1
    class WordsController < ApiController
      before_action :protected_by_super_admin, only: %i[destroy]
      before_action :protected_by_session, only: %i[create update]
      before_action :set_word, only: %i[show update destroy]

      def index
        @words = Word.all
      end

      def show; end

      def create
        @word = Word.new(word_params)
        @word.user = @current_user
        if @word.save
          render 'api/v1/words/show'
        else
          render json: { error: @word.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @word.update(word_params)
          render 'api/v1/words/show'
        else
          render json: { error: @word.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if @word.delete
          render json: {}, status: :ok
        else
          render json: { error: @word.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_word
        @word = Word.find params[:id]
      end

      def word_params
        params.require(:word).permit(
          :name,
          :definition
        )
      end
    end
  end
end
