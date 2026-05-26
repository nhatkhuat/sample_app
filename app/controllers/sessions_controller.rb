class SessionsController < ApplicationController
  def new
    
  end

  def create
    if params[:send_test_email].present?
      email = params.dig(:session, :email).to_s.strip
      if email.empty?
        flash.now[:danger] = "Email is required to send a test email."
        render 'new', status: :unprocessable_entity
        return
      end

      begin
        UserMailer.test_email(email).deliver_now
        flash[:success] = "Test email sent to #{email}."
        redirect_to login_url
      rescue StandardError => e
        flash.now[:danger] = "Test email failed: #{e.message}"
        render 'new', status: :unprocessable_entity
      end
      return
    end

    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end 


  def destroy
    log_out if logged_in?
    redirect_to root_path, status: :see_other
  end


end
