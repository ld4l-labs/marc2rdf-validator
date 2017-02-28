require 'spec_helper'

# Fields 200-24X, except 240 - Other title fields - R1

describe 'bf:Title from 245' do
  let!(:graph) {
    marcxml = '<record xmlns="http://www.loc.gov/MARC21/slim">
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
    </record>'
    self.send(MARC2BF_GRAPH_METHOD, marcxml, '245_subfield_a_title')
  }
  context '$a - Title' do
    it 'produces a bibframe:Title', :bf2 do
      # puts "#{graph.to_ttl}\n--"
      # puts "#{graph.query(TRIPLES_QUERY).to_tsv}"
      expect(graph.query(TITLE_PROPERTY_QUERY)).not_to be_empty
    end
    it 'has the literal "Slippery noodles :" as the bf:mainTitle property', :bf2 do
      expect(graph.query(TITLE_PROPERTY_QUERY).to_tsv).to include("Slippery noodles :")
    end
    it 'has a bf:mainTitle property', :bf2 do
      expect(graph.query(TITLE_PROPERTY_QUERY).to_tsv).to include("<http://bibframe.org/vocab/mainTitle>")
    end
  end
  context '$b - subtitle' do
    it 'has a bf:subtitle from $b', :bf2 do
      expect(graph.query(SUBTITLE_QUERY).to_tsv).to include("a culinary history of China ")
    end
    it 'has a bf:subtitle property', :bf2 do
      expect(graph.query(SUBTITLE_QUERY).to_tsv).to include("<http://bibframe.org/vocab/subtitle>")
    end
  end
end

TITLE_PROPERTY_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                          SELECT DISTINCT ?localUri ?property ?titleLiteral
                                          WHERE {
                                            {
                                              ?localUri ?property 'Slippery noodles :' .
                                              ?localUri bf:titleValue ?titleLiteral
                                            } UNION {
                                              ?localUri a bf:Title
                                            }
                                          }
                                         ")

SUBTITLE_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                         SELECT DISTINCT ?localUri ?property ?titleLiteral
                                         WHERE {
                                              ?localUri ?property 'a culinary history of China ' .
                                              ?localUri bf:subtitle ?titleLiteral
                                           }
                                        ")
