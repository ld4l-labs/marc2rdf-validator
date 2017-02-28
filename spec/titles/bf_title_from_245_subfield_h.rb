require 'spec_helper'

# Fields 200-24X, except 240 - Other title fields - R1

describe 'bf:Title from 245' do
  let!(:graph) {
    marcxml = '<record xmlns="http://www.loc.gov/MARC21/slim">
    <leader>00956cam  2200229Li 4500</leader>
    <controlfield tag="001">a11936980</controlfield>
    <controlfield tag="008">080529s2008    enk     s     000 0 eng d</controlfield>
    <datafield tag="245" ind1="0" ind2="0">
      <subfield code="a">Emerging issues and new pharmacologic options for P2Y 12 inhibition in acute coronary syndromes</subfield>
      <subfield code="h">[digital]  /</subfield>
      <subfield code="c">ed. by L. Wallentin.</subfield>
    </datafield>
    <datafield tag="260" ind1=" " ind2=" ">
      <subfield code="a">Oxford :</subfield>
      <subfield code="b">Oxford University Press;</subfield>
      <subfield code="a">Avenel, NJ :</subfield>
      <subfield code="b">Distributed by Mercury International,</subfield>
      <subfield code="c">2008.</subfield>
    </datafield>
  </record>'
    self.send(MARC2BF_GRAPH_METHOD, marcxml, '245_subfield_h_medium')
  }
  context '$h - genreForm' do
    it 'produces "electronic resource" as a genreForm literal', :bf2 do
      # puts "#{graph.to_ttl}"
      # puts "#{graph.query(TRIPLES_QUERY).to_tsv}"
      expect(graph.query(GENRE_FORM_QUERY).to_tsv).to include("<http://bibframe.org/vocab/genreForm>")
    end
    it 'needs more tests pending bf2 converter', :bf2 do
      pending('pending bf2 converter')
    end
  end
end

GENRE_FORM_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                          SELECT DISTINCT ?localUri ?property ?literal
                                          WHERE {
                                            {
                                              ?localUri ?property 'electronic resource' .
                                              ?localUri bf:genreForm ?literal
                                            } UNION {
                                              ?localUri a bf:Work
                                            }
                                          }
                                         ")
