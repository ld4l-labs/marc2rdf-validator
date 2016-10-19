require 'spec_helper'
require 'linkeddata'

describe 'identifier of the work described by the MARC record' do

  # LD4All Sample MARC Test:
  # The identifier(s) generated for the Work described by a MARC record.
  # In progress. A lot of this will be transferred to bf:Instance level testing.
  #
  # identifier logic: 1. Main ILS Identifier for Work - 001 ;
  #                  2. Uniform title as main entry, with or without agent name (240) ;
  #                  3. Transcribed main title, with or without agent name (245) .
  #
  # Test logic: 1. Should always be a 001
  #             2. If 001 and single 035a and they match:
  #                2a. Should be 1 ILS identifier for Work.
  #             3. If 001 and multiple 035 and there is 1 001 - 035a match:
  #                3a. Should be multiple ILS identifiers for Work, but at least 1 with 001/matching 035 value with appropriate source value
  #                3b. Should be other ILS identifiers for Work but source value varies (non-matching 035s)
  #             4. 001 and multiple 035 but none match 001:
  #                4a. Should be 1 ILS identifier for Work with appropriate source and equals 001.
  #                4b. Should be other ILS identifiers for Work but source value varies (non-matching 035s)
  #             5. Other identifiers (to be added):
  #                5a. ISSNs?
  #                5b. CODENs?
  #                5c. Fingerprint?
  #                5d. Push back to Alignment group: what identifiers should we expect on bf:Work?

  # Variable for Basic Single Monograph, Text, English LDR, 008 fields with 001 == BIB record identifier
  let(:marc_ldr_001_008) {
    '<record xmlns="http://www.loc.gov/MARC21/slim">
      <leader>01033cam a22002891  4500</leader>
      <controlfield tag="001">RECORD_ID</controlfield>
      <controlfield tag="008">860506s1957    nyua     b    000 0 eng  </controlfield>'
  }
  # SPARQL Query for MainTitleElement instance (obl.: 1) of prefTitle of Work ;
  let!(:ilsIdentifier_of_work_sparql_query) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  PREFIX dcterms: <http://purl.org/dc/terms/>
                  PREFIX ld4l: <http://bib.ld4l.org/ontology/>
                  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                  SELECT DISTINCT ?ilsIDvalue
                  WHERE {
                    ?work a bf:Work ;
                      ld4l:identifiedBy ?ilsID .
                    ?ilsID a ld4l:IlsIdentifier ;
                      rdfs:value ?ilsIDvalue ;
                      bf:source ?Institution .
                  }") }


  context "001" do
    # 1. If there is a 001 present:
    context "(+ 035) matches" do
      # 1a. The 001 exits and 035a matches
      let!(:g) {
        rec_id = '001_035a_matches'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<controlfield tag="001">RECORD_ID</controlfield>
          <datafield ind1="1" ind2="0" tag="035">
            <subfield code="a">RECORD_ID</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
      end
      it 'work ils identifier from 001' do
        resps = g.query(ilsIdentifier_of_work_sparql_query)
        expect(resps.size).to eq 1
        ilsID_value = resps.first.ilsIDvalue.to_s
        expect(ilsID_value).to match(/RECORD_ID/)
      end
    end
  end
end