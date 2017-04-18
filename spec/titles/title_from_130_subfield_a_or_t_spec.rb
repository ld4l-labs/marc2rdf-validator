require 'spec_helper'

# X30, 240, etc. - Uniform titles - R1

describe 'bf:title from uniform title, 130 subfield a' do
  context '$a Uniform title (NR)', :bf do
    let!(:graph) {
      marcxml =
      '<record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>01033cam a22002891  4500</leader>
        <controlfield tag="001">130a_only</controlfield>
        <controlfield tag="008">860506s1957    nyua     b    000 0 eng  </controlfield>
        <datafield ind1="0" ind2=" " tag="130">
          <subfield code="a">Beowulf.</subfield>
        </datafield>
        <datafield ind1="1" ind2="0" tag="245">
          <subfield code="a">IGNORE</subfield>
          <subfield code="c">IGNORE</subfield>
        </datafield>
      </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml, '130_subfield_a_uniform_title')
    }

    it 'should have a literal "Beowulf."' do
      # puts "#{graph.to_ttl}\n--"
      # puts "#{graph.query(TRIPLES_QUERY).to_tsv}"
      expect(graph.query(TitleHelpers::TITLE_PROPERTY_QUERY).to_tsv).to include("Beowulf.")
    end
    it 'should have a bf:mainTitle property' do
      expect(graph.query(TitleHelpers::TITLE_PROPERTY_QUERY).to_tsv).to include("<http://bibframe.org/vocab/mainTitle>")
    end
  end

  context '$t Uniform title (NR)', :bf do
    let!(:graph) {
      marcxml =
      '<record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>01033cam a22002891  4500</leader>
        <controlfield tag="001">130a_only</controlfield>
        <controlfield tag="008">860506s1957    nyua     b    000 0 eng  </controlfield>
        <datafield ind1="0" ind2=" " tag="130">
          <subfield code="a">Beowulf.</subfield>
        </datafield>
        <datafield ind1="1" ind2="0" tag="245">
          <subfield code="a">IGNORE</subfield>
          <subfield code="c">IGNORE</subfield>
        </datafield>
      </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml, '130_subfield_a_uniform_title')
    }

    it 'should have a literal "Beowulf."' do
      # puts "#{graph.to_ttl}\n--"
      # puts "#{graph.query(TRIPLES_QUERY).to_tsv}"
      expect(graph.query(TitleHelpers::TITLE_PROPERTY_130_QUERY).to_tsv).to include("Beowulf.")
    end
    it 'should have a bf:mainTitle property' do
      expect(graph.query(TitleHelpers::TITLE_PROPERTY_130_QUERY).to_tsv).to include("<http://bibframe.org/vocab/mainTitle>")
    end
  end
end

TITLE_PROPERTY_130_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                          SELECT DISTINCT ?localUri ?property ?titleLiteral
                                          WHERE {
                                            ?localUri ?property 'Beowulf.' .
                                            ?localUri bf:title ?titleLiteral
                                          }
                                         ")
