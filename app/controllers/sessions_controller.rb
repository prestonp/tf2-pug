class SessionsController < ApplicationController
  def login
    
    auth_hash = request.env['omniauth.auth']
    @avatar_url = auth_hash['extra']['raw_info']['avatarfull']
    @uid = auth_hash['uid']
    @name = auth_hash['info']['nickname']
    
    #@user = User.new(:uid => @uid)
    @debug = ""
    if @uid.present?
      session[:uid] = @uid
      session[:name] = @name
      @debug += "uid found, "

      # Lookup User
      @user = User.find_by_uid(@uid)
      if @user
	#Extract to login_update()
	@debug += "user found, "
	@user.name = @name
	@user.avatar_url = @avatar_url
	@user.save!
      else
	#Extract to login_create()
	@debug += "user not found, "
        User.new(:uid => @uid, :name => @name, :avatar_url => @avatar_url).save!
      end
	
    else
      @debug = "uid not found, "
    end
  end

  def logout
    redirect_to root_path unless logged_in?
    
    reset_session
    redirect_to root_path
  end
end
