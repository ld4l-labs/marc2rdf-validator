require 'spec_helper'

# Fields 200-24X, except 240 - Other title fields - R1

describe 'bf:genreForm from Title, 245 subfield h' do
  context '$h - Medium', :bf do
    let!(:graph) {
      marcxml = '<record xmlns="http://www.loc.gov/MARC21/slim">
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
      self.send(MARC2BF_GRAPH_METHOD, marcxml, '245_subfield_h_title')
    }
    it 'should have a "Microform" genreForm label' do
      # puts "#{graph.to_ttl}\n--"
      # puts "#{graph.query(TRIPLES_QUERY).to_tsv}"
      puts "#{graph.query(GENRE_FORM_245_QUERY).to_tsv}"
      expect(graph.query(GENRE_FORM_245_QUERY).to_tsv).to include('Microform')
    end
    it 'should be part of a bf:Work' do
      expect(graph.query(GENRE_FORM_245_QUERY).to_tsv).to include('<http://ld4p.library.org/catalogKeyID#Work>')
    end
    it 'should have a bf:genreForm property' do
      expect(graph.query(GENRE_FORM_245_QUERY).to_tsv).to include('<http://id.loc.gov/ontologies/bibframe/genreForm>')
    end
  end
end

GENRE_FORM_245_QUERY = SPARQL.parse("PREFIX bf2: <http://id.loc.gov/ontologies/bibframe/>
                                    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                                          SELECT DISTINCT ?workUri ?property ?obj ?label
                                          WHERE {
                                            ?workUri a bf2:Work;
                                              a bf2:Text .
                                            ?workUri ?property ?obj .
                                            ?workUri rdfs:label 'Diaries, 1854-1921.' .
                                            ?obj rdfs:label ?label
                                          }
                                         ")
