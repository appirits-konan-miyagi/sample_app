class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  def hello
    render html: "hello, world!"
  end

  allow_browser versions: :modern
end
