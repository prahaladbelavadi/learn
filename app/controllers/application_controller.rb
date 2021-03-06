class ApplicationController < ActionController::Base
	include ApplicationHelper
	before_action :set_raven_context
 	before_action :allow_rack_mini_profiler

	private
	def set_raven_context
		if session[:userinfo]
			Raven.user_context(id: session[:userinfo]["uid"])
		end
		Raven.extra_context(params: params.to_unsafe_h, url: request.url)
	end

	def allow_rack_mini_profiler
	    if current_user && current_user.is_core_dev? && params[:rmp].to_s == 'true'
	      Rack::MiniProfiler.authorize_request
	    end
    end
end
