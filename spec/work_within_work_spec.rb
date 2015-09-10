require 'spec_helper'
require 'linkeddata'

describe 'work within the work described by the MARC record' do

  # Stanford:
  # MARC fields that identify “a work within the described by the record”:
  # 505
  # 700-711 with ind2 = 2 and ‡t
  # 730|740 with ind2 = 2

  # marc2bibframe xquery converter
  # ???

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
  let(:main_part_work_sqy) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  SELECT DISTINCT ?mainwork ?workpart
                  WHERE {
                    ?mainwork a bf:Work .
                    ?mainwork bf:hasPart ?workpart .
                    ?workpart a bf:Work .
                  }") }

  context "505" do
    # ind1  0, 1, 2
    context "‡a (formatted contents note)" do
      context "ind1 0" do
        let(:g) {
          rec_id = '245only'
          marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
            '<datafield ind1="0" ind2=" " tag="505">
              <subfield code="a">Brahms.  Horn trio in E flat, op. 40.--Mozart.  Horn quintet in E flat, K. 407.--Marais, M. Le basque.</subfield>
            </datafield>
            <datafield ind1="0" ind2="0" tag="245">
              <subfield code="a">Dennis Brain:</subfield>
              <subfield code="b">The art of the French horn.</subfield>
              <subfield code="h">[Sound recording]</subfield>
            </datafield>
          </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
        }
        it '4 works' do
          expect(g.query(work_squery).size).to eq 4
          fail 'test to be implemented'
        end
        it 'main work hasPart to 505 works' do
          fail 'test to be implemented'
        end

      end
    end
    context "‡t (title)" do
      context "single ‡t" do

      end
      context "multiple ‡t" do

      end
    end
  end # 505

  context "700-711 with ind2 = 2 and ‡t" do

  end  # 700-711 with ind2 = 2 and ‡t

  context "730|740 with ind2 = 2" do
    context "730" do
      context "single 730 ind2 = 2" do
        let(:g) {
          rec_id = '245only'
          marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
            '<datafield ind1="0" ind2="2" tag="245">
              <subfield code="a">L\'homme de Rio /</subfield>
              <subfield code="c">Les Films Ariane et Les Productions Artistes Associés présentent.</subfield>
            </datafield>
            <datafield ind1="0" ind2="2" tag="730">
              <subfield code="i">Contains (work):</subfield>
              <subfield code="a">Adventurs d\'Adrien.</subfield>
              <subfield code="?">UNAUTHORIZED</subfield>
            </datafield>
          </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
        }
        it '2 works' do
          expect(g.query(work_squery).size).to eq 2
        end
        it 'main work hasPart to single 730 work' do
          expect(g.query(main_part_work_sqy).size).to eq 1
        end
      end # single 730

      context "multiple 730 ind2 = 2" do

      end # mult 730
      context "ind2 = other" do

      end
    end
    context "740" do

    end

  end # 730|740 with ind2 = 2

end