require 'spec_helper'
require 'linkeddata'

describe 'work' do
  let(:work_uri_sparql_query) {
    SPARQL.parse("
      PREFIX bf: <http://bibframe.org/vocab/>
      SELECT *
      WHERE { ?work a bf:Work } ")
  }

  describe "297984" do
    let(:repo297984) { RDF::Repository.load('spec/fixtures/297984.ttl') }
    let(:work_solns) { repo297984.query(work_uri_sparql_query) }

    it 'at least 4 works' do
      expect(work_solns.size).to be >= 4
    end

    it 'works are uris' do
      work_solns.each { |soln|
        expect(soln.work.uri?).to be true
      }
    end

    let(:brain_art_of_horn_work_query) {
      # bib record work:  Dennis Brain _The art of the French horn_  BBC LP, reissued Everest 1978
      # ideally, would also find 'BBC' '1956' and '1957' somewhere as those are orig recording info
      SPARQL.parse("
        PREFIX bf: <http://bibframe.org/vocab/>
        SELECT *
        WHERE {
          ?work a bf:Work .
          ?work bf:authorizedAccessPoint ?aap .
          FILTER regex(?aap, 'Dennis Brain', 'i')
          FILTER regex(?aap, 'The art of the French Horn', 'i')
        }
      ")
    }
    it 'Brain Art of the French Horn' do
      # bib record work:  Dennis Brain _The art of the French horn_  BBC LP, reissued Everest 1978
      expect(repo297984.query(brain_art_of_horn_work_query).size).to eq 1
    end

    let(:brahms_trio_work_query) {
      SPARQL.parse("
        PREFIX bf: <http://bibframe.org/vocab/>
        SELECT *
        WHERE {
          ?work a bf:Work .
          ?work bf:authorizedAccessPoint ?aap .
          FILTER regex(?aap, 'Brahms', 'i')
          FILTER regex(?aap, 'Trio', 'i')
          FILTER regex(?aap, '40')
        }
      ")
    }
    it 'Brahms Trio' do
      # 700 work: Brahms, trio op 40 for horn, violin and piano
      expect(repo297984.query(brahms_trio_work_query).size).to eq 1
    end

    let(:mozart_quintet_work_query) {
      SPARQL.parse("
        PREFIX bf: <http://bibframe.org/vocab/>
        SELECT *
        WHERE {
          ?work a bf:Work .
          ?work bf:authorizedAccessPoint ?aap .
          FILTER regex(?aap, 'Mozart', 'i')
          FILTER regex(?aap, 'Quintet', 'i')
          FILTER regex(?aap, 'K.? ?407')
        }
      ")
    }
    it 'Mozart Quintet' do
      # 700 work: Mozart, quintet K.407 Bor horn, violin, 2 violas and cello
      expect(repo297984.query(mozart_quintet_work_query).size).to eq 1
    end

    let(:marais_pieces_work_query) {
      SPARQL.parse("
        PREFIX bf: <http://bibframe.org/vocab/>
        SELECT *
        WHERE {
          ?work a bf:Work .
          ?work bf:authorizedAccessPoint ?aap .
          FILTER regex(?aap, 'Marais', 'i')
          FILTER regex(?aap, 'Pièces de violes', 'i')
        }
      ")
    }
    it 'Marias Pièces de Violes' do
      # 700 work: Marais, Marin, Pièces de violes, 4e livre. 1ère partie. 39-40
      expect(repo297984.query(marais_pieces_work_query).size).to eq 1
    end

  end

end