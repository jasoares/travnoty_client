require 'travnoty'
require 'travnoty_client/gui/village_line'
include Wx

module TravnotyClient
  class MonitorPanel < Panel

    def initialize(parent)
      super
      @village_lines = []
      build
    end

    def build
      define_sizer
      add_monitoring_widget
      add_spacer
      add_category('User info:')
      add_spacer
      add_user_details(Travian.user)
      add_spacer
      add_category('Villages:')
      add_spacer
      add_villages_header
      Travian.user.villages.each do |village|
        add_village_line(village)
      end
      Wx::Timer.every(15000) do
        Wx.begin_busy_cursor
        update
        Wx.end_busy_cursor
      end
    end

    def start
      @updating = true
    end

    def stop
      @updating = false
    end

    def sizer
      @sizer
    end

    def update
      villages = Travian.user.villages
      @village_lines.zip(villages).each do |village_line, village|
        village_line.update(village)
      end
    end


  private

    def add_monitoring_widget
      box = HBoxSizer.new
      monitoring = StaticText.new(self, :label => 'Monitoring ')
      anim_file = File.expand_path('../../../../imgs/green_circle.gif', __FILE__)
      anim = Animation.new(anim_file, ANIMATION_TYPE_GIF)
      @anim_ctrl = AnimationCtrl.new(self, -1, anim, DEFAULT_POSITION, DEFAULT_SIZE)
      @anim_ctrl.play
      box.add(monitoring, 0, ALIGN_LEFT, 0)
      box.add(@anim_ctrl, 0, ALIGN_LEFT, 0)
      sizer.add(box, 0, ALIGN_LEFT, 0)
    end

    def add_village_line(village)
      village_line = VillageLine.new(self, village)
      @village_lines << village_line
      sizer.add(village_line.sizer, 0, ALIGN_LEFT, 0)
      sizer.add_spacer(10)
    end

    def add_category(name)
      box = BoxSizer.new(HORIZONTAL)
      label = StaticText.new(self, :label => name, :size => [100, -1])
      box.add(label, 0, ALIGN_LEFT, 0)
      sizer.add(box, 0, ALIGN_LEFT, 0)
      sizer.add_spacer(5)
    end

    def add_info_line(label, info)
      box = BoxSizer.new(HORIZONTAL)
      label = StaticText.new(self, :label => label, :size => [100, -1])
      box.add(label, 0, ALIGN_LEFT, 0)
      info = StaticText.new(self, :label => info, :size => [100, -1])
      box.add(info, 0, ALIGN_LEFT, 0)
      sizer.add(box, 0, ALIGN_LEFT, 0)
      sizer.add_spacer(5)
    end

    def add_user_details(user)
      box = HBoxSizer.new
      label = StaticText.new(self, :label => 'Name: ')
      box.add(label, 0, ALIGN_LEFT, 0)
      link = "http://#{Travian.send(:options)[:server]}/spieler.php?uid=#{user.uid}"
      name = HyperlinkCtrl.new(self, -1, user.name, link)
      box.add(name, 0, ALIGN_LEFT, 0)
      box.add_spacer(20)
      label = StaticText.new(self, :label => 'Alliance: ')
      box.add(label, 0, ALIGN_LEFT, 0)
      if user.has_alliance?
        link = "http://#{Travian.send(:options)[:server]}/allianz.php"
        name = HyperlinkCtrl.new(self, -1, user.alliance.name, link)
      else
        name = StaticText.new(self, :label => '-')
      end
      box.add(name, 0, ALIGN_LEFT, 0)
      sizer.add(box, 0, ALIGN_LEFT, 0)
      sizer.add_spacer(5)
    end

    def add_villages_header
      box = HBoxSizer.new
      villages = StaticText.new(self, :label => 'Name', :size => [150, -1])
      box.add(villages, 0, ALIGN_LEFT, 0)
      img_file = File.expand_path('../../../../imgs/wood.gif', __FILE__)
      wood = StaticBitmap.new(self, -1, Bitmap.new(img_file, BITMAP_TYPE_GIF), :size => [100, -1])
      box.add(wood, 0, ALIGN_LEFT, 0)
      img_file = File.expand_path('../../../../imgs/clay.gif', __FILE__)
      clay = StaticBitmap.new(self, -1, Bitmap.new(img_file, BITMAP_TYPE_GIF), :size => [100, -1])
      box.add(clay, 0, ALIGN_LEFT, 0)
      img_file = File.expand_path('../../../../imgs/iron.gif', __FILE__)
      iron = StaticBitmap.new(self, -1, Bitmap.new(img_file, BITMAP_TYPE_GIF), :size => [100, -1])
      box.add(iron, 0, ALIGN_LEFT, 0)
      img_file = File.expand_path('../../../../imgs/cereal.gif', __FILE__)
      cereal = StaticBitmap.new(self, -1, Bitmap.new(img_file, BITMAP_TYPE_GIF), :size => [100, -1])
      box.add(cereal, 0, ALIGN_LEFT, 0)
      img_file = File.expand_path('../../../../imgs/att1.gif', __FILE__)
      attacks = StaticBitmap.new(self, -1, Bitmap.new(img_file, BITMAP_TYPE_GIF), :size => [100, -1])
      box.add(attacks, 0, ALIGN_LEFT, 0)
      sizer.add(box, 0, ALIGN_LEFT, 0)
      sizer.add_spacer(5)
    end

    def add_spacer
      sizer.add_spacer(10)
    end

    def define_sizer
      @vertical_sizer = VBoxSizer.new
      @vertical_sizer.add_spacer(10)
      @horizontal_sizer = HBoxSizer.new
      @horizontal_sizer.add_spacer(10)
      @sizer = BoxSizer.new(VERTICAL)
      @horizontal_sizer.add(@sizer)
      @horizontal_sizer.add_spacer(10)
      @vertical_sizer.add(@horizontal_sizer)
      @vertical_sizer.add_spacer(10)
      self.set_sizer(@vertical_sizer)
    end

  end
end
