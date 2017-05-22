require 'spec_helper'

describe 'Title and subtitle from 245' do
  let!(:graph) {
    marcxml = '<?xml version="1.0" encoding="UTF-8"?>
    <collection xmlns="http://www.loc.gov/MARC21/slim">
    <record>
      <leader>01052cam a2200313 i 4500</leader>
      <controlfield tag="001">a10689710</controlfield>
      <controlfield tag="003">SIRSI</controlfield>
      <controlfield tag="005">20150708003002.0</controlfield>
      <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
      <datafield ind1="1" ind2="0" tag="245">
        <subfield code="a">Slippery noodles :</subfield>
        <subfield code="b">a culinary history of China /</subfield>
        <subfield code="c">Hsiang Ju Lin.</subfield>
      </datafield>
    </record>
    </collection>'
    self.send(MARC2BF_GRAPH_METHOD, marcxml, '245_subfield_a_title')
  }
  context '$a - Title', :bib2lod do
    it 'produces a bibk:Title' do
      # puts "#{graph.to_ttl}\n--"
      # puts "#{graph.query(TRIPLES_QUERY).to_tsv}"
      puts "#{graph.query(TITLE_PROPERTY_245_QUERY).to_tsv}"
      expect(graph.query(TITLE_PROPERTY_245_QUERY)).not_to be_empty
    end
    it 'has the literal "Slippery noodles :" as the rdfs:label property' do
      expect(graph.query(TITLE_PROPERTY_245_QUERY).to_tsv).to include("Slippery noodles :")
    end
    it 'has a bf:mainTitle property' do
      expect(graph.query(TITLE_PROPERTY_245_QUERY).to_tsv).to include("<http://bibliotek-o.org.org/ontology/MainTitleElement>")
    end
  end

  context '$b - subtitle', :bib2lod do
    it 'has a bf:subtitle from $b' do
      expect(graph.query(SUBTITLE_245_QUERY).to_tsv).to include("a culinary history of China ")
    end
    it 'has a bf:subtitle property' do
      expect(graph.query(SUBTITLE_245_QUERY).to_tsv).to include("<http://bibliotek-o.org.org/ontology/SubtitleElement>")
    end
  end

end

TITLE_PROPERTY_245_QUERY = SPARQL.parse("PREFIX bibk: <http://bibliotek-o.org/ontology/>
                                         PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                                         SELECT DISTINCT ?localUri ?property ?titleLiteral ?obj
                                         WHERE {
                                          {
                                            ?localUri a bibk:MainTitleElement .
                                            ?localUri ?property ?obj .
                                          } UNION {
                                              ?localUri rdfs:label 'a culinary history of China /'
                                            }
                                          }
                                         ")

SUBTITLE_245_QUERY = SPARQL.parse("PREFIX bibk: <http://bibliotek-o.org/ontology/>
                                   PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                                   SELECT DISTINCT ?localUri ?property ?titleLiteral ?obj
                                   WHERE {
                                    {
                                      ?localUri a bibk:SubtitleElement .
                                      ?localUri ?property ?obj .
                                    } UNION {
                                        ?localUri rdfs:label 'a culinary history of China /'
                                      }
                                    }
                                    ")
