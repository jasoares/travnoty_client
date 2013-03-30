require 'travnoty'
require 'travnoty_client/gui/generic_frame'
require 'travnoty_client/gui/monitor_panel'
include Wx

module TravnotyClient
  class MonitorFrame < GenericFrame

    def initialize
      super("Monitor", DEFAULT_POSITION, Size.new(680,440))
      @panel = MonitorPanel.new(self)
      evt_close { |event| on_close(event) }
    end

    def on_close(event)
      destroy
      exit
    end

  end
end
