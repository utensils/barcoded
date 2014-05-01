class BarcodeImageFactory

  def self.build(barcode, format)
    out       = format_outputter(format)
    outputter = out.new(barcode)
    outputter.send("to_#{format.downcase}")
  end

  private

  def self.format_outputter(format)
    case format
    when 'png', 'gif', 'jpg'
      Barby::RmagickOutputter
    when 'svg'
      raise NotImplementedError
    end 
  end
end
