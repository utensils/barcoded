require 'spec_helper'

describe BarcodeFactory do
  subject { BarcodeFactory }

  describe '.build' do
    shared_examples 'a supported symbology' do
      let(:symbology) { '' }
      let(:data)      { 'ABC123' }

      it 'will return a Barby::Barcode' do
        barcode = subject.build(symbology, data)
        expect(barcode).to be_a Barby::Barcode
      end
    end

    context 'with dash in symbology' do
      it_behaves_like 'a supported symbology' do
        let(:symbology) { 'code-128a' }
      end
    end

    context 'code-128A' do
      it_behaves_like 'a supported symbology' do
        let(:symbology) { 'code128a' }
      end
    end

    context 'code-128B' do
      it_behaves_like 'a supported symbology' do
        let(:symbology) { 'code128b' }
      end
    end

    context 'code-128C' do
      it_behaves_like 'a supported symbology' do
        let(:symbology) { 'code128c' }
        let(:data)      { '00010203' }
      end
    end

    context 'code-25' do
      it_behaves_like 'a supported symbology' do
        let(:symbology) { 'code25' }
        let(:data)      { '00010203' }
      end
    end
  end
end
