require 'spec_helper'
require 'linkeddata'

describe 'identifier of the work described by the MARC record' do

  # LD4All Sample MARC Test:
  # The identifier(s) generated for the Work described by a MARC record.
  #
  # identifier logic: 1. Uniform title as main entry, no agent name (130) ;
  #                  2. Uniform title as main entry, with or without agent name (240) ;
  #                  3. Transcribed main title, with or without agent name (245) .
  #
  # Test logic: 1. 

  # Variable for Basic Single Monograph, Text, English LDR, 008 fields with 001 == BIB record identifier
  let(:marc_ldr_001_008) {
    '<record xmlns="http://www.loc.gov/MARC21/slim">
      <leader>01033cam a22002891  4500</leader>
      <controlfield tag="001">RECORD_ID</controlfield>
      <controlfield tag="008">860506s1957    nyua     b    000 0 eng  </controlfield>'
  }
  # SPARQL Query for MainTitleElement instance (obl.: 1) of prefTitle of Work ;
  let!(:mainElemTitle_of_work_sparql_query) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  PREFIX dcterms: <http://purl.org/dc/terms/>
                  PREFIX ld4l: <http://bib.ld4l.org/ontology/>
                  PREFIX madsrdf: <http://www.loc.gov/mads/rdf/v1#>
                  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                  SELECT DISTINCT ?mainElemValue
                  WHERE {
                    ?work a bf:Work ;
                      ld4l:hasPreferredTitle ?title .
                    ?title a madsrdf:Title ;
                      dcterms:hasPart ?mainElem .
                    ?mainElem a madsrdf:MainTitleElement ;
                      rdfs:label ?mainElemValue .
                  }") }
  # SPARQL Query for TitleElement instances (obl.: 0,n) of prefTitle of Work ;
  # This presumes all non-MainTitleElement classes are subclasses of madsrdf:TitleElement & inference is in place.
  let!(:otherElemTitle_of_work_sparql_query) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  PREFIX dcterms: <http://purl.org/dc/terms/>
                  PREFIX ld4l: <http://bib.ld4l.org/ontology/>
                  PREFIX madsrdf: <http://www.loc.gov/mads/rdf/v1#>
                  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                  SELECT DISTINCT ?otherElemValue
                  WHERE {
                    ?work a bf:Work ;
                      ld4l:hasPreferredTitle ?title .
                    ?title a madsrdf:Title ;
                      dcterms:hasPart ?mainElem .
                    ?mainElem a madsrdf:TitleElement ;
                      rdfs:label ?otherElemValue .
                  }") }
  # SPARQL Query for NonSortElement instance (obl.: 0,1) of prefTitle of Work ;
  let!(:nonSortValue_of_work_sparql_query) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  PREFIX dcterms: <http://purl.org/dc/terms/>
                  PREFIX ld4l: <http://bib.ld4l.org/ontology/>
                  PREFIX madsrdf: <http://www.loc.gov/mads/rdf/v1#>
                  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                  SELECT DISTINCT ?nonSortValue
                  WHERE {
                    ?work a bf:Work ;
                      ld4l:hasPreferredTitle ?title .
                    ?title a madsrdf:Title ;
                      dcterms:hasPart ?subtitle .
                    ?subtitleElem a madsrdf:NonSortElement ;
                      rdfs:label ?nonSortValue ;
                  }") }
  # SPARQL Query for rdfs:label (obl: 1) of the prefTitle of the Work ;
  let!(:titleValue_of_work_sparql_query) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  PREFIX ld4l: <http://bib.ld4l.org/ontology/>
                  PREFIX madsrdf: <http://www.loc.gov/mads/rdf/v1#>
                  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                  SELECT DISTINCT ?titleValue
                  WHERE {
                    ?work a bf:Work ;
                      ld4l:hasPreferredTitle ?title .
                    ?title a madsrdf:Title ;
                      rdfs:label ?titleValue .
                  }") }
  # SPARQL Query for MainTitleElement (obl.: 1) of prefTitle of Instance ;
  let!(:mainElemValue_of_work_sparql_query) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  PREFIX dcterms: <http://purl.org/dc/terms/>
                  PREFIX ld4l: <http://bib.ld4l.org/ontology/>
                  PREFIX madsrdf: <http://www.loc.gov/mads/rdf/v1#>
                  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                  SELECT DISTINCT ?instTitleValue
                  WHERE {
                    ?in a bf:Instance ;
                      ld4l:hasPreferredTitle ?title .
                    ?title a madsrdf:Title ;
                      rdfs:label ?instTitleValue .
                  }") }


  context "130" do
    # 1. If there is a 130 present:
    context "‡a (+ 245) only" do
      # 1a. The *only* subfield ($a or $k) == MainTitleElement instance (obl.: 1) of prefTitle of Work ;
      let!(:g) {
        rec_id = '130a_only'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="0" ind2=" " tag="130">
            <subfield code="a">Beowulf.</subfield>
          </datafield>
          <datafield ind1="1" ind2="0" tag="245">
            <subfield code="a">IGNORE</subfield>
            <subfield code="c">IGNORE</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
      end
      it 'work title from 130' do
        resps = g.query(mainElemTitle_of_work_sparql_query)
        expect(resps.size).to eq 1
        title_value = resps.first.mainElemValue.to_s
        expect(title_value).to match(/Beowulf/)
        expect(title_value).not_to match(/IGNORE/)
      end
    end

    context "‡a, ‡l, ‡s, ‡f, ‡= (+ 245) only" do
      # 1a. The *first* subfield ($a or $k) == MainTitleElement instance (obl.: 1) of prefTitle of Work ;
      let!(:g) {
        rec_id = '130a_first'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="0" ind2=" " tag="130">
            <subfield code="a">Beowulf</subfield>
            <subfield code="l">IGNORE</subfield>
            <subfield code="s">IGNORE</subfield>
            <subfield code="f">IGNORE</subfield>
            <subfield code="=">IGNORE</subfield>
           </datafield>
           <datafield ind1="0" ind2="0" tag="245">
            <subfield code="a">IGNORE</subfield>
            <subfield code="b">IGNORE</subfield>
            <subfield code="c">IGNORE</subfield>
           </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
      end
      it 'work title from 130' do
        resps = g.query(mainElemTitle_of_work_sparql_query)
        expect(resps.size).to eq 1
        title_value = resps.first.mainElemValue.to_s
        expect(title_value).to match(/Beowulf/)
        expect(title_value).not_to match(/IGNORE/)
      end
    end

    context "‡l, ‡s, ‡f, ‡= (+ 245) only" do
      # 1b. The second (or other) subfield(s) == TitleElement instances (obl.: 0,n) of prefTitle of Work ;
      let!(:g) {
        rec_id = '130_lsfeq'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="0" ind2=" " tag="130">
          <subfield code="a">Beowulf</subfield>
          <subfield code="l">Danish &amp; Anglo-Saxon.</subfield>
          <subfield code="s">Schaldemose.</subfield>
          <subfield code="f">1847.</subfield>
          <subfield code="=">^A944917</subfield>
         </datafield>
         <datafield ind1="0" ind2="0" tag="245">
          <subfield code="a">IGNORE</subfield>
          <subfield code="b">IGNORE</subfield>
          <subfield code="c">IGNORE</subfield>
         </datafield>
      </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
      end
      it 'work title from 130' do
        resps = g.query(otherElemTitle_of_work_sparql_query)
        expect(resps.size).to eq 5
        # Need to fix following to loop through SPARQL query results.
        title_value = resps.first.otherElemValue.to_s
        expect(title_value).to match(/Danish|Schaldemose|1847|944917/)
        expect(title_value).not_to match(/IGNORE|Beowulf/)
      end
    end

    it 'capture 130 ind1 (non-filing chars) in nonSort' do
      # 1c. The first indicator (when exists and != 0) == NonSortElement (obl.: 0,1) instance of prefTitle of Work ;
      rec_id = '130_ind1'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="1" ind2=" " tag="130">
           <subfield code="a">Lid un tfile.</subfield>
         </datafield>
         <datafield ind1="1" ind2="0" tag="245">
           <subfield code="6">IGNORE</subfield>
           <subfield code="a">IGNORE</subfield>
           <subfield code="c">IGNORE</subfield>
         </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      resps = g.query(nonSortValue_of_work_sparql_query)
      expect(resps.size).to eq 1
      title_value = resps.first.nonSortValue.to_s
      expect(title_value).to match(/^L$/)
      expect(title_value).not_to match(/IGNORE|un tfile/)
    end

    #   1d. (to be improved) The first (or only) subfield ($a or $k) appears in the rdfs:label (obl: 1) of the prefTitle of the Work ;
    #   1e. 245 first (or only) subfield ($a or $k) is in the rdfs:label of prefTitle of Instance ;
    #   1f. Mapping of other 130 subfields to be added later to tests.
  end # context 130

  context "240 only" do
  # 2. If there is a 240 present (there should never be both a 130 and a 240):
    # 1a. The first (or only) subfield ($a or $k) == MainTitleElement instance (obl.: 1) of prefTitle of Work ;
    # 1b. The second (or other) subfield(s) == TitleElement instances (obl.: 0,n) of prefTitle of Work ;
    # 1c. The second indicator (when exists and != 0) == NonSortElement (obl.: 0,1) instance of prefTitle of Work ;
    # 1d. (to be improved) The first (or only) subfield ($a or $k) appears in the rdfs:label (obl: 1) of the prefTitle of the Work ;
    # 1e. 245 first (or only) subfield ($a or $k) is in the rdfs:label of prefTitle of Instance ;
    # 1f. Mapping of other 240 subfields to be added later to tests.
  end # only 240
end