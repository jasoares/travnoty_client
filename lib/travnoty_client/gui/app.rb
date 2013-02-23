require 'wx'
require File.expand_path('../main_frame.rb', __FILE__)
#require 'travnoty_client/main_frame'

module TravnotyClient
  class App < Wx::App

    def on_init
      @travnoty_client = TravnotyClient::MainFrame.new("Travnoty Client v0.0.1 Alpha",
        Wx::DEFAULT_POSITION,
        Wx::Size.new(580, 600))
      @travnoty_client.center_on_screen(Wx::BOTH)
      @travnoty_client.show
    end

  end
end
