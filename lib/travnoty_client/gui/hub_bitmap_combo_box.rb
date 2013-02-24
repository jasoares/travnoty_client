require 'travnoty'
require 'travnoty_client/gui/bitmap'

module TravnotyClient
  class HubBitmapComboBox < Wx::BitmapComboBox

    DEFAULT_HUB = 'International'

    class << self

      def create_inside(parent, options={})
        init    = options[:default]  || default_choice
        pos     = options[:position] || Wx::DEFAULT_POSITION
        size    = options[:size]     || Wx::DEFAULT_SIZE
        choices = options[:choices]  || nil

        create(parent, init, pos, size, choices)
      end

      def create(parent, init, pos, size, choices)
        widget = new(parent, -1, init, pos, size, choices)
        populate_with_hubs(widget)
        widget
      end

    private

      def populate_with_hubs(widget)
        hubs.each.with_index do |hub, idx|
          flag = Bitmap.create_flag(hub)
          widget.insert(hub.name, flag, idx, hub)
        end
      end

      def hubs
        @hubs ||= Travnoty.hubs
      end

      def default_choice
        return Travnoty.hub(File.open('hub_id') { |file| Marshal.load(file) }).name if File.exists?('hub_id')
        hubs.find { |hub| hub.name == HubBitmapComboBox::DEFAULT_HUB }.name
      end

    end

  end
end
