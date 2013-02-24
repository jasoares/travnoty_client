module TravnotyClient
  class Bitmap < Wx::Bitmap

    IMAGE_PATH = TravnotyClient.root_path + "/imgs"

    class << self

      def image_path
        IMAGE_PATH
      end

      def create_flag(hub)
        create("flags/#{hub.code.upcase}.png")
      end

      def create(file_path, type=Wx::BITMAP_TYPE_PNG)
        new("#{Bitmap.image_path}/#{file_path}", type)
      end

    end

  end
end
