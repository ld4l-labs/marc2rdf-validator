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
  let(:work_sparql_query) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  SELECT DISTINCT ?work
                  WHERE {
                    ?work a bf:Work .
                  }") }

  context "500" do

  end # 500

  context "501" do

  end # 501

  context "510" do

  end # 510

  context "525" do

  end # 525

  context "533" do

  end # 533

  context "534" do

  end # 534

  context "547" do

  end # 547

  context "555" do

  end # 555

  context "580" do

  end # 580

  context "581" do

  end # 581

end