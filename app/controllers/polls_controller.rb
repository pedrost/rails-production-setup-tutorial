class PollsController < ApplicationController

  def index
    return render json: Poll.all, status: :ok
  end

  def show
    poll = Poll.find_by(id: params[:id])
    return render plain: "NOT FOUND", :status => :not_found if poll.blank?

    poll.viewed!

    return render :json => {
      poll_id: poll.id,
      poll_description: poll.poll_description,
      options: poll.options.map { |active_record_option|
        {
          option_id: active_record_option.id,
          option_description: active_record_option.option_description,
        }
      },
    }, :status => :ok
  end

  def create
    poll = Poll.new(poll_description: poll_params[:poll_description])

    poll_params[:options].each do |option|
      poll.options.new(option_description: option)
    end

    return render :json => { poll_id: poll.id }, :status => :created if poll.save
    return render :json => poll.errors, :status => :unprocessable_entity
  end

  def vote
    poll = Poll.find_by(id: params[:id])
    option = poll.options.find_by(id: vote_params[:option_id]) if poll.present?

    return render plain: "NOT FOUND", status: :not_found if option.blank?
    return render plain: "OK", status: :ok if option.vote!
  end

  def stats
    poll = Poll.find_by(id: params[:id])
    return render plain: "NOT FOUND", :status => :not_found if poll.blank?

    return render :json => {
      views: poll.views,
      options: poll.options.map { |active_record_option|
        {
          option_id: active_record_option.id,
          qty: active_record_option.voted_times,
        }
      },
    }, :status => :ok
  end

  private

  def poll_params
    params.permit(:poll_description, options: [])
  end

  def vote_params
    params.permit(:option_id)
  end
end
