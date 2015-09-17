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

  context "600" do
    it 'need tests for 600' do
      fail 'need example data for 600'
    end
  end # 600

  context "610" do
    it 'need tests for 610' do
      fail 'need example data for 610'
    end
  end # 610

  context "611" do
    it 'need tests for 611' do
      fail 'need example data for 611'
    end
  end # 611

  context "630" do
    it 'need tests for 630' do
      fail 'need example data for 630'
    end
  end # 639

  context "690" do
    it 'need tests for 690' do
      fail 'need example data for 690'
    end
  end # 690

end