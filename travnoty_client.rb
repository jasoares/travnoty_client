#!/usr/bin/env ruby
require 'rubygems'
require 'wx'
require 'travian'
require 'travian/server'

Travian.configure do |brx|
  brx.server = 'tx3.travian.com.br'
  brx.user = 'jasoares'
  brx.password = 'frohike'
end

class MyFrame < Wx::Frame
  def initialize(title, pos, size, style=Wx::DEFAULT_FRAME_STYLE)
    super(nil, -1, title, pos, size, style)
    icon_file = File.join(File.dirname(__FILE__), 'imgs', 'travian_notifier_icon.png')
    icon = Wx::Icon.new(icon_file, Wx::BITMAP_TYPE_PNG)
    set_icon(icon)
    build_login_panel
  end

  def build_login_panel
    @login_panel = Wx::Panel.new(self)
    panel_sizer = Wx::BoxSizer.new(Wx::VERTICAL)
    @login_panel.set_sizer(panel_sizer)

    # Splash Image
    img_file = File.join(File.dirname(__FILE__), 'imgs', 'travnoty_splash.png')
    @splash_image = Wx::StaticBitmap.new(@login_panel, -1, Wx::Bitmap.new(img_file, Wx::BITMAP_TYPE_PNG), nil)
    panel_sizer.add(@splash_image, 0, Wx::ALIGN_CENTER, 0)
    panel_sizer.add_spacer(50)

    # Each line composed by an horizontal BoxSizer

    # Country label and dropdown list
    box = Wx::BoxSizer.new(Wx::HORIZONTAL)
    
    country_label = Wx::StaticText.new(@login_panel, :label => 'Country:')
    country_label.set_help_text 'The Travian server country where you have your account'
    box.add(country_label, 0, Wx::ALIGN_CENTER, 0)
    
    @country_combo = Wx::BitmapComboBox.new(@login_panel, -1, 'com', Wx::DEFAULT_POSITION, Wx::Size.new(180, -1), nil)
    Travian::Server.keys.each.with_index do |country,idx|
      name = country.to_s
      country_flag_png = File.join(File.dirname(__FILE__), 'imgs', 'flags', "#{name.upcase}.png")
      bitmap = Wx::Bitmap.new(country_flag_png, Wx::BITMAP_TYPE_PNG)
      @country_combo.insert(name, bitmap, idx)
    end
    box.add(@country_combo, 1, Wx::ALIGN_CENTER, 0)
    
    panel_sizer.add(box, 0, Wx::ALIGN_CENTER, 0)
    panel_sizer.add_spacer(5)

    # Server label and dropdown list
    box = Wx::BoxSizer.new(Wx::HORIZONTAL)
    
    server_label = Wx::StaticText.new(@login_panel, :label => 'Server:')
    server_label.set_help_text 'The Travian server address where you have your account.'
    box.add(server_label, 0, Wx::ALIGN_CENTER, 0)

    @server_combo = Wx::ComboBox.new(@login_panel, -1, '', Wx::DEFAULT_POSITION, Wx::Size.new(180, -1), Travian::Server.servers.values.inject([], :+))
    box.add(@server_combo, 1, Wx::ALIGN_CENTER, 0)
    
    panel_sizer.add(box, 0, Wx::ALIGN_CENTER, 0)
    panel_sizer.add_spacer(5)

    # Username label and text field
    box = Wx::BoxSizer.new(Wx::HORIZONTAL)

    username_label = Wx::StaticText.new(@login_panel, -1, 'Username:', Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE, Wx::ALIGN_CENTER)
    username_label.set_help_text 'Your Travian account username.'
    box.add(username_label, 0, Wx::ALIGN_CENTER, 0)

    @username_field = Wx::TextCtrl.new(@login_panel, :value => '', :size => [180, -1])
    box.add(@username_field, 0, Wx::ALIGN_CENTER, 0)

    panel_sizer.add(box, 0, Wx::ALIGN_CENTER, 0)
    panel_sizer.add_spacer(5)

    # Password label and password field
    box = Wx::BoxSizer.new(Wx::HORIZONTAL)

    password_label = Wx::StaticText.new(@login_panel, :label => 'Password:')
    password_label.set_help_text 'Your Travian account password.'
    box.add(password_label, 0, Wx::ALIGN_CENTER, 0)

    @password_field = Wx::TextCtrl.new(@login_panel, -1, '', Wx::DEFAULT_POSITION, Wx::Size.new(180, -1), Wx::TE_PASSWORD)
    box.add(@password_field, 0, Wx::ALIGN_CENTER, 0)

    panel_sizer.add(box, 0, Wx::ALIGN_CENTER, 0)
    panel_sizer.add_spacer(5)

    # Error messages
    @error_messages = Wx::StaticText.new(@login_panel, :label => '')
    panel_sizer.add(@error_messages, 0, Wx::ALIGN_CENTER, 2)
    panel_sizer.add_spacer(5)

    @login_button = Wx::Button.new(@login_panel, -1, 'Login')
    evt_button(@login_button.get_id) { |event| login(event) }
    panel_sizer.add(@login_button, 0, Wx::ALIGN_CENTER, 2)
    panel_sizer.add_spacer(5)

    self.set_default_item @login_button
  end

  def configure_travian(server, user, password)
    Travian.configure do |account|
      account.server = server
      account.user = user
      account.password = password
    end
  end

  def login(event)
    server, user, password = [@server_combo, @username_field, @password_field].map(&:get_value)
    configure_travian(server, user, password)
    #puts "Hi #{Travian.user.name}, welcome to Travian Notifier"
    puts "There are currently no incoming attacks" unless Travian.incoming_attacks?
    puts "Your total current production is:\n#{Travian.villages.map(&:production).inject(:+)}"
  rescue Travian::InvalidConfigurationError
    @error_messages.set_label 'Invalid username or password.'
  end
end

class MyApp < Wx::App
  def on_init
    @travnoty_client = MyFrame.new("Travnoty Client v0.0.1 Alpha",
      Wx::DEFAULT_POSITION,
      Wx::Size.new(584, 700))
    @travnoty_client.center_on_screen(Wx::BOTH)
		@travnoty_client.show
  end
end

@app = MyApp.new
@app.main_loop

