require 'spec_helper'
require 'linkeddata'

describe 'the work described by the MARC record' do

  # Stanford:
  # MARC fields that identify “a work described by the record”:
  # 130
  # 100|110|111 and 240
  # 100|110|111 and 245
  # 245 (‡a) if no 1xx

  # marc2bibframe xquery converter
  # Each Bib Record creates a Work
  # PLUS
  # 130|240  # uniform title
  # 880 for 130|240  vernacular uniform title

  context "130" do
    let(:beowulf_work_squery) {
      SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                    SELECT DISTINCT ?work
                    WHERE {
                      ?work a bf:Work .
                      ?work bf:authorizedAccessPoint ?aap .
                      FILTER regex(?aap, 'Beowulf', 'i')
                    }") }

    it '130 ‡a only has single work' do
      marcxml_str = '<record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>01855cemaa22003131a 4500</leader>
        <controlfield tag="001">a130a_only</controlfield>
        <controlfield tag="008">760219s1925    en            000 0 eng  </controlfield>
        <datafield ind1="0" ind2=" " tag="130">
          <subfield code="a">Beowulf.</subfield>
        </datafield>
        <datafield ind1="0" ind2="0" tag="245">
          <subfield code="a">Beowulf</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '130a_only')
      expect(g.query(beowulf_work_squery).size).to eq 1
    end
    it '130 ‡a, ‡=  has single work' do
      marcxml_str = '<record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>01855cemaa22003131a 4500</leader>
        <controlfield tag="001">a130a_equal</controlfield>
        <controlfield tag="008">760219s1925    en            000 0 eng  </controlfield>
        <datafield ind1="0" ind2=" " tag="130">
          <subfield code="a">Beowulf.</subfield>
          <subfield code="=">^A944917</subfield>
        </datafield>
        <datafield ind1="0" ind2="0" tag="245">
          <subfield code="a">Beowulf</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '130a_equal')
      # TODO:  would like to keep ^A944917 out of aap ??
      expect(g.query(beowulf_work_squery).size).to eq 1
    end
    it '130 ‡a, ‡n, ‡?  has single work' do
      marcxml_str = '<record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>01855cemaa22003131a 4500</leader>
        <controlfield tag="001">a130an_question_mark</controlfield>
        <controlfield tag="008">760219s1925    en            000 0 eng  </controlfield>
        <datafield ind1="0" ind2=" " tag="130">
          <subfield code="a">Annale.</subfield>
          <subfield code="n">Reeks B (University of Stellenbosch : 1979)</subfield>
          <subfield code="?">UNAUTHORIZED</subfield>
        </datafield>
        <datafield ind1="0" ind2="0" tag="245">
          <subfield code="a">Annale.</subfield>
          <subfield code="n">Reeks B /</subfield>
          <subfield code="c">Universiteit van Stellebosch.</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '130an_question_mark')
      squery = SPARQL.parse(" PREFIX bf: <http://bibframe.org/vocab/>
                              SELECT DISTINCT ?work
                              WHERE {
                                ?work a bf:Work .
                                ?work bf:authorizedAccessPoint ?aap .
                                FILTER regex(?aap, 'Annale', 'i') }")
      # TODO:  would like to keep UNAUTHORIZED out of aap ??
      expect(g.query(squery).size).to eq 1
    end
  end # context 130

  context "1xx and 240" do
    it '100 and 240' do
      fail 'test to be implemented'
    end
    it '110 and 240' do
      fail 'test to be implemented'
    end
    it '111 and 240' do
      fail 'test to be implemented'
    end
  end # context 1xx and 240

  context "1xx and 245" do
    it '100 and 245' do
      fail 'test to be implemented'
    end
    it '110 and 245' do
      fail 'test to be implemented'
    end
    it '111 and 245' do
      fail 'test to be implemented'
    end
  end # context 1xx and 245

  context "245 no 1xx" do

  end # context 245 no 1xx


end
