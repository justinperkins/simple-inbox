class IntroController < ApplicationController
  def redirect
    if current_user
      redirect_to(overview_user_path(current_user))
    else
      render(:action => 'index')
    end
  end
end
