require 'spec_helper'

describe 'bf:responsibilityStatement from 245, 246' do
  let!(:graph) {
    # Minimal MARC record. Cornell ILS requires only that a record have an
    #   identifier (001), a LDR (which can have everything marked ‘no attempt to code’),
    #   a 008 (ditto), and a title (130, 240, or 245).
    marcxml = '<?xml version="1.0" encoding="UTF-8"?>
    <collection xmlns="http://www.loc.gov/MARC21/slim">
      <record>
        <leader>01050cam a22003011  4500</leader>
        <controlfield tag="001">102063</controlfield>
        <controlfield tag="008">860506s1957    nyua     b    000 0 eng  </controlfield>
        <datafield tag="245" ind1="0" ind2="0">
          <subfield code="a">Clinical cardiopulmonary physiology.</subfield>
          <subfield code="c">Sponsored by the American College of Chest Physicians.  Editorial board: Burgess L. Gordon, chairman, editor-in-chief, Albert H. Andrews [and others]</subfield>
        </datafield>
      </record>
    </collection>'
    self.send(MARC2BF_GRAPH_METHOD, marcxml, '245_subfield_c_subtitle')
  }
  context '$a, $b, $c - Statement of Responsibility', :m2bf2, :bib2lod do
    it 'produces a bf2:responsibilityStatement' do
      # puts "#{graph.to_ttl}\n--"
      # puts "#{graph.query(TRIPLES_QUERY).to_tsv}"
      puts "#{graph.query(RESPONSIBILITY_QUERY).to_tsv}"
      expect(graph.query(RESPONSIBILITY_QUERY)).not_to be_empty
    end
    it 'produces part of a bf2:responsibilityStatement from the subfield $a' do
      expect(graph.query(RESPONSIBILITY_QUERY).to_tsv).to include("Clinical cardiopulmonary physiology.")
    end
    it 'produces part of a bf2:responsibilityStatement from the subfield $c' do
      expect(graph.query(RESPONSIBILITY_QUERY).to_tsv).to include("Sponsored by the American College of Chest Physicians.  Editorial board: Burgess L. Gordon, chairman, editor-in-chief, Albert H. Andrews [and others]")
    end
    it 'has a bf:responsibilityStatement property' do
      expect(graph.query(RESPONSIBILITY_QUERY).to_tsv).to include("<http://id.loc.gov/ontologies/bibframe/responsibilityStatement>")
    end
  end
end

RESPONSIBILITY_QUERY = SPARQL.parse("PREFIX bf2: <http://id.loc.gov/ontologies/bibframe/>
                                     PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                                         SELECT ?localUri ?property ?titleLiteral
                                         WHERE {
                                          {
                                              ?localUri ?property ?titleLiteral .
                                              ?localUri bf2:responsibilityStatement ?titleLiteral
                                            } UNION {
                                              ?localUri rdfs:label ?titleLiteral .
                                            }
                                          }
                                        ")
