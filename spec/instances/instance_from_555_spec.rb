require 'spec_helper'
require 'linkeddata'

describe 'instance from 555 (cumulative index / finding aids)' do
  context "single 555 single u" do
    context "260, 300, image collection" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>07792ckc a2201081 a 4500</leader>
            <controlfield tag="001">single555_singleu</controlfield>
            <controlfield tag="008">940527i19391943xxunnn            kneng  </controlfield>
            <datafield tag="245" ind1="0" ind2="0">
              <subfield code="a">Farm Security Administration - Office of War Information color slides and transparencies collection (Library of Congress)</subfield>
              <subfield code="h">[graphic].</subfield>
            </datafield>
            <datafield tag="260" ind1=" " ind2=" ">
              <subfield code="c">1939-1944.</subfield>
            </datafield>
            <datafield tag="300" ind1=" " ind2=" ">
              <subfield code="a">1,616 transparencies (film and slides) :</subfield>
              <subfield code="b">color ;</subfield>
              <subfield code="c">4 x 5 in. or smaller.</subfield>
            </datafield>
            <datafield tag="555" ind1="8" ind2=" ">
              <subfield code="a">A set of catalog records describing each item is available through the Open Archives Initiative Protocol for Metadata Harvesting. See</subfield>
              <subfield code="u">http://hdl.loc.gov/loc.gdc/lcoa1.about</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'single555_singleu')
      }
      it '2 Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
      end
      it '2 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
      end
      it 'relationship between Works' do
        num_works = g.query(WorkHelpers::WORK_SPARQL_QUERY).size
        expect(num_works).to eq 2
        num_work_rels = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY).size
        expect(num_work_rels).to be > 0
      end
      it 'no direct relationship between Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
      end
    end # image coll 260, 300
    context "300s only (no 26x)" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>03469cpcaa2200589 a 4500</leader>
            <controlfield tag="001">555u_w_mult_300_no_260</controlfield>
            <controlfield tag="008">070711||||||||||||                 eng  </controlfield>
            <datafield tag="245" ind1="0" ind2="0">
              <subfield code="a">Robert Todd Lincoln family papers,</subfield>
              <subfield code="f">1864-1938</subfield>
              <subfield code="g">(bulk 1918-1927).</subfield>
            </datafield>
            <datafield tag="300" ind1=" " ind2=" ">
              <subfield code="a">2,845</subfield>
              <subfield code="f">items.</subfield>
            </datafield>
            <datafield tag="300" ind1=" " ind2=" ">
              <subfield code="a">9</subfield>
              <subfield code="f">containers plus</subfield>
              <subfield code="a">5</subfield>
              <subfield code="f">oversize.</subfield>
            </datafield>
            <datafield tag="300" ind1=" " ind2=" ">
              <subfield code="a">3.4</subfield>
              <subfield code="f">linear feet.</subfield>
            </datafield>
            <datafield tag="555" ind1="8" ind2=" ">
              <subfield code="a">Finding aid available in the Library of Congress Manuscript Reading Room and at</subfield>
              <subfield code="u">http://hdl.loc.gov/loc.mss/eadmss.ms010093</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '555u_w_mult_300_no_260')
      }
      it '2 Instances' do
        # FIXME:  Instances for LoC archival materials with mult 300s seem borked.
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
      end
      it '2 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
      end
      it 'relationship between Works' do
        num_works = g.query(WorkHelpers::WORK_SPARQL_QUERY).size
        expect(num_works).to eq 2
        num_work_rels = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY).size
        expect(num_work_rels).to be > 0
      end
      it 'no direct relationship between Instances' do
        # FIXME:  not sure this is correct ...
        expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
      end
    end # 300s only (no 26x)
  end # single 555 single u

  context "single 555 mult u" do
    it 'need example of single 555 with mult u' do
      pending 'need example of single 555 with mult u'
    end
  end

  context "single 555 no u" do
    context "journal 260, 300" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>04849cas a2200613 a 4500</leader>
            <controlfield tag="001">555_no_u_260_300</controlfield>
            <controlfield tag="008">810709c19719999okufr p       0   a0eng d</controlfield>
            <datafield ind1="0" ind2="4" tag="245">
              <subfield code="a">The Horn call.</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="a">Durant, Okla. :</subfield>
              <subfield code="b">International Horn Society.</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="300">
              <subfield code="a">v. :</subfield>
              <subfield code="b">ill., music, ports. ;</subfield>
              <subfield code="c">23 cm.</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="555">
              <subfield code="a">Vols. 1-10, after v. 10.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '555_no_u_260_300')
      }
      it '1 Instance' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
      end
      it '1 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
      end
    end # journal 260, 300
    context "archival coll no 260, yes 300" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01855cemaa22003131a 4500</leader>
            <controlfield tag="001">555_no_u_300</controlfield>
            <controlfield tag="008">020123q14861865sa                  eng u</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">Dr. Oscar I. Norwich collection of maps of Africa and its islands,</subfield>
              <subfield code="f">1486 - ca. 1865.</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="300">
              <subfield code="a">312 items.</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="555">
              <subfield code="a">Finding aid available online and in the Special Collections Reading Room.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '555_no_u_300')
      }
      it '1 Instance' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
      end
      it '1 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
      end
    end # archival coll no 260, yes 300
  end # single 555 no u

  context "mult 555" do
    context "each has u" do
      context "260, 300, photograph collection" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>06754ckc a2200889 a 4500</leader>
              <controlfield tag="001">mult555_photo_coll</controlfield>
              <controlfield tag="008">030313i18801893tu nnn            knota  </controlfield>
              <datafield tag="245" ind1="0" ind2="0">
                <subfield code="a">Abdul-Hamid II collection of photographs of the Ottoman Empire</subfield>
                <subfield code="h">[graphic].</subfield>
              </datafield>
              <datafield tag="260" ind1=" " ind2=" ">
                <subfield code="c">1880-1893.</subfield>
              </datafield>
              <datafield tag="300" ind1=" " ind2=" ">
                <subfield code="a">51 albums ;</subfield>
                <subfield code="c">32 x 19 in. or smaller.</subfield>
              </datafield>
              <datafield tag="555" ind1="8" ind2=" ">
                <subfield code="a">Collection profile available online</subfield>
                <subfield code="u">hdl.loc.gov/loc.pnp/pp.ahii</subfield>
              </datafield>
              <datafield tag="555" ind1="8" ind2=" ">
                <subfield code="a">A set of catalog records describing each item is available through the Open Archives Initiative Protocol for Metadata Harvesting. See</subfield>
                <subfield code="u">http://hdl.loc.gov/loc.gdc/lcoa1.about</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'mult555_photo_coll')
        }
        it '3 Instances' do
          # should it only generate 1 Instance for all the 300s + 260?
          # it should generate an Instance for each 555u, no?  LoC converter seems to only take the first one
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 3
        end
        it '3 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 3
        end
        it 'relationship between Works' do
          num_works = g.query(WorkHelpers::WORK_SPARQL_QUERY).size
          expect(num_works).to eq 3
          num_work_rels = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY).size
          expect(num_work_rels).to be > 0
        end
        it 'no direct relationship between Instances' do
          expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
        end
      end # 260, 300 photograph collection
      context "mult 300, no 260, papers" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>06411cpcaa2201021 i 4500</leader>
              <controlfield tag="001">mult555_mult300_no_260_papers</controlfield>
              <controlfield tag="008">780918||||||||||||                 eng  </controlfield>
              <datafield tag="245" ind1="0" ind2="0">
                <subfield code="a">Abraham Lincoln papers,</subfield>
                <subfield code="f">1774-1948.</subfield>
              </datafield>
              <datafield tag="300" ind1=" " ind2=" ">
                <subfield code="a">40,550</subfield>
                <subfield code="f">items.</subfield>
              </datafield>
              <datafield tag="300" ind1=" " ind2=" ">
                <subfield code="a">221</subfield>
                <subfield code="f">containers plus</subfield>
                <subfield code="a">11</subfield>
                <subfield code="f">oversize.</subfield>
              </datafield>
              <datafield tag="300" ind1=" " ind2=" ">
                <subfield code="a">98</subfield>
                <subfield code="f">microfilm reels.</subfield>
              </datafield>
              <datafield tag="300" ind1=" " ind2=" ">
                <subfield code="a">48</subfield>
                <subfield code="f">linear feet.</subfield>
              </datafield>
              <datafield tag="555" ind1="8" ind2=" ">
                <subfield code="a">Finding aid available in the Library of Congress Manuscript Reading Room and at</subfield>
                <subfield code="u">http://hdl.loc.gov/loc.mss/eadmss.ms009304</subfield>
              </datafield>
              <datafield tag="555" ind1="8" ind2=" ">
                <subfield code="a">Index published by the Library of Congress in 1960 available in the Library of Congress Manuscript Reading Room and at</subfield>
                <subfield code="u">http://hdl.loc.gov/loc.gdc/scd0001.20101124004al.2</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'mult555_mult300_no_260_papers')
        }
        it '3 Instances' do
          # should it only generate 1 Instance for all the 300s + 260?
          # it should generate an Instance for each 555u, no?  LoC converter seems to only take the first one
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 3
        end
        it '3 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 3
        end
        it 'single Work or relationship between Instances or between Works' do
          num_works = g.query(WorkHelpers::WORK_SPARQL_QUERY).size
          expect(num_works).to eq 3
          num_work_rels = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY).size
          expect(num_work_rels).to be > 0
        end
        it 'no direct relationship between Instances' do
          expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
        end
      end # mult 300, no 260, papers
    end # each has u
  end # mult 555
end