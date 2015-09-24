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

  context "247" do
    let!(:g) {
      rec_id = '247'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="0" ind2="4" tag="245">
          <subfield code="a">The New York times</subfield>
          <subfield code="h">[microform].</subfield>
        </datafield>
        <datafield ind1="1" ind2="0" tag="247">
          <subfield code="a">New York daily times</subfield>
          <subfield code="f">1851-Sept. 12, 1857</subfield>
        </datafield>
      </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
    }
    it '2 works' do
      expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
    end
    it '1 related work' do
      expect_work2work_property(g, 1, RDF::Vocab::Bibframe.relatedWork)
    end

  end # 247

  context "400" do
    it 'need tests for 400' do
      fail 'need example data for 400'
    end
  end # 400

  context "410" do
    it 'need tests for 410' do
      fail 'need example data for 410'
    end
  end # 410

  context "411" do
    it 'need tests for 411' do
      fail 'need example data for 411'
    end
  end # 411

  context "440" do
    it 'need tests for 440' do
      fail 'need example data for 440'
    end
  end # 440

  context "490" do
    it 'need tests for 490' do
      fail 'need example data for 490'
    end
  end # 490
end
