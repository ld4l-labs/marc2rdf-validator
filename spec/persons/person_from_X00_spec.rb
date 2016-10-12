require 'spec_helper'
require 'linkeddata'
require 'rdf'

describe 'How 100, 700, 800 marc fields translate to a bf:Person' do

  let(:main_entry) { File.read(File.join("spec", "fixtures", "persons", "100MainEntry.xml")) }
  let(:added_entry) { File.read(File.join("spec", "fixtures", "persons", "700AddedEntry.xml")) }

  context 'from MARC 100 (Main Entry - Perosnal Name)' do
    let!(:g) {
      self.send(MARC2BF_GRAPH_METHOD, main_entry, '100MainEntry')
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
      self.send(MARC2BF_GRAPH_METHOD, added_entry, '700AddedEntry')
    }
    it 'creates two person entities' do
      expect(g.query(PersonHelpers::PERSON_SPARQL_QUERY).size).to eq 2
    end
    it 'creates two authorities' do
      expect(g.query(PersonHelpers::PERSON_AUTHORITY_SPARQL_QUERY).size).to eq 2
    end
  end
end
