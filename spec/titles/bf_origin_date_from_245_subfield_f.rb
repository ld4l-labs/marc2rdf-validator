require 'spec_helper'

# Fields 200-24X, except 240 - Other title fields - R1

describe 'bf:originDate from Title, 245 subfield f' do
  context '$f - Inclusive dates' do
    let!(:graph) {
      marcxml = '
      <record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>00956nam 2200229 4500</leader>
        <controlfield tag="001">catalogKeyID</controlfield>
        <controlfield tag="005">19911001004553.0</controlfield>
        <controlfield tag="007">hd-afa014bacu</controlfield>
        <controlfield tag="008">870616r19761854ctu a 000 0 eng d</controlfield>
          <datafield tag="245" ind1="1" ind2="0">
            <subfield code="a">Diaries,</subfield>
            <subfield code="f">1854-1921.</subfield>
            <subfield code="h">[Microform]</subfield>
          </datafield>
      </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml, '245_subfield_f_title')
    }
    it 'should have a "1854-1921" originDate literal', :bf2 do
      # puts "#{graph.to_ttl}\n--"
      # puts "#{graph.query(TRIPLES_QUERY).to_tsv}"
      expect(graph.query(ORIGIN_DATE_QUERY).to_tsv).to include('1854-1921')
    end
    it 'should be part of a bf:Work', :bf2 do
      expect(graph.query(ORIGIN_DATE_QUERY).to_tsv).to include('<http://ld4p.library.org/catalogKeyID>')
    end
    it 'should have a bf:originDate property', :bf2 do
      expect(graph.query(ORIGIN_DATE_QUERY).to_tsv).to include('<http://bibframe.org/vocab/originDate>')
    end
  end
end

ORIGIN_DATE_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                          SELECT DISTINCT ?workUri ?property ?dateLiteral
                                          WHERE {
                                            ?workUri ?property 'Diaries, 1854-1921. [Microform]Diaries,' .
                                            ?workUri bf:originDate ?dateLiteral .
                                            ?workUri a bf:Work
                                          }
                                         ")
