# Temporary patch for Barby until issue is resolved.
# See PR on github https://github.com/toretore/barby/pull/37

module Barby
  class RmagickOutputter < Outputter
    def to_image(opts={})
      with_options opts do
        canvas = Magick::Image.new(full_width, full_height)
        bars = Magick::Draw.new

        x1 = margin
        y1 = margin

        if barcode.two_dimensional?
          encoding.each do |line|
            line.split(//).map{|c| c == '1' }.each do |bar|
              if bar
                x2 = x1+(xdim-1)
                y2 = y1+(ydim-1)
                # For single pixels use point
                if x1 == x2 && y1 == y2
                  bars.point(x1,y1)
                else
                  bars.rectangle(x1, y1, x2, y2)
                end
              end
              x1 += xdim
            end
            x1 = margin
            y1 += ydim
          end
        else
          booleans.each do |bar|
            if bar
              x2 = x1+(xdim-1)
              y2 = y1+(height-1)
              bars.rectangle(x1, y1, x2, y2)
            end
            x1 += xdim
          end
        end

        bars.draw(canvas)

        canvas
      end
    end

  end


end