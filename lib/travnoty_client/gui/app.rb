require 'wx'
require 'travnoty_client/gui/login_frame'
require 'travnoty_client/gui/monitor_frame'
include Wx

module TravnotyClient
  class App < Wx::App

    def on_init
      @frame = LoginFrame.new
      @frame.center_on_screen(BOTH)
      @frame.show
    end

    def on_run
      super
    end

    def login
      @frame.hide
      @main_frame = MonitorFrame.new
      @main_frame.center_on_screen(BOTH)
      @main_frame.show
    end

  end
end
