require 'spec_helper'
require 'linkeddata'

describe 'instance basics' do

  let(:marc_ldr_001_008) {
    '<record xmlns="http://www.loc.gov/MARC21/slim">
      <leader>01855cemaa22003131a 4500</leader>
      <controlfield tag="001">aRECORD_ID</controlfield>
      <controlfield tag="008">760219s1925    en            000 0 eng  </controlfield>'
  }

  context "no 260, 264 or 856" do
    context 'only 245' do
      let(:g) {
        rec_id = 'no_26x'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="1" ind2="0" tag="245">
            <subfield code="a">Slippery noodles</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it '0 Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 0
      end
      it '0 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 0
      end
    end # only 245
    context '245 + 300' do
      let(:g) {
        rec_id = '300_no_26x'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="1" ind2="0" tag="245">
            <subfield code="a">Slippery noodles</subfield>
          </datafield>
          <datafield ind1=" " ind2=" " tag="300">
            <subfield code="a">344 pages ;</subfield>
            <subfield code="c">24 cm</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it '0 Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 0
      end
      it '0 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 0
      end
    end # 245 + 300
  end # no 260, 264 or 856

  context "260" do
    context 'single 260' do
      let(:g) {
        rec_id = '260'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield tag="245" ind1="1" ind2="2">
            <subfield code="a">A ordem.</subfield>
          </datafield>
          <datafield tag="260" ind1=" " ind2=" ">
            <subfield code="a">Rio de Janeiro :</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it '1 Instance' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
      end
      it '1 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
      end
    end # single 260
    context "mult 260" do
       let(:g) {
        rec_id = '260'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield tag="245" ind1="1" ind2="0">
            <subfield code="a">Textuel.</subfield>
          </datafield>
          <datafield tag="260" ind1=" " ind2=" ">
            <subfield code="a">Paris :</subfield>
            <subfield code="b">L\'U.F.R. "Science des textes et documents",</subfield>
            <subfield code="c">1990-</subfield>
          </datafield>
          <datafield tag="260" ind1="2" ind2=" ">
            <subfield code="3">&lt;2011&gt;-2013</subfield>
            <subfield code="a">Paris :</subfield>
            <subfield code="b">UFR Lettres, Arts, Cine&#x301;ma</subfield>
          </datafield>
          <datafield tag="260" ind1="3" ind2=" ">
            <subfield code="3">2014-</subfield>
            <subfield code="a">Paris :</subfield>
            <subfield code="b">Hermann</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it '3 Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 3
      end
      it '3 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 3
      end
    end # mult 260
  end # 260

  context "264" do
    context '264 ind2=1' do
      let(:g) {
        rec_id = '264ind2_1'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield tag="245" ind1="1" ind2="2">
            <subfield code="a">A ordem.</subfield>
          </datafield>
          <datafield ind1=" " ind2="1" tag="264">
            <subfield code="a">London :</subfield>
            <subfield code="b">Prospect Books,</subfield>
            <subfield code="c">2015.</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it '1 Instance' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
      end
      it '1 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
      end
    end # single 264
  end # 264

  context "856" do
    context 'no instance if no 856' do

    end
    context 'instance if 856' do
      it 'write 856 tests' do
        fail 'need 856 tests'
      end
    end
  end # 856

  context 'both 260 and 856' do

  end

end