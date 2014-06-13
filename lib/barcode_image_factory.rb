class BarcodeImageFactory

  DEFAULT_OPTIONS = {
    margin: 0
  }

  def self.build(barcode, format, options = {})
    out       = format_outputter(format)
    outputter = out.new(barcode)
    outputter.send("to_#{format}", DEFAULT_OPTIONS.merge(options))
  end

  private

  def self.format_outputter(format)
    case format
    when 'png', 'gif', 'jpg'
      Barcoded::RmagickOutputter
    when 'svg'
      Barby::SvgOutputter
    end
  end
end
