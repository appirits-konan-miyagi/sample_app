# class ApplicationController < ActionController::Base
#   # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.


#   allow_browser versions: :modern
# end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  # def hello
  #   render html: "hello, world!"
  # end

  # def goodbye
  #   render html:"goodbye,world"
  # end

  def store_location
    session[:forwarding_url] = request.original_url if request.get? # GETリクエストでのみ保存
  end

 
  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

end
