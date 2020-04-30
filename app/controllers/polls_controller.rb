class ApplicationController < ActionController::Base

    def vote
        option = self.options.find_by(id: vote_params[:option_id])

        return render :status => :not_found if option.blank?
        return render :status => :ok if option.vote!
    end

    def create
        poll = Poll.new(poll_description: poll_params[:poll_description])

        poll_params[:options].each do |option|
            poll.options.new(options_description: option)
        end

        return render :json => { poll_id: poll.id }, :status => :created if poll.save
        return render :json => poll.errors, :status => :unprocessable_entity
    end

    private

        def poll_params
            params.permit(:poll_description, options: [])
        end

        def vote_params
            params.permit(:option_id)
        end

end
