require 'spec_helper'
require 'linkeddata'

describe 'related instances from MARC 7xx' do

# mbshared:related-works calls mbshared:generate-related-instance for any of
#   (... 700|710|711|730|740|760|762|765|767|770|772|773|774|775|777|780|785|787 ...)

# 760 - Main Series Entry (R) Full | Concise
# 762 - Subseries Entry (R) Full | Concise
# 765 - Original Language Entry (R) Full | Concise
# 767 - Translation Entry (R) Full | Concise
# 770 - Supplement/Special Issue Entry (R) Full | Concise
# 772 - Supplement Parent Entry (R) Full | Concise
# 773 - Host Item Entry (R) Full | Concise
# 774 - Constituent Unit Entry (R) Full | Concise
# 775 - Other Edition Entry (R) Full | Concise
# 776 - Additional Physical Form Entry (R) Full | Concise
# 777 - Issued With Entry (R) Full | Concise
# 780 - Preceding Entry (R) Full | Concise
# 785 - Succeeding Entry (R) Full | Concise
# 786 - Data Source Entry (R) Full | Concise
# 787 - Other Relationship Entry (R) Full | Concise

  context "776 otherPhysicalFormat" do
    let!(:g) {
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
          <leader>01780cas a2200445 a 4500</leader>
          <controlfield tag="001">11338843</controlfield>
          <controlfield tag="008">800417d18941920miumn   a     0   a0eng c</controlfield>
          <datafield tag="245" ind1="1" ind2="4">
            <subfield code="a">The Advocate of peace</subfield>
            <subfield code="h">[microform].</subfield>
          </datafield>
          <datafield tag="260" ind1=" " ind2=" ">
            <subfield code="a">Boston, Mass. :</subfield>
            <subfield code="b">[American Peace Society],</subfield>
            <subfield code="c">1894-1920.</subfield>
          </datafield>
          <datafield tag="300" ind1=" " ind2=" ">
            <subfield code="a">27 v. ;</subfield>
            <subfield code="c">24-31 cm.</subfield>
          </datafield>
          <datafield tag="776" ind1="1" ind2=" ">
            <subfield code="t">Advocate of peace (1894)</subfield>
            <subfield code="w">(OCoLC)6797409</subfield>
          </datafield>
        </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '11338843')
    }
    it '2 instances' do
      expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
    end
    it '1 instanceOf' do
      expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
    end
    it 'main instance issuedWith 776 instance' do
      # TODO:  is this the right direction?
      expect_instance2instance_property(g, 1, RDF::Vocab::Bibframe.otherPhysicalFormat)
    end
  end

  context "777 issuedWith" do
    let!(:g) {
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
          <leader>02308cas a2200541 a 4500</leader>
          <controlfield tag="001">11331701</controlfield>
          <controlfield tag="008">790906u1921uuuubl ar p   o   0    0por c</controlfield>
          <datafield tag="245" ind1="1" ind2="2">
            <subfield code="a">A ordem.</subfield>
          </datafield>
          <datafield tag="260" ind1=" " ind2=" ">
            <subfield code="a">Rio de Janeiro :</subfield>
          </datafield>
          <datafield tag="777" ind1="1" ind2=" ">
            <subfield code="t">Boletim do Instituto Cato&#x301;lico de Cooperac&#x327;a&#x303;o Intelectual</subfield>
          </datafield>
        </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '11331701')
    }
    it '2 instances' do
      expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
    end
    it '1 instanceOf' do
      expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
    end
    it 'main instance issuedWith 777 instance' do
      # TODO:  is this the right direction?
      expect_instance2instance_property(g, 1, RDF::Vocab::Bibframe.issuedWith)
    end
  end

end
