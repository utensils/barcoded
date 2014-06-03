class BarcodeImageFactory

  def self.build(barcode, format, options = {})
    out       = format_outputter(format)
    outputter = out.new(barcode)
    outputter.send("to_#{format}", options)
  end

  private

  def self.format_outputter(format)
    case format
    when 'png', 'gif', 'jpg'
      Barby::RmagickOutputter
    when 'svg'
      Barby::SvgOutputter
    end
  end
end
