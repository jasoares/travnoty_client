require 'travnoty'

module TravnotyClient
  class ServerComboBox < Wx::ComboBox

    def initialize(parent, options={})
      init    = options[:default]  || default_choice
      pos     = options[:position] || Wx::DEFAULT_POSITION
      size    = options[:size]     || Wx::DEFAULT_SIZE
      choices = options[:choices]  || nil

      super(parent, -1, init, pos, size, choices)
    end

  end
end
