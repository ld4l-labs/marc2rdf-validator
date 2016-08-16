require 'spec_helper'
require 'linkeddata'

describe 'How 100, 700, 800 marc fields translate to a bf:Person' do
  context 'from MARC 100 (Main Entry - Perosnal Name)' do
    let!(:g) {
      marcxml_str =
      '<record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>01787cam a22004217a 4500</leader>
        <controlfield tag="001">15599751</controlfield>
        <controlfield tag="005">20120719124759.0</controlfield>
        <controlfield tag="008">090121s2009    xx a     b    001 0 eng d</controlfield>
        <datafield tag="100" ind1="1" ind2=" ">
          <subfield code="a">Rossi, Cesare.</subfield>
        </datafield>
      </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '100MainEntry')
    }
    it 'creates one person entity' do
      expect(g.query(PersonHelpers::PERSON_SPARQL_QUERY).size).to eq 1
    end
    it 'creates one authority' do
      expect(g.query(PersonHelpers::PERSON_AUTHORITY_SPARQL_QUERY).size).to eq 1
    end
  end

  context 'from MARC 700 (Added entry - Perosnal Name)' do
    let!(:g) {
      marcxml_str =
      '<record xmlns="http://www.loc.gov/MARC21/slim">
      <leader>01787cam a22004217a 4500</leader>
      <controlfield tag="001">15599751</controlfield>
      <controlfield tag="005">20120719124759.0</controlfield>
      <controlfield tag="008">090121s2009    xx a     b    001 0 eng d</controlfield>
        <datafield tag="700" ind1="1" ind2=" ">
          <subfield code="a">Russo, Flavio,</subfield>
          <subfield code="d">1947-</subfield>
        </datafield>
        <datafield tag="700" ind1="1" ind2=" ">
          <subfield code="a">Russo, Ferruccio,</subfield>
          <subfield code="d">1980-</subfield>
        </datafield>
      </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '700AddedEntry')
    }
    it 'creates two person entities' do
      expect(g.query(PersonHelpers::PERSON_SPARQL_QUERY).size).to eq 2
    end
    it 'creates two authorities' do
      expect(g.query(PersonHelpers::PERSON_AUTHORITY_SPARQL_QUERY).size).to eq 2
    end
  end
end
