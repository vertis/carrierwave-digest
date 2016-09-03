require 'spec_helper'

class DigestTest
  include Carrierwave::Digest
  ensure_digest_for :image
end

describe Carrierwave::Digest do
  it 'has a version number' do
    expect(Carrierwave::Digest::VERSION).not_to be nil
  end

  it 'should generate a digest for an image that has just been added' do
    d = DigestTest.new
    image = double('image')
    file = File.open('LICENSE.txt')
    expect(file).to receive(:present?).and_return(true)
    expect(image).to receive(:file).at_least(:once).and_return(file)
    expect(d).to receive(:image).at_least(:once).and_return(image)
    expect(d).to receive(:image_changed?).and_return(true)
    expect(d.image_digest).to eq("626cfc9a343c4567bf035120b422b84e20735cc8")
  end

  it 'should return the existing digest stored in the database' do
    d = DigestTest.new
    expect(d).to receive(:[]).with(:image_digest).and_return("1234")
    expect(d).to receive(:image_changed?).and_return(false)
    expect(d.image_digest).to eq("1234")
  end
end
