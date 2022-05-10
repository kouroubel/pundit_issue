class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :mailer_set_url_options
  
  include Pundit::Authorization
  
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
end
