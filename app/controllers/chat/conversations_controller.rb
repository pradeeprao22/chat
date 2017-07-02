# frozen_string_literal: true

module Chat
  class ConversationsController < ApplicationController
    before_action Chat.logged_in_check
    before_action :set_conversation, only: :show

    def show
    end

    def create
      @conversation = Chat::Conversation.create(conversation_params)
    end

    private

    def set_conversation
      @conversation = Chat::Conversation.includes(
        :users, messages: :user
      ).find(params[:id])
    end

    def conversation_params
      chat_params = params.require(:conversation).permit(user_ids: [])
      if chat_params[:user_ids].reject!(&:blank?).present?
        chat_params[:user_ids] << current_user.id
        chat_params[:user_ids].map!(&:to_i)
      end

      chat_params
    end
  end
end
