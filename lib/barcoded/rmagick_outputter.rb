module Barcoded
  class RmagickOutputter
    def initialize(barcode)
      @barcode = barcode
    end

    %i(png gif jpg).each do |format|
      define_method("to_#{format}") do |opts = {}|
        img = to_image(opts)
        img.to_blob { |i| i.format = format.to_s }
      end
    end

    def to_image(opts = {})
      img    = Barby::RmagickOutputter.new(@barcode).to_image
      height = opts[:height] || img.rows
      width  = opts[:width]  || img.columns
      img.scale(width, height)
    end
  end
end
