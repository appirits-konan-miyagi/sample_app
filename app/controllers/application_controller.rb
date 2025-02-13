# class ApplicationController < ActionController::Base
#   # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

#   def hello
#     render html: "hello, world!"
#   end

#   allow_browser versions: :modern
# end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def store_location
    session[:forwarding_url] = request.original_url if request.get? # GETリクエストでのみ保存
  end

end