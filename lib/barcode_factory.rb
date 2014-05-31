class BarcodeFactory
  def self.build(encoding, data)
    code = constant(to_key(encoding))
    code.new(data)
  end

  def self.supported?(encoding)
    key = to_key(encoding)
    ENCODINGS.key?(key)
  end

  private

  ENCODINGS = {
    'bookland'          => 'Barby::Bookland',
    'code128a'          => 'Barby::Code128A',
    'code128b'          => 'Barby::Code128B',
    'code128c'          => 'Barby::Code128C',
    'code25'            => 'Barby::Code25',
    'code25interleaved' => 'Barby::Code25Interleaved',
    'code39'            => 'Barby::Code39',
    'code93'            => 'Barby::Code93',
    'ean13'             => 'Barby::EAN13',
    'ean8'              => 'Barby::EAN8',
    'iata'              => 'Barby::Code25IATA',
    'qr'                => 'Barby::QrCode',
    'supp2'             => 'Barby::UPCSupplemental',
    'supp5'             => 'Barby::UPCSupplemental',
    'upca'              => 'Barby::UPCA'
  }

  def self.constant(string)
    name = ENCODINGS[string]
    Object.const_get(name)
  end

  def self.to_key(string)
    string.to_s.gsub(/-/,'')
  end
end
