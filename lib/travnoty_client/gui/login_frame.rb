require 'travnoty'
require 'travian'
require 'travnoty_client/gui/generic_frame'
require 'travnoty_client/gui/login_panel'
include Wx

module TravnotyClient
  class LoginFrame < GenericFrame
    def initialize
      super("Login", DEFAULT_POSITION, Size.new(580, 600))
      @hubs_servers = []
      icon_file = File.expand_path('../../../../imgs/travian_notifier_icon.png', __FILE__)
      icon = Icon.new(icon_file, BITMAP_TYPE_PNG)
      set_icon(icon)
      @login_panel = LoginPanel.new(self)
      evt_close { |event| on_close(event) }
    end

    def on_login
      Wx.get_app.login
      @login_panel.destroy
    end

  end
end
