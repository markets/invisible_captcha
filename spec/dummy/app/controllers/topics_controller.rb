class TopicsController < ApplicationController
  invisible_captcha honeypot: :subtitle, only: :create

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(params[:topic])

    if @topic.valid?
      redirect_to new_topic_path, notice: 'OK!'
    else
      render action: 'new'
    end
  end
end
