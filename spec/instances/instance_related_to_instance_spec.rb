require 'spec_helper'
require 'linkeddata'

describe 'instance related to the instance described by the MARC record' do

# mbshared:related-works calls mbshared:generate-related-instance for any of
#   (400|410|411|430|440|490|533|534|630|700|710|711|730|740|760|762|765|767|770|772|773|774|775|777|780|785|787|800|810|811|830)


  let(:marc_ldr_001_008) {
    '<record xmlns="http://www.loc.gov/MARC21/slim">
      <leader>02308cas a2200541 a 4500</leader>
      <controlfield tag="001">aRECORD_ID</controlfield>
      <controlfield tag="008">790906u1921uuuubl ar p   o   0    0por c</controlfield>'
  }


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

  context "issuedWith" do
    # /m2b-properties/issuedWith/11331701.ttl
    let(:g) {
      rec_id = '777'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield tag="245" ind1="1" ind2="2">
          <subfield code="a">A ordem.</subfield>
        </datafield>
        <datafield tag="260" ind1=" " ind2=" ">
          <subfield code="a">Rio de Janeiro :</subfield>
        </datafield>
        <datafield tag="777" ind1="1" ind2=" ">
          <subfield code="t">Boletim do Instituto Cato&#x301;lico de Cooperac&#x327;a&#x303;o Intelectual</subfield>
        </datafield>
      </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
    }
    it '2 instances' do
      expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
    end
    it '1 instanceOf' do
      expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
    end
    it 'main instance issuedWith 777 instance' do
      expect_instance2instance_property(g, 1, RDF::Vocab::Bibframe.issuedWith)
    end
  end

  context "otherPhysicalFormat" do
    # /m2b-properties/otherPhysicalFormat/11338843.ttl
    # /m2b-properties/otherPhysicalFormat/11737193.ttl
    # /m2b-properties/otherPhysicalFormat/12734030.ttl
    # and lots more
  end

  context "relatedInstance" do
    # /m2b-properties/relatedInstance/3556119.ttl  (or not)
  end

  context "reproduction" do
    # m2b-properties/reproduction/723007.ttl
    # and more
  end

end