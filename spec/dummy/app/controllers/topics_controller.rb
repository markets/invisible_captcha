class TopicsController < ApplicationController
  invisible_captcha honeypot: :subtitle, only: :create
  invisible_captcha honeypot: :subtitle, only: :update, on_spam: :custom_callback

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(params[:topic])

    if @topic.valid?
      redirect_to new_topic_path
    else
      render action: 'new'
    end
  end

  def update
  end

  private

  def custom_callback
    redirect_to new_topic_path
  end
end
