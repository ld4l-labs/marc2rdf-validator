require 'spec_helper'
require 'linkeddata'

# X30, 240, etc. - Uniform titles - R1

describe 'bf:originDate from uniform title' do
  context '$f - Date of a work (NR)' do
    let!(:graph) {
      marcxml = '
      <record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>00956cam  22002291  4500</leader>
        <controlfield tag="001">catalogKeyID</controlfield>
        <controlfield tag="003">SIRSI</controlfield>
        <controlfield tag="005">19900711080830.0</controlfield>
        <controlfield tag="008">710426s1968    enk      b    000 0 eng</controlfield>
        <datafield tag="240" ind1="1" ind2="0">
          <subfield code="a">Works.</subfield>
          <subfield code="k">Selections.</subfield>
          <subfield code="l">English.</subfield>
          <subfield code="f">1968</subfield>
        </datafield>
      </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml, '240_subfield_f_uniform_title')
    }

    it 'should have a "1968" originDate literal', bf2: true do
      # puts "#{graph.to_ttl}\n--"
      # puts "\n#{graph.query(ORIGIN_DATE_QUERY).to_tsv}"
      expect(graph.query(ORIGIN_DATE_QUERY).to_tsv).to include('1968')
    end
    it 'should be part of a bf:Work', bf2: true do
      expect(graph.query(ORIGIN_DATE_QUERY).to_tsv).to include('<http://ld4p.library.org/catalogKeyID>')
    end
    it 'should have a bf:originDate property', bf2: true do
      expect(graph.query(ORIGIN_DATE_QUERY).to_tsv).to include('<http://bibframe.org/vocab/originDate>')
    end
  end
end

ORIGIN_DATE_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                          SELECT DISTINCT ?workUri ?property ?dateLiteral
                                          WHERE {
                                            ?workUri ?property 'Selections.' .
                                            ?workUri bf:formDesignation ?dateLiteral .
                                            ?workUri a bf:Work
                                          }
                                         ")
