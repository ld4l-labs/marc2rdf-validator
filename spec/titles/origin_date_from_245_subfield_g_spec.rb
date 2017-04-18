require 'spec_helper'

# Fields 200-24X, except 240 - Other title fields - R1

describe 'bf:originDate from Title, 245 subfield fg' do
  context '$g - Bulk dates', :bf do
    let!(:graph) {
      marcxml = '<record xmlns="http://www.loc.gov/MARC21/slim">
      <leader>00956ctc 2200229La 4500</leader>
      <controlfield tag="001">catalogKeyID</controlfield>
      <controlfield tag="008">030826i18791898xx 000 0 ger d</controlfield>
        <datafield tag="245" ind1="0" ind2="1">
          <subfield code="a">
            [Collection of theses and reprints on sense organs]
          </subfield>
          <subfield code="g">1879-1898</subfield>
          <subfield code="h">[manuscript/digital].</subfield>
        </datafield>
      </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml, '245_subfield_f_title')
    }
    it 'should have a "1879-1898" originDate literal'do
      # puts "#{graph.to_ttl}\n--"
      # puts "#{graph.query(TRIPLES_QUERY).to_tsv}"
      expect(graph.query(ORIGIN_DATE_245g_QUERY).to_tsv).to include('1879-1898')
    end
    it 'should be part of a bf:Work' do
      expect(graph.query(ORIGIN_DATE_245g_QUERY).to_tsv).to include('<http://ld4p.library.org/catalogKeyID>')
    end
    it 'should have a bf:originDate property' do
      expect(graph.query(ORIGIN_DATE_245g_QUERY).to_tsv).to include('<http://bibframe.org/vocab/originDate>')
    end
  end
end

ORIGIN_DATE_245g_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                          SELECT DISTINCT ?workUri ?property ?dateLiteral
                                          WHERE {
                                            ?workUri ?property '[Collection of theses and reprints on sense organs] 1879-1898 [manuscript/digital].[Collection of theses and reprints on sense organs]' .
                                            ?workUri bf:originDate ?dateLiteral .
                                            ?workUri a bf:Work
                                          }
                                         ")
