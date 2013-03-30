require 'travnoty_client/version'

module TravnotyClient
  class GenericFrame < Wx::Frame

    def initialize(subtitle, pos, size, style=DEFAULT_FRAME_STYLE)
      title = "#{subtitle} - Travnoty Client v#{TravnotyClient::VERSION}"
      super(nil, -1, title, pos, size, style)
      icon_file = File.expand_path('../../../../imgs/travian_notifier_icon.png', __FILE__)
      icon = Icon.new(icon_file, BITMAP_TYPE_PNG)
      set_icon(icon)
      evt_close { |event| on_close(event) }
    end

    def on_close(event)
      destroy
      exit
    end

  end
end
