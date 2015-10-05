require 'spec_helper'
require 'linkeddata'

describe 'bf:Person from MARC 100 (Main Entry - Perosnal Name)' do
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
    self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '100mainEntry')
  }
  it 'creates one person entity' do
    expect(g.query(PersonHelpers::PERSON_SPARQL_QUERY).size).to eq 1
  end
  it 'creates one authority' do
    expect(g.query(PersonHelpers::PERSON_AUTHORITY_SPARQL_QUERY).size).to eq 1
  end
end
