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

  context "500" do
    it 'need tests for 500' do
      fail 'need example data for 500'
    end
  end # 500

  context "501" do
    it 'need tests for 501' do
      fail 'need example data for 501'
    end
  end # 501

  # NOTE:  505 is covered by work_within_work spec

  context "510" do
    it 'need tests for 510' do
      fail 'need example data for 510'
    end
  end # 510

  context "525" do
    it 'need tests for 525' do
      fail 'need example data for 525'
    end
  end # 525

  context "533" do
    it 'need tests for 533' do
      fail 'need example data for 533'
    end
  end # 533

  context "534" do
    it 'need tests for 534' do
      fail 'need example data for 534'
    end
  end # 534

  context "547" do
    it 'need tests for 547' do
      fail 'need example data for 547'
    end
  end # 547

  context "555" do
    it 'need tests for 555' do
      fail 'need example data for 555'
    end
  end # 555

  context "580" do
    it 'need tests for 580' do
      fail 'need example data for 580'
    end
  end # 580

  context "581" do
    it 'need tests for 581' do
      fail 'need example data for 581'
    end
  end # 581

end