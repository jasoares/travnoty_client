require 'travnoty'
require 'travian'
require 'travnoty_client/gui/hub_bitmap_combo_box'

module TravnotyClient
  class MainFrame < Wx::Frame
    def initialize(title, pos, size, style=Wx::DEFAULT_FRAME_STYLE)
      super(nil, -1, title, pos, size, style)
      @hubs_servers = []
      icon_file = File.expand_path('../../../../imgs/travian_notifier_icon.png', __FILE__)
      icon = Wx::Icon.new(icon_file, Wx::BITMAP_TYPE_PNG)
      set_icon(icon)
      build_login_panel
    end

    def hubs
      @hubs ||= Travnoty.hubs.sort_by(&:name)
    end

    def hubs_servers(id)
      @hubs_servers[hubs[id].id] ||= begin
        Travnoty.hubs_servers(hubs[id].id)
      end
    end

    def build_login_panel
      @login_panel = Wx::Panel.new(self)
      @panel_sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      @login_panel.set_sizer(@panel_sizer)

      # Splash Image
      img_file = File.expand_path('../../../../imgs/travnoty_splash.png', __FILE__)
      @splash_image = Wx::StaticBitmap.new(@login_panel, -1, Wx::Bitmap.new(img_file, Wx::BITMAP_TYPE_PNG), nil)
      @panel_sizer.add(@splash_image, 0, Wx::ALIGN_CENTER, 0)
      @panel_sizer.add_spacer(20)

      # Each line composed by an horizontal BoxSizer

      # Country label and dropdown list
      box = Wx::BoxSizer.new(Wx::HORIZONTAL)
      
      country_label = Wx::StaticText.new(@login_panel, :label => 'Country:', :size => [100, -1])
      #country_label.set_help_text 'The Travian server country where you have your account'
      box.add(country_label, 0, Wx::ALIGN_LEFT, 0)
      
      @hub_combo = HubBitmapComboBox.create_inside(@login_panel, size: Wx::Size.new(198, 30))
      evt_combobox(@hub_combo) { |event| on_hub_select(event) }
      box.add(@hub_combo, 1, Wx::ALIGN_RIGHT, 0)
      
      @panel_sizer.add(box, 0, Wx::ALIGN_CENTER, 0)
      @panel_sizer.add_spacer(5)

      # Server label and dropdown list
      @server_line = Wx::BoxSizer.new(Wx::HORIZONTAL)
      
      server_label = Wx::StaticText.new(@login_panel, :label => 'Server:', :size => [100, -1])
      #server_label.set_help_text 'The Travian server address where you have your account.'
      @server_line.add(server_label, 0, Wx::ALIGN_CENTER, 0)

      @server_combo = Wx::ComboBox.new(@login_panel, -1, hubs_servers(22).first.host, Wx::DEFAULT_POSITION, Wx::Size.new(200, -1), hubs_servers(22).map(&:host))
      @server_line.add(@server_combo, 1, Wx::ALIGN_CENTER, 0)
      
      @panel_sizer.add(@server_line, 0, Wx::ALIGN_CENTER, 0)
      @panel_sizer.add_spacer(5)

      # Username label and text field
      box = Wx::BoxSizer.new(Wx::HORIZONTAL)

      username_label = Wx::StaticText.new(@login_panel, :label => 'Username:', :size => [100, -1])
      #username_label.set_help_text 'Your Travian account username.'
      box.add(username_label, 0, Wx::ALIGN_CENTER, 0)

      @username_field = Wx::TextCtrl.new(@login_panel, :value => '', :size => [200, -1])
      box.add(@username_field, 0, Wx::ALIGN_CENTER, 0)

      @panel_sizer.add(box, 0, Wx::ALIGN_CENTER, 0)
      @panel_sizer.add_spacer(5)

      # Password label and password field
      box = Wx::BoxSizer.new(Wx::HORIZONTAL)

      password_label = Wx::StaticText.new(@login_panel, :label => 'Password:', :size => [100, -1])
      #password_label.set_help_text 'Your Travian account password.'
      box.add(password_label, 0, Wx::ALIGN_CENTER, 0)

      @password_field = Wx::TextCtrl.new(@login_panel, -1, '', Wx::DEFAULT_POSITION, Wx::Size.new(200, -1), Wx::TE_PASSWORD)
      box.add(@password_field, 0, Wx::ALIGN_CENTER, 0)

      @panel_sizer.add(box, 0, Wx::ALIGN_CENTER, 0)
      @panel_sizer.add_spacer(5)

      # Error messages
      @error_messages = Wx::StaticText.new(@login_panel, :label => '')
      @panel_sizer.add(@error_messages, 0, Wx::ALIGN_CENTER, 2)
      @panel_sizer.add_spacer(5)

      @login_button = Wx::Button.new(@login_panel, -1, 'Login')
      evt_button(@login_button.get_id) { |event| login(event) }
      @panel_sizer.add(@login_button, 0, Wx::ALIGN_CENTER, 2)
      @panel_sizer.add_spacer(5)

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
      puts "Hi #{Travian.user.name}, welcome to Travian Notifier"
      puts "There are currently no incoming attacks" unless Travian.incoming_attacks?
      puts "Your total current production is:\n#{Travian.villages.map(&:production).inject(:+)}"
    rescue Travian::InvalidConfigurationError
      @error_messages.set_label 'Invalid username or password.'
    end

    def on_hub_select(event)
      if @server_line.detach(@server_combo)
        servers = Travnoty.hubs_servers(event.get_client_data.id).map(&:host)
        @server_combo.destroy
        @server_combo = Wx::ComboBox.new(
          @login_panel, -1,
          servers.first,
          Wx::DEFAULT_POSITION,
          Wx::Size.new(200, -1),
          servers
        )
      end
      @server_line.add(@server_combo)
      @panel_sizer.layout
    end

  end
end
