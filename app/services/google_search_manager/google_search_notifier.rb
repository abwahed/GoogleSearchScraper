# frozen_string_literal: true

module GoogleSearchManager
  class GoogleSearchNotifier < ApplicationService
    def initialize(keyword)
      @keyword = keyword
    end

    def call
      Turbo::StreamsChannel.broadcast_replace_to(
        [@keyword.user, :data_set],
        target: "data-container-#{@keyword.id}",
        partial: 'keywords/keyword',
        locals: { keyword: @keyword }
      )
    end
  end
end
