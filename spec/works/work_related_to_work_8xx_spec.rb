require 'spec_helper'
require 'linkeddata'

describe 'work related to the work described by the MARC record' do

  # Stanford:
  # MARC fields that identify “a work related to the work the described by the record”:
  # 247
  # 400, 410, 411, 440
  # 490 and 80x-83x
  # 500, 501, 525, 510, 533, 534, 547, 555, 580, 581
  # 600-611 with $t, and 630
  # 690 (Is a collection a work?)
  # 700-711 with $t but second indicator not “2”
  # 730 and 740 with second indicator not “2”
  # 76x-78x
  # 79x
  # And perhaps accompanying materials (300 $e)

  # marc2bibframe xquery converter
  # ???

  let(:marc_ldr_001_008) {
    '<record xmlns="http://www.loc.gov/MARC21/slim">
      <leader>01855cemaa22003131a 4500</leader>
      <controlfield tag="001">aRECORD_ID</controlfield>
      <controlfield tag="008">760219s1925    en            000 0 eng  </controlfield>'
  }

  context "800" do
    it 'need tests for 800' do
      fail 'need example data for 800'
    end
  end # 800

  context "810" do
    it 'need tests for 810' do
      fail 'need example data for 810'
    end
  end # 810

  context "811" do
    it 'need tests for 811' do
      fail 'need example data for 811'
    end
  end # 811

  context "830" do
    it 'need tests for 830' do
      fail 'need example data for 830'
    end
  end # 830

end
