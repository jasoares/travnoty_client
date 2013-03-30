require 'travnoty'
require 'travnoty_client/gui/bitmap'
require 'travnoty_client/gui/hub_bitmap_combo_box'
include Wx

module TravnotyClient
  class LoginPanel < Panel

    attr_reader :login_button

    def initialize(parent)
      super
      @hubs_servers = []

      @data = if File.exists?('data.save')
        File.open('data.save') do |file|
          Marshal.load(file)
        end
      else
        { hub: 'International', server: hubs_servers(22).first.host, user: '', password: ''}
      end
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
      @sizer = BoxSizer.new(VERTICAL)
      self.set_sizer(@sizer)

      # Splash Image
      img_file = File.expand_path('../../../../imgs/travnoty_splash.png', __FILE__)
      @splash_image = StaticBitmap.new(self, -1, Bitmap.new(img_file, BITMAP_TYPE_PNG), nil)
      @sizer.add(@splash_image, 0, ALIGN_CENTER, 0)
      @sizer.add_spacer(20)

      # Each line composed by an horizontal BoxSizer

      # Country label and dropdown list
      box = BoxSizer.new(HORIZONTAL)

      country_label = StaticText.new(self, :label => 'Country:', :size => [100, -1])
      #country_label.set_help_text 'The Travian server country where you have your account'
      box.add(country_label, 0, ALIGN_LEFT, 0)
      
      @hub_combo = HubBitmapComboBox.new(self, size: Size.new(198, 30), default: @data[:hub])
      evt_combobox(@hub_combo) { |event| on_hub_select(event) }
      box.add(@hub_combo, 1, ALIGN_RIGHT, 0)
      
      @sizer.add(box, 0, ALIGN_CENTER, 0)
      @sizer.add_spacer(5)

      # Server label and dropdown list
      @server_line = BoxSizer.new(HORIZONTAL)
      
      server_label = StaticText.new(self, :label => 'Server:', :size => [100, -1])
      #server_label.set_help_text 'The Travian server address where you have your account.'
      @server_line.add(server_label, 0, ALIGN_CENTER, 0)

      @server_combo = ComboBox.new(self, -1, @data[:server], DEFAULT_POSITION, Size.new(200, -1), hubs_servers(22).map(&:host))
      @server_line.add(@server_combo, 1, ALIGN_CENTER, 0)
      
      @sizer.add(@server_line, 0, ALIGN_CENTER, 0)
      @sizer.add_spacer(5)

      # Username label and text field
      box = BoxSizer.new(HORIZONTAL)

      username_label = StaticText.new(self, :label => 'Username:', :size => [100, -1])
      #username_label.set_help_text 'Your Travian account username.'
      box.add(username_label, 0, ALIGN_CENTER, 0)

      @username_field = TextCtrl.new(self, :value => @data[:user], :size => [200, -1])
      box.add(@username_field, 0, ALIGN_CENTER, 0)

      @sizer.add(box, 0, ALIGN_CENTER, 0)
      @sizer.add_spacer(5)

      # Password label and password field
      box = BoxSizer.new(HORIZONTAL)

      password_label = StaticText.new(self, :label => 'Password:', :size => [100, -1])
      #password_label.set_help_text 'Your Travian account password.'
      box.add(password_label, 0, ALIGN_CENTER, 0)

      @password_field = TextCtrl.new(self, -1, @data[:password], DEFAULT_POSITION, Size.new(200, -1), TE_PASSWORD)
      box.add(@password_field, 0, ALIGN_CENTER, 0)

      @sizer.add(box, 0, ALIGN_CENTER, 0)
      @sizer.add_spacer(10)

      # Error messages
      @error_messages = StaticText.new(self, :label => '')
      @sizer.add(@error_messages, 0, ALIGN_CENTER, 0)
      @sizer.add_spacer(10)

      @login_button = Button.new(self, -1, 'Login')
      evt_button(@login_button.get_id) { |event| login(event) }
      @sizer.add(@login_button, 0, ALIGN_CENTER, 2)
      @sizer.add_spacer(5)
    end

    def login(event)
      Wx.begin_busy_cursor
      hub = @selected_hub
      puts hub
      server, user, password = [@server_combo, @username_field, @password_field].map(&:get_value)
      configure_travian(server, user, password)
      puts "Hi #{Travian.user.name}, welcome to Travian Notifier"
      #puts "There are currently no incoming attacks" unless Travian.incoming_attacks?
      #puts "Your total current production is:\n#{Travian.villages.map(&:production).inject(:+)}"
      data = { hub: hub, server: server, user: user, password: password }
      File.open('data.save','w') do |file|
        Marshal.dump(data, file)
      end
      self.get_parent.on_login
    rescue Travian::InvalidConfigurationError
      @error_messages.set_label 'Invalid username or password.'
      @sizer.layout
    ensure
      Wx.end_busy_cursor
    end

    def configure_travian(server, user, password)
      Travian.configure do |account|
        account.server = server
        account.user = user
        account.password = password
      end
    end

    def on_hub_select(event)
      if @server_line.detach(@server_combo)
        @selected_hub = event.get_client_data.name
        servers = Travnoty.hubs_servers(event.get_client_data.id).map(&:host)
        @server_combo.destroy
        @server_combo = ComboBox.new(
          self, -1,
          servers.first,
          DEFAULT_POSITION,
          Size.new(200, -1),
          servers
        )
      end
      @server_line.add(@server_combo)
      @sizer.layout
    end

  end
end
