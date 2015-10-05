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

  context "700" do
    context "ind2 blank" do
      context "‡t" do
        let!(:g) {
          rec_id = '700_ind2_blank_t'
          marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
            '<datafield ind1="0" ind2="4" tag="245">
              <subfield code="a">The grapes of wrath</subfield>
              <subfield code="h">[videorecording] /</subfield>
              <subfield code="c">Twentieth Century-Fox presents Darryl F. Zanuck\'s production ; directed by John Ford ; screenplay by Nunnally Johnson.</subfield>
            </datafield>
            <datafield ind1="1" ind2=" " tag="700">
              <subfield code="a">Steinbeck, John,</subfield>
              <subfield code="d">1902-1968.</subfield>
              <subfield code="t">Grapes of wrath.</subfield>
              <subfield code="=">^A2091926</subfield>
            </datafield>
          </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
        }
        it '2 works' do
          expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
        end
        it 'main work relatedResource to 730 work' do
          solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
          expect(solns.size).to eq 1
          # as of 2015-09-16, LoC xquery code uses relatedResource but that is not in the RDF::Vocab::Bibframe
          #expect(solns.first.prop).to eq RDF::Vocab::Bibframe.relatedResource
          expect(solns.first.prop.to_s).to eq RDF::Vocab::Bibframe.to_s + "relatedResource"
        end
      end # ‡t
      it 'need example data mult 700 ind2 blank with ‡t' do
        fail 'need example data 700 ind2 blank with ‡t'
      end
      it 'need example data 700 ind2 blank without ‡t' do
        fail 'need example data 700 ind2 blank without ‡t'
      end
    end # ind2 blank
    it 'need tests for other ind2 values' do
      fail 'need example data 700 ind2 not 2 or blank'
      # for each ind2 value
      #  with t
      #  mult with t
      #  without t
    end
  end # 700

  context "710" do
    it 'need example 710 ind2 not 2' do
      fail 'need example 710 ind2 not 2'
      # for each ind2 value
      #  with t
      #  mult with t
      #  without t
    end
  end # 710

  context "711" do
    it 'need example 711 ind2 not 2' do
      fail 'need example 711 ind2 not 2'
      # for each ind2 value
      #  with t
      #  mult with t
      #  without t
    end
  end # 711

  context "730" do
    context "ind2 blank" do
      context "mult 730" do
        let!(:g) {
          rec_id = '730_ind2blank'
          marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
            '<datafield ind1="0" ind2="0" tag="245">
              <subfield code="a">Alfred Hitchcock, the masterpiece collection</subfield>
              <subfield code="h">[videorecording].</subfield>
            </datafield>
            <datafield ind1="0" ind2=" " tag="730">
              <subfield code="a">Rope (Motion picture)</subfield>
              <subfield code="=">^A3046122</subfield>
            </datafield>
            <datafield ind1="0" ind2=" " tag="730">
              <subfield code="a">Rear window (Motion picture)</subfield>
              <subfield code="=">^A1268811</subfield>
            </datafield>
          </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
        }
        it '2 works' do
          expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 3
        end
        it 'main work relatedResource to 730 work' do
          solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
          expect(solns.size).to eq 2
          solns.each { |soln|
            # as of 2015-09-16, LoC xquery code uses relatedResource but that is not in the RDF::Vocab::Bibframe
            #expect(solns.prop).to eq RDF::Vocab::Bibframe.relatedResource
            expect(soln.prop.to_s).to eq RDF::Vocab::Bibframe.to_s + "relatedResource"
          }
        end
      end
    end # ind2 blank

    it 'need tests for ind2 not 2 or blank' do
      fail 'need example data 730 ind2 not 2 or blank'
      # single 730 field and mult 730 fields
    end
    # NOTE:  ind2 = 2 is tested in work_with_work_spec
  end # 730

  context "740" do
    context "ind2=1" do
      let!(:g) {
        rec_id = '740ind2_1'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="1" ind2="4" tag="245">
            <subfield code="a">The grapes of wrath.</subfield>
          </datafield>
          <datafield ind1="0" ind2="1" tag="740">
            <subfield code="a">Screenplay collection.</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it '2 works' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
      end
      it 'main work relatedWork to 740 work' do
        expect_work2work_property(g, 1, RDF::Vocab::Bibframe.relatedWork)
      end
    end # ind2 = 1

    context "ind2 blank" do
      let!(:g) {
        rec_id = '740ind2blank'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="1" ind2="0" tag="245">
            <subfield code="a">Punno ŭi p\'odo =</subfield>
            <subfield code="b">The Grapes of wrath /</subfield>
            <subfield code="c">John E. Steinbeck ; Sisa Yŏngŏsa P\'yŏnjipkuk yŏk.</subfield>
          </datafield>
          <datafield ind1="0" ind2=" " tag="740">
            <subfield code="a">Grapes of wrath.</subfield>
          </datafield>
       </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it '2 works' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
      end
      it 'main work relatedWork to 740 work' do
        expect_work2work_property(g, 1, RDF::Vocab::Bibframe.relatedWork)
      end
    end # ind2 blank
    # NOTE:  ind2 = 2 is tested in work_with_work_spec
  end # 740

  context "76x-78x" do
    it 'need tests for 76x-78x' do
      fail 'need example data for 76x-78x'
    end
#     760 - Main Series Entry (R) Full | Concise
#762 - Subseries Entry (R) Full | Concise
#765 - Original Language Entry (R) Full | Concise
#767 - Translation Entry (R) Full | Concise
#770 - Supplement/Special Issue Entry (R) Full | Concise
#772 - Supplement Parent Entry (R) Full | Concise
#773 - Host Item Entry (R) Full | Concise
#774 - Constituent Unit Entry (R) Full | Concise
#775 - Other Edition Entry (R) Full | Concise
#776 - Additional Physical Form Entry (R) Full | Concise
#777 - Issued With Entry (R) Full | Concise
#780 - Preceding Entry (R) Full | Concise
#785 - Succeeding Entry (R) Full | Concise
#786 - Data Source Entry (R) Full | Concise
#787 - Other Relationship Entry (R) Full | Concise

  end # 76x-78x

  context "785" do
    context "ind2=0" do
      let!(:g) {
        rec_id = '785'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="0" ind2="0" tag="245">
            <subfield code="a">Computers and translation :</subfield>
            <subfield code="b">CaT.</subfield>
          </datafield>
          <datafield ind1="0" ind2="0" tag="785">
            <subfield code="t">Machine translation</subfield>
            <subfield code="x">0922-6567</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it '2 works' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
      end
      it 'main work continuedBy 785 work' do
        expect_work2work_property(g, 1, RDF::Vocab::Bibframe.continuedBy)
      end
    end # ind2 = 0
  end # 785

  context "79x" do
    it 'need tests for 79x' do
      fail 'need example data for 79x'
    end
  end # 79x
end
