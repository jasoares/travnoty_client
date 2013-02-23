require File.expand_path('../travnoty_client/version.rb', __FILE__)
require File.expand_path('../travnoty_client/gui/app.rb', __FILE__)
#require 'travnoty_client/version'
#require 'travnoty_client/gui/app'

module TravnotyClient
  extend self

  def exec
    TravnotyClient::App.new.main_loop
  end

end
