#!/usr/bin/env ruby
require 'rubygems'
require 'wx'

class MyFrame < Wx::Frame
  def initialize(title)
    super(nil, -1, title)
    evt_paint { on_paint }
    image = Wx::Image.new('imgs/messenger.png') # load the image from the file
    @bitmap = Wx::Bitmap.new(image) # convert it to a bitmap, ready for drawing with
    build_login_panel
  end

  def login(event)
		puts event.inspect
    puts @username_label.methods.sort.join(", ")
  end

  def on_paint
    paint do |dc|
      dc.clear
      dc.draw_bitmap(@bitmap, 0, 0, false) # draw the
    end
  end

  def build_login_panel
    @login_panel = Wx::Panel.new(self)
    @server_combo = Wx::ComboBox.new(@login_panel, -1, '', Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE, ['ts1.travian.com', 'us8.travian.us', 'tx3.travian.com.br'])
    @username_label = Wx::StaticText.new(@login_panel, -1, 'Username:', Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE, Wx::ALIGN_CENTER)
    @username_field = Wx::TextCtrl.new(@login_panel, -1, 'username')
    @password_label = Wx::StaticText.new(@login_panel, -1, 'Password:', Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE, Wx::ALIGN_CENTER)
    @password_field = Wx::TextCtrl.new(@login_panel, -1, '********', Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE, Wx::TE_PASSWORD)
    @login_button = Wx::Button.new(@login_panel, -1, 'Login')
    evt_button(@login_button.get_id) { |event| login(event) }
    @panel_sizer = Wx::BoxSizer.new(Wx::VERTICAL)
    @login_panel.set_sizer(@panel_sizer)
    @panel_sizer.add(@server_combo, 0, Wx::GROW|Wx::ALL, 2)
    @panel_sizer.add(@username_label, 0, Wx::GROW|Wx::ALL, 2)
    @panel_sizer.add(@username_field, 0, Wx::GROW|Wx::ALL, 2)
    @panel_sizer.add(@password_label, 0, Wx::GROW|Wx::ALL, 2)
    @panel_sizer.add(@password_field, 0, Wx::GROW|Wx::ALL, 2)
    @panel_sizer.add(@login_button, 0, Wx::GROW|Wx::ALL, 2)
  end
end

class MyApp < Wx::App
  def on_init
    @travnoty_client = MyFrame.new("Travnoty Client v0.0.1 Alpha")
		@travnoty_client.show
  end
end

@app = MyApp.new
@app.main_loop

