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
  let(:work_relatedWork_work_sparql_query) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  SELECT DISTINCT ?mainwork ?relwork
                  WHERE {
                    ?mainwork a bf:Work .
                    ?mainwork bf:relatedWork ?relwork .
                    ?relwork a bf:Work .
                  }") }
  let(:work_subPropOf_relatedWork_work_sparql_query) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                  SELECT DISTINCT ?mainwork ?prop ?relwork
                  WHERE {
                    ?mainwork a bf:Work .
                    ?mainwork ?prop ?relwork .
                    ?relwork a bf:Work .
                    ?prop rdfs:subPropertyOf* bf:relatedWork .
                  }") }
  let(:work_prop_work_sparql_query) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  SELECT DISTINCT ?mainwork ?prop ?relwork
                  WHERE {
                    ?mainwork a bf:Work .
                    ?mainwork ?prop ?relwork .
                    ?relwork a bf:Work .
                  }") }

  context "700" do

  end # 700

  context "710" do

  end # 710

  context "711" do

  end # 711

  context "730" do

  end # 730

  context "740" do
    context "ind2 = 1" do
      let(:g) {
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
        expect(g.query(work_sparql_query).size).to eq 2
      end
      it 'property between works' do
        solns = g.query(work_prop_work_sparql_query)
        expect(solns.size).to eq 1
        property = solns.first.prop.to_s
        expect(property).to eq "http://bibframe.org/vocab/continuedBy"
      end
      it '1 related work' do
        expect(g.query(work_subPropOf_relatedWork_work_sparql_query).size).to eq 1
      end
    end # ind2 = 1

    context "ind2 blank" do
      let(:g) {
        rec_id = '740ind2blank'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="1" ind2="0" tag="245">
            <subfield code="6">880-01</subfield>
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
        expect(g.query(work_sparql_query).size).to eq 2
      end
      it 'property between works' do
        solns = g.query(work_prop_work_sparql_query)
        expect(solns.size).to eq 1
        property = solns.first.prop.to_s
        expect(property).to eq "http://bibframe.org/vocab/continuedBy"
      end
      it '1 related work' do
        expect(g.query(work_relatedWork_work_sparql_query).size).to eq 1
        squery = SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                              PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                              SELECT *
                              WHERE {
                    ?mainwork a bf:Work .
                    ?mainwork ?prop ?relwork .
                    ?relwork a bf:Work .
                              }")
        solns = g.query(squery)
        squery = SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                              PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                              SELECT *
                              WHERE {
                                ?prop rdfs:subPropertyOf ?foo
                              }")
        solns = g.query(squery)
        expect(solns.size).to eq 1
      end
    end # ind2 blank
    context "ind2 = 2" do
      let(:g) {
        rec_id = '740ind2_2'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="1" ind2="0" tag="245">
            <subfield code="a">Fancher Creek ranch, property of James Karnes, Fresno Co.</subfield>
            <subfield code="h">[electronic resource] ;</subfield>
            <subfield code="b">Home ranch &amp; residence of James Karnes, 3 miles S. of Sanger.</subfield>
          </datafield>
          <datafield ind1="0" ind2="2" tag="740">
            <subfield code="a">Home ranch &amp; residence of James Karnes, 3 miles S. of Sanger.</subfield>
          </datafield>
       </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it '2 works' do
puts g.to_ttl
        expect(g.query(work_sparql_query).size).to eq 2
      end
      it 'partOf property' do
        solns = g.query(work_prop_work_sparql_query)
        expect(solns.size).to eq 1
        property = solns.first.prop.to_s
        expect(property).to eq "http://bibframe.org/vocab/partOf"
      end
      it '0 related works' do
        expect(g.query(work_relatedWork_work_sparql_query).size).to eq 1
      end
    end # ind2 = 2
  end # 740

  context "76x-78x" do
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

  context "785 - continuedBy" do
    let(:g) {
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
      expect(g.query(work_sparql_query).size).to eq 2
    end
    it 'property between works' do
      solns = g.query(work_prop_work_sparql_query)
      expect(solns.size).to eq 1
      property = solns.first.prop.to_s
      expect(property).to eq "http://bibframe.org/vocab/continuedBy"
    end
  end # 785

  context "79x" do

  end # 79x
end