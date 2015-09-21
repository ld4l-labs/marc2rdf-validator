require 'spec_helper'
require 'linkeddata'

describe 'instance from 300' do

  context "single 300" do
    context "no 26x" do
      context "leader6=a, leader7=b" do
        it 'need example of single 300 no 26x when leader6=a, leader7=b' do
          fail 'need example of single 300 no 26x when leader6=a, leader7=b'
        end
      end # leader6=a, leader7=b
      context "leader6=a, leader7=i" do
        it 'need example of single 300 no 26x when leader6=a, leader7=i' do
          fail 'need example of single 300 no 26x when leader6=a, leader7=i'
        end
      end # leader6=a, leader7=i
      context "leader6=a leader7=s" do
        it 'need example of single 300 no 26x when leader6=a, leader7=s' do
          fail 'need example of single 300 no 26x when leader6=a, leader7=s'
        end
      end # leader6=a, leader7=s
      context "leader6=a, leader7 not b, i, s" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01736cam a22003254a 4500</leader>
              <controlfield tag="001">300_no_26x_leader6a_leader7m</controlfield>
              <controlfield tag="008">040528s2004    ja a     b    100 0 jpn  </controlfield>
              <datafield tag="245" ind1="1" ind2="0">
                <subfield code="6">880-02</subfield>
                <subfield code="a"> "Shinto&#x304;" wa do hon&#x2BE;yakusarete iru ka /</subfield>
                <subfield code="c">[henshu&#x304; Kokugakuin Daigaku 21-seiki COE Puroguramu].  </subfield>
              </datafield>
              <datafield tag="300" ind1=" " ind2=" ">
                <subfield code="a">123 p. :</subfield>
                <subfield code="b">ill. ;</subfield>
                <subfield code="c">26 cm.</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '300_no_26x_leader6a_leader7m')
        }
        it '1 Instance' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
        end
        it '1 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
        end
      end # leader6=a, leader7 not b, i, s
      context "leader6 not a" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01464cpcaa22003133a 4500</leader>
              <controlfield tag="001">300_no_26x_leader6_nota</controlfield>
              <controlfield tag="008">141218i20072014                    eng u</controlfield>
              <datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Stanford University, Women\'s Community Center, records,</subfield>
                <subfield code="f">2007-2014.</subfield>
              </datafield>
              <datafield ind1=" " ind2=" " tag="300">
                <subfield code="a">.25</subfield>
                <subfield code="f">linear feet</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '300_no_26x_leader6_nota')
        }
        it '1 Instance' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
        end
        it '1 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
        end
      end # leader6 not a
    end # no 26x
    context '260 + 300' do
      context "leader6=a, leader7=b" do
        it 'need example of single 300 w 260 when leader6=a, leader7=b' do
          fail 'need example of single 300 w 260 when leader6=a, leader7=b'
        end
      end # leader6=a, leader7=b
      context "leader6=a, leader7=i" do
        it 'need example of single 300 w 260 when leader6=a, leader7=i' do
          fail 'need example of single 300 w 260 when leader6=a, leader7=i'
        end
      end # leader6=a, leader7=i
      context "leader6=a leader7=s" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>04849cas a2200613 a 4500</leader>
              <controlfield tag="001">300_260_journal</controlfield>
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
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '300_260_journal')
        }
        it '1 Instance' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
        end
        it '1 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
        end
      end # leader6=a leader7=s
      context "leader6=a, leader7 not b, i, s" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>06174nam a2200445Ia 4500</leader>
              <controlfield tag="001">300_260_book</controlfield>
              <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
              <datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Expert podcasting practices for dummies</subfield>
                <subfield code="h">[electronic resource] /</subfield>
                <subfield code="c">by Tee Morris, Evo Terra, and Ryan Williams.</subfield>
              </datafield>
              <datafield ind1=" " ind2=" " tag="260">
                <subfield code="a">Hoboken, [N.J.] :</subfield>
                <subfield code="b">Wiley Pub.,</subfield>
                <subfield code="c">c2008.</subfield>
              </datafield>
              <datafield ind1=" " ind2=" " tag="300">
                <subfield code="a">xviii, 433 p. :</subfield>
                <subfield code="b">ill. ;</subfield>
                <subfield code="c">24 cm. +</subfield>
                <subfield code="e">1 CD-ROM (4 3/4 in.)</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '300_260_book')
        }
        it '1 Instance' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
        end
        it '1 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
        end
      end # leader6=a, leader7 not b, i, s
      context "leader6 not a" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01656ccm a2200349 a 4500</leader>
              <controlfield tag="001">300_260_score</controlfield>
              <controlfield tag="008">020925s2002    wiujza   fi    n    zxx d</controlfield>
              <datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Birth of the cool /</subfield>
                <subfield code="c">Miles Davis.</subfield>
              </datafield>
              <datafield ind1=" " ind2=" " tag="260">
                <subfield code="a">Milwaukee, WI :</subfield>
                <subfield code="b">H. Leonard Corp.,</subfield>
                <subfield code="c">[2002?]</subfield>
              </datafield>
              <datafield ind1=" " ind2=" " tag="300">
                <subfield code="a">1 score (167 p.) :</subfield>
                <subfield code="b">ill. ;</subfield>
                <subfield code="c">31 cm.</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '300_260_score')
        }
        it '1 Instance' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
        end
        it '1 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
        end
      end # leader6 not a
    end # 260 + 300
    context "264 + 300" do
      context "leader6=a, leader7=b" do
        it 'need example of single 300 w 264 when leader6=a, leader7=b' do
          fail 'need example of single 300 w 264 when leader6=a, leader7=b'
        end
      end # leader6=a, leader7=b
      context "leader6=a, leader7=i" do
        it 'need example of single 300 w 264 when leader6=a, leader7=i' do
          fail 'need example of single 300 w 264 when leader6=a, leader7=i'
        end
      end # leader6=a, leader7=i
      context "leader6=a, leader7=s" do
        it 'need example of single 300 w 264 when leader6=a, leader7=s' do
          fail 'need example of single 300 w 264 when leader6=a, leader7=s'
        end
      end # leader6=a, leader7=i
      context "leader6=a leader7=m" do
        let(:g) {
          marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01052cam a2200313 i 4500</leader>
              <controlfield tag="001">300_264_book</controlfield>
              <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
              <datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Slippery noodles</subfield>
              </datafield>
              <datafield ind1=" " ind2="1" tag="264">
                <subfield code="a">London :</subfield>
                <subfield code="b">Prospect Books,</subfield>
                <subfield code="c">2015.</subfield>
              </datafield>
              <datafield ind1=" " ind2=" " tag="300">
                <subfield code="a">344 pages ;</subfield>
                <subfield code="c">24 cm</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '300_264_book')
        }
        it '1 Instance' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
        end
        it '1 instance' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
        end
      end # leader6=a leader7=m
      context "leader6 not a" do
        let(:g) {
          marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01553cem a2200433 i 4500</leader>
              <controlfield tag="001">300_264_map</controlfield>
              <controlfield tag="008">150115t20152015fr        e     1   fre  </controlfield>
              <datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Atlas mondial des femmes :</subfield>
              </datafield>
              <datafield ind1=" " ind2="1" tag="264">
                <subfield code="a">Paris :</subfield>
                <subfield code="b">Éditions Autrement,</subfield>
                <subfield code="c">[2015]</subfield>
              </datafield>
              <datafield ind1=" " ind2="4" tag="264">
                <subfield code="c">©2015</subfield>
              </datafield>
              <datafield ind1=" " ind2=" " tag="300">
                <subfield code="a">1 atlas (96 pages) :</subfield>
                <subfield code="b">color illustrations, color maps ;</subfield>
                <subfield code="c">25 cm.</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '300_264_map')
        }
        it '1 Instance' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
        end
        it '1 instance' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
        end
      end # leader 6 not a
    end # 264 + 300
  end # single 300

  context "mult 300" do
    # TODO:  does this need to have same spread of leader6 and leader7 conditions as single 300?
    context "no 26x" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01619cpcaa2200361   4500</leader>
            <controlfield tag="001">200_no_26x</controlfield>
            <controlfield tag="008">811109||||||||||||                 eng  </controlfield>
            <datafield tag="245" ind1="0" ind2="0">
              <subfield code="a">History of the rise, progress, and termination of the American Revolution :</subfield>
              <subfield code="k">manuscripts,</subfield>
              <subfield code="f">1801-1805.</subfield>
            </datafield>
            <datafield tag="300" ind1=" " ind2=" ">
              <subfield code="a">2</subfield>
              <subfield code="f">items.</subfield>
            </datafield>
            <datafield tag="300" ind1=" " ind2=" ">
              <subfield code="a">2</subfield>
              <subfield code="f">containers.</subfield>
            </datafield>
            <datafield tag="300" ind1=" " ind2=" ">
              <subfield code="a">2</subfield>
              <subfield code="f">microfilm reels.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '300s_no_26x_video')
      }
      it '3 Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 3
      end
      it '3 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 3
      end
      it 'single Work' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
      end
      it 'no direct relationship between Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
      end
    end # no 26x
    context "260" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>02093cam a22004095i 4500</leader>
            <controlfield tag="001">300s_260</controlfield>
            <controlfield tag="008">060804s2006    iaua     b    000 0 eng  </controlfield>
            <datafield tag="245" ind1="1" ind2="0">
              <subfield code="a">Kings of Norway :</subfield>
              <subfield code="b">58 bilingual stories in English and Norwegian /</subfield>
              <subfield code="c">Text and illustrations by Anders Kva&#x30A;le Rue ; Simplification of text by Kari Gronningsaeter ; English translations by Jim Skurdall.</subfield>
            </datafield>
            <datafield tag="260" ind1=" " ind2=" ">
              <subfield code="a">Waukon, IA :</subfield>
              <subfield code="b">Astri My Astri Publishing,</subfield>
              <subfield code="c">[2006]</subfield>
            </datafield>
            <datafield tag="300" ind1=" " ind2=" ">
              <subfield code="a">124 pages :</subfield>
              <subfield code="b">illustrations ;</subfield>
              <subfield code="c">24 cm</subfield>
            </datafield>
            <datafield tag="300" ind1=" " ind2=" ">
              <subfield code="a">3 audio discs :</subfield>
              <subfield code="b">digital, CD audio ;</subfield>
              <subfield code="c">4 3/4 in.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '300s_264')
      }
      it '3 Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 3
      end
      it '3 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 3
      end
      it 'single Work' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
      end
      it 'no direct relationship between Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
      end
    end # 260
    context "264" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>05477com a2200913 i 4500</leader>
            <controlfield tag="001">300s_264</controlfield>
            <controlfield tag="008">140311s2012    ck nnn            bnspa c</controlfield>
            <datafield ind1="0" ind2="0" tag="245">
              <subfield code="a">Caja de herramientas por el derecho de las mujeres a una vida libre de violencias /</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="300">
              <subfield code="a">2 videodiscs :</subfield>
              <subfield code="b">sound, color ;</subfield>
              <subfield code="c">4 3/4 in. +</subfield>
              <subfield code="e">2 booklets (24 cm)</subfield>
            </datafield>
            <datafield ind1=" " ind2="1" tag="264">
              <subfield code="a">[Colombia] :</subfield>
              <subfield code="b">United Nations Development Fund for Women</subfield>
              <subfield code="c">[2012?]</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="300">
              <subfield code="a">1 audio disc ;</subfield>
              <subfield code="c">4 3/4 in.</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="300">
              <subfield code="a">70 pages ;</subfield>
              <subfield code="c">24 cm +</subfield>
              <subfield code="e">1 booklet + 3 sheets + 1 button.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '300s_264')
      }
      it '3 Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 3
      end
      it '3 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 3
      end
      it 'single Work' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
      end
      it 'no direct relationship between Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
      end
    end # 264
  end # mult 300

end
