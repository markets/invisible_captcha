class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
end
