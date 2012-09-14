class User < ActiveRecord::Base
  attr_accessible :name, :avatar_url, :uid

end
