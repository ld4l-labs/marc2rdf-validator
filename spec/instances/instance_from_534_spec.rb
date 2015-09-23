require 'spec_helper'
require 'linkeddata'

describe 'related instance from MARC 534' do

# mbshared:related-works calls mbshared:generate-related-instance for any of
#   (... 534...)

  it 'should 534 generate a bf:Instance, and if so, under which circumstance (e.g. |c or |e or |t?)' do
    fail 'should 534 generate a bf:Instance, and if so, under which circumstance (e.g. |c or |e or |t?)'
    # should there be an originalVersion relationship between Instances, or just Works?
  end
  #

  context "single 534" do
    let(:g) {
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
          <leader>01711cam a22003614a 4500</leader>
          <controlfield tag="001">14342057</controlfield>
          <controlfield tag="008">020911s2002    fr ab    b    000 0 fre d</controlfield>
          <datafield tag="245" ind1="1" ind2="0">
            <subfield code="a">"Somme, c\'est Ce&#x301;sar--" :</subfield>
            <subfield code="b">premie&#x300;re reproduction, en fac-simile, de l\'exemplaire des Commentaires de Ce&#x301;sar, annote&#x301; par Montaigne /</subfield>
            <subfield code="c">Michel de Montaigne ; publie&#x301; par Andre&#x301; Gallet ; avec une introduction par Andre&#x301; Gallet ; une notice bibliographique de Francis Pottie&#x301;e-Sperry ; et une note historique par Emmanuelle Toulet.</subfield>
          </datafield>
          <datafield tag="260" ind1=" " ind2=" ">
            <subfield code="a">Chantilly :</subfield>
            <subfield code="b">Muse&#x301;e Conde&#x301; ;</subfield>
            <subfield code="a">Bordeaux :</subfield>
            <subfield code="b">William Blake &amp; Co. ;</subfield>
            <subfield code="c">c2002.</subfield>
          </datafield>
          <datafield tag="300" ind1=" " ind2=" ">
            <subfield code="a">2 v. :</subfield>
            <subfield code="b">ill., maps ;</subfield>
            <subfield code="c">23 cm.</subfield>
          </datafield>
          <datafield tag="534" ind1=" " ind2=" ">
            <subfield code="p">Facsim. of:</subfield>
            <subfield code="t">C. Iulii Caesaris Commentarii, novis emendationibus illustrati,</subfield>
            <subfield code="c">Antverpiae : Ex officina Christoph. Plantini, 1570.</subfield>
          </datafield>
        </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'a293532')
    }
    it '2 instances' do
      expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
    end
    it '1 instanceOf' do
      expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
    end
    it 'main instance originalVersion 534 instances' do
      # TODO:  is this the right direction?
      expect_instance2instance_property(g, 1, RDF::Vocab::Bibframe.originalVersion)
    end
  end # single 534

  context "mult 534" do
    let(:g) {
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
          <leader>01811ccm a2200409 a 4500</leader>
          <controlfield tag="001">a293532</controlfield>
          <controlfield tag="008">890719r19891906nyusya   z     n    ger  </controlfield>
          <datafield ind1="0" ind2="0" tag="245">
            <subfield code="a">Symphonies nos. 3 and 4 /</subfield>
            <subfield code="c">Gustav Mahler.</subfield>
          </datafield>
          <datafield ind1=" " ind2=" " tag="260">
            <subfield code="a">New York :</subfield>
            <subfield code="b">Dover,</subfield>
            <subfield code="c">1989.</subfield>
          </datafield>
          <datafield ind1=" " ind2=" " tag="300">
            <subfield code="a">1 score (353 p.) ;</subfield>
            <subfield code="c">31 cm.</subfield>
          </datafield>
          <datafield ind1=" " ind2=" " tag="534">
            <subfield code="p">Reprint (1st work). Originally published:</subfield>
            <subfield code="c">Vienna : Universal Edition, 1906.</subfield>
          </datafield>
          <datafield ind1=" " ind2=" " tag="534">
            <subfield code="p">Reprint (2nd work). Originally published:</subfield>
            <subfield code="c">Vienna : Universal Edition, 1906.</subfield>
          </datafield>
        </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'a293532')
    }
    it '3 instances' do
      expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 3
    end
    it '3 instanceOf' do
      expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 3
    end
    it 'main instance originalVersion 534 instances' do
      # TODO:  is this the right direction?
      expect_instance2instance_property(g, 2, RDF::Vocab::Bibframe.originalVersion)
    end
  end # mult 534

end