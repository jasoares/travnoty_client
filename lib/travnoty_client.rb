require 'travnoty_client/version'
require 'travnoty_client/gui/app'

module TravnotyClient
  extend self

  def exec
    TravnotyClient::App.new.main_loop
  end

end
