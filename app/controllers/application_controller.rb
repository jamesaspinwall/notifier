require "application_responder"

class ApplicationController < ActionController::Base

  include Attrs

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :set_user

  private

  def set_user
    CurrentScope.user = current_user
  end
end
