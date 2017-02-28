require 'spec_helper'

# Fields 200-24X, except 240 - Other title fields - R1

describe 'bf:responsibilityStatement(as bf:Instance) from 245, 246' do
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
      <datafield ind1=" " ind2="1" tag="264">
        <subfield code="a">London :</subfield>
        <subfield code="b">Prospect Books,</subfield>
        <subfield code="c">2015.</subfield>
      </datafield>
    </record>'
    self.send(MARC2BF_GRAPH_METHOD, marcxml, '245_subfield_c_subtitle')
  }
  context '$a, $b, $c - Statement of Responsibility' do
    it 'produces a bf:Instance', :bf2 do
      # puts "#{graph.to_ttl}\n--"
      # puts "#{graph.query(TRIPLES_QUERY).to_tsv}"
      expect(graph.query(RESPONSIBILITY_QUERY)).not_to be_empty
    end
    it 'produces a bf:responsibilityStatement literal', :bf2 do
      expect(graph.query(RESPONSIBILITY_QUERY).to_tsv).to include("Slippery noodles : a culinary history of China / Hsiang Ju Lin.")
    end
    it 'has a bf:responsibilityStatement property', :bf2 do
      expect(graph.query(RESPONSIBILITY_QUERY).to_tsv).to include("<http://bibframe.org/vocab/responsibilityStatement>")
    end
  end
end

RESPONSIBILITY_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                         SELECT DISTINCT ?localUri ?property ?titleLiteral
                                         WHERE {
                                            {
                                              ?localUri ?property 'Slippery noodles : a culinary history of China / Hsiang Ju Lin.' .
                                              ?localUri bf:responsibilityStatement ?titleLiteral
                                            } UNION {
                                              ?localUri a bf:Instance
                                            }
                                           }
                                        ")
