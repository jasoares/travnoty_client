module TravnotyClient
  class VillageLine

    attr_reader :sizer

    def initialize(parent, village)
      @sizer = Wx::HBoxSizer.new
      @parent = parent
      @village = village
      build
    end

    def build
      @name = StaticText.new(@parent, :label => 'name', :size => [150, -1])
      sizer.add(@name, 0, ALIGN_LEFT, 0)
      @wood = StaticText.new(@parent, :label => '0', :size => [100, -1])
      sizer.add(@wood, 0, ALIGN_LEFT, 0)
      @clay = StaticText.new(@parent, :label => '0', :size => [100, -1])
      sizer.add(@clay, 0, ALIGN_LEFT, 0)
      @iron = StaticText.new(@parent, :label => '0', :size => [100, -1])
      sizer.add(@iron, 0, ALIGN_LEFT, 0)
      @cereal = StaticText.new(@parent, :label => '0', :size => [100, -1])
      sizer.add(@cereal, 0, ALIGN_LEFT, 0)
      @attacks = StaticText.new(@parent, :label => '0', :size => [100, -1])
      sizer.add(@attacks, 0, ALIGN_LEFT, 0)
      update(@village)
    end

    def update(village)
      @name.set_label(village.name)
      [@wood, @clay, @iron, @cereal].zip(village.resources).each do |static_text, value|
        static_text.set_label(value.to_s)
      end
      @attacks.set_label(village.incoming_attacks_count.to_s)
    end

  end
end
