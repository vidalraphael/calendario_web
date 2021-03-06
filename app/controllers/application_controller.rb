class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied, with: :access_denied
  before_action :check_login

  private
  def check_login
    login = cookies[:login]

    if login
      @active_user = current_user
      redirect_to login_path unless @active_user.ativo
      cookies[:login] = {value: @active_user.id, expires: Time.now + 900}
    else
      redirect_to login_path
    end
  end

  def current_user
    @active_user ||= Usuario.find(cookies[:login])
  end

  def access_denied(exception)
    begin
      redirect_to :back, notice: 'Você não tem acesso para realizar esta ação.'
    rescue ActionController::RedirectBackError
      redirect_to root_path, notice: 'Você não tem acesso para realizar esta ação.'
    end
  end
end
