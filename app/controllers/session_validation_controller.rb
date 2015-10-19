class SessionValidationController < ApplicationController
	load_and_authorize_resource
	skip_before_filter :verify_authenticity_token, :only => [:update_time]
	respond_to :html, :json, :js

  def update_time

  	model = params[:model_name].singularize.classify.constantize
  	reference_id = params[:reference_id]
  	user_id = current_user.id
		ip_address = request.remote_ip

    respond_to do |format|      
  	 if SessionValidation.validate_session(model, reference_id, user_id, ip_address)
      format.json { render json: { 'status' => true }, status: :ok }
     else
      format.json { render json: { 'status' => false }, status: :unauthorized }
     end
    end

  end

end
