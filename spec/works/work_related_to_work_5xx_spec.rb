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
    context "electronic repro" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">533works</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">Expert podcasting practices for dummies</subfield>
              <subfield code="h">[electronic resource] /</subfield>
              <subfield code="c">by Tee Morris, Evo Terra, and Ryan Williams.</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="533">
              <subfield code="a">Electronic reproduction.</subfield>
              <subfield code="b">Boston, Mass. :</subfield>
              <subfield code="c">Safari Books Online,</subfield>
              <subfield code="d">2008.</subfield>
              <subfield code="n">Mode of access:  World Wide Web.</subfield>
              <subfield code="n">Available to subscribing institutions.</subfield>
              <subfield code="7">s2008    maun s</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '533works')
      }
      it '2 Works' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
      end
      it 'main Work reproduction of 533 work' do
          solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.prop).to eq RDF::Vocab::Bibframe.reproduction
      end
    end # electronic repro
    context "serial" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01384cas a22003377a 4500</leader>
            <controlfield tag="001">533combo_260_300_serial</controlfield>
            <controlfield tag="008">951215c19uu9999bt ar   b    f0    0eng  </controlfield>
            <datafield tag="245" ind1="1" ind2="0">
              <subfield code="a">`Budget estimates for fiscal year ...</subfield>
              <subfield code="h">[microform] :</subfield>
              <subfield code="b">Ministry of Health &amp; Education.</subfield>
            </datafield>
            <datafield tag="533" ind1=" " ind2=" ">
              <subfield code="a">Microfiche.</subfield>
              <subfield code="m">1994/95-</subfield>
              <subfield code="b">New Delhi :</subfield>
              <subfield code="c">Library of Congress Office ;</subfield>
              <subfield code="b">Washington, D.C. :</subfield>
              <subfield code="c">Library of Congress Photoduplication Service,</subfield>
              <subfield code="d">1995-</subfield>
              <subfield code="e">microfiches.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '533combo_260_300_serial')
      }
      it '2 Works' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
      end
      it 'main Work reproduction of 533 work' do
          solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.prop).to eq RDF::Vocab::Bibframe.reproduction
      end
    end # serial
    context "recording" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01779cim a2200373 a 4500</leader>
            <controlfield tag="001">533combo_260_300_recording</controlfield>
            <controlfield tag="008">931119s1958    dcunnn         f    eng  </controlfield>
            <datafield tag="245" ind1="1" ind2="0">
              <subfield code="a">Eudora Welty reading three of her short stories</subfield>
              <subfield code="h">[sound recording].</subfield>
            </datafield>
            <datafield tag="533" ind1=" " ind2=" ">
              <subfield code="a">Preservation master.</subfield>
              <subfield code="b">Washington, D.C. :</subfield>
              <subfield code="c">Library of Congress Magnetic Recording Laboratory,</subfield>
              <subfield code="d">1973.</subfield>
              <subfield code="e">1 sound tape reel : analog, 7 1/2 ips, 2 track, mono. ; 10 in.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '533combo_260_300_recording')
      }
      it '2 Works' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
      end
      it 'main Work reproduction of 533 work' do
          solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.prop).to eq RDF::Vocab::Bibframe.reproduction
      end
    end # recording
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