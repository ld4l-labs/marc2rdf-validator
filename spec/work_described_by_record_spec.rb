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

  let(:marc_ldr_001_008) {
    '<record xmlns="http://www.loc.gov/MARC21/slim">
      <leader>01855cemaa22003131a 4500</leader>
      <controlfield tag="001">aRECORD_ID</controlfield>
      <controlfield tag="008">760219s1925    en            000 0 eng  </controlfield>'
  }
  let(:work_squery) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  SELECT DISTINCT ?work
                  WHERE {
                    ?work a bf:Work .
                  }") }
  # TODO:  rework title query for workTitle (?)
  # TODO:  title shouldn't have certain subfields (e.g. ‡=, ‡?)
  let(:work_title_sparql) {"PREFIX bf: <http://bibframe.org/vocab/>
                            SELECT DISTINCT ?work
                            WHERE {
                              ?work a bf:Work .
                              ?work bf:authorizedAccessPoint ?aap .
                              FILTER regex(?aap, 'TITLE_REGEX', 'i')
                            }" }

  context "130" do
    let(:beowulf_work_title_squery) { SPARQL.parse(work_title_sparql.sub('TITLE_REGEX', 'Beowulf'))}

    it '130 ‡a only has single work' do
      rec_id = '130a_only'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="0" ind2=" " tag="130">
          <subfield code="a">Beowulf.</subfield>
        </datafield>
        <datafield ind1="0" ind2="0" tag="245">
          <subfield code="a">Beowulf</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      expect(g.query(work_squery).size).to eq 1
      expect(g.query(beowulf_work_title_squery).size).to eq 1
    end
    it '130 ‡a only has single work with title from 130' do
      rec_id = '130a_title'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="0" ind2=" " tag="130">
          <subfield code="a">Beowulf.</subfield>
        </datafield>
        <datafield ind1="0" ind2="0" tag="245">
          <subfield code="a">ignore me</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      expect(g.query(work_squery).size).to eq 1
      expect(g.query(beowulf_work_title_squery).size).to eq 1
      work_title_squery = SPARQL.parse(work_title_sparql.sub('TITLE_REGEX', 'ignore'))
      expect(g.query(work_title_squery).size).to eq 0
    end
    it '130 ‡a, ‡= has single work' do
      rec_id = '130a_equal'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="0" ind2=" " tag="130">
          <subfield code="a">Beowulf.</subfield>
          <subfield code="=">^A944917</subfield>
        </datafield>
        <datafield ind1="0" ind2="0" tag="245">
          <subfield code="a">ignore me</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      expect(g.query(work_squery).size).to eq 1
      expect(g.query(beowulf_work_title_squery).size).to eq 1
    end
    it '130 ‡a, ‡n, ‡? has single work' do
      rec_id = '130an_question_mark'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="0" ind2=" " tag="130">
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
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      expect(g.query(work_squery).size).to eq 1
      work_title_squery = SPARQL.parse(work_title_sparql.sub('TITLE_REGEX', 'Annale'))
      expect(g.query(work_title_squery).size).to eq 1
    end
  end # context 130

  context "100|110|111 and 240" do
    it '100 ‡a, ‡? and 240 ‡a, ‡? has single work' do
      rec_id = '100a_240a_question_marks'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="1" ind2=" " tag="100">
          <subfield code="a">Davis, Miles.</subfield>
          <subfield code="?">UNAUTHORIZED</subfield>
        </datafield>
        <datafield ind1="1" ind2="0" tag="240">
          <subfield code="a">Birth of the cool</subfield>
          <subfield code="?">UNAUTHORIZED</subfield>
        </datafield>
        <datafield ind1="1" ind2="0" tag="245">
          <subfield code="a">ignored</subfield>
          <subfield code="c">Miles Davis.</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      expect(g.query(work_squery).size).to eq 1
      title_squery = SPARQL.parse(" PREFIX bf: <http://bibframe.org/vocab/>
                                    SELECT DISTINCT ?work
                                    WHERE {
                                      ?work a bf:Work .
                                      ?work bf:authorizedAccessPoint ?aap .
                                      FILTER regex(?aap, 'Davis, Miles', 'i')
                                      FILTER regex(?aap, 'Birth of the cool', 'i')
                                    }")
      expect(g.query(title_squery).size).to eq 1
      work_title_squery = SPARQL.parse(work_title_sparql.sub('TITLE_REGEX', 'ignore'))
      expect(g.query(work_title_squery).size).to eq 0
    end
    it '110 ‡a, ‡b, ‡= and 240 ‡a has single work' do
      rec_id = '110ab_240a_equal'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="1" ind2=" " tag="110">
          <subfield code="a">South Africa.</subfield>
          <subfield code="b">Department of Education</subfield>
          <subfield code="=">^A1298224</subfield>
        </datafield>
        <datafield ind1="1" ind2="0" tag="240">
          <subfield code="a">Annual report (Online)</subfield>
        </datafield>
        <datafield ind1="1" ind2="0" tag="245">
          <subfield code="a">ignore</subfield>
          <subfield code="h">[electronic resource] /</subfield>
          <subfield code="c">Department of Education.</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      expect(g.query(work_squery).size).to eq 1
      title_squery = SPARQL.parse(" PREFIX bf: <http://bibframe.org/vocab/>
                                    SELECT DISTINCT ?work
                                    WHERE {
                                      ?work a bf:Work .
                                      ?work bf:authorizedAccessPoint ?aap .
                                      FILTER regex(?aap, 'South Africa', 'i')
                                      FILTER regex(?aap, 'Department of Education', 'i')
                                      FILTER regex(?aap, 'Annual report', 'i')
                                    }")
      expect(g.query(title_squery).size).to eq 1
      work_title_squery = SPARQL.parse(work_title_sparql.sub('TITLE_REGEX', 'ignore'))
      expect(g.query(work_title_squery).size).to eq 0
      work_title_squery = SPARQL.parse(work_title_sparql.sub('TITLE_REGEX', 'electronic resource'))
      expect(g.query(work_title_squery).size).to eq 0
    end
    it '111 ‡a, ‡? and 240 ‡a has single work' do
      rec_id = '111a_240a_equal'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="2" ind2=" " tag="111">
          <subfield code="a">International Workshop on Faces.</subfield>
          <subfield code="?">UNAUTHORIZED</subfield>
        </datafield>
        <datafield ind1="1" ind2="0" tag="240">
          <subfield code="a">Proceedings (Online)</subfield>
        </datafield>
        <datafield ind1="1" ind2="0" tag="245">
          <subfield code="a">ignore a</subfield>
          <subfield code="h">[ignore h] /</subfield>
          <subfield code="c">ignore c</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      expect(g.query(work_squery).size).to eq 1
      title_squery = SPARQL.parse(" PREFIX bf: <http://bibframe.org/vocab/>
                                    SELECT DISTINCT ?work
                                    WHERE {
                                      ?work a bf:Work .
                                      ?work bf:authorizedAccessPoint ?aap .
                                      FILTER regex(?aap, 'International Workshop on Faces', 'i')
                                      FILTER regex(?aap, 'Proceedings', 'i')
                                    }")
      expect(g.query(title_squery).size).to eq 1
      work_title_squery = SPARQL.parse(work_title_sparql.sub('TITLE_REGEX', 'ignore'))
      expect(g.query(work_title_squery).size).to eq 0
    end
  end # context 1xx and 240

  # TODO:  what if 240 and no 1xx?

  context "100|110|111 and 245" do
    it '100 and 245' do
      fail 'test to be implemented'
    end
    it '110 and 245' do
      fail 'test to be implemented'
    end
    it '111 and 245' do
      # 5666387
      fail 'test to be implemented'
    end
  end # context 1xx and 245

  context "245 no 1xx" do

  end # context 245 no 1xx


end
