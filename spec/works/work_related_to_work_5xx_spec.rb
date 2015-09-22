require 'spec_helper'
require 'linkeddata'

describe 'work related to the work described by the MARC record' do

  # Stanford:
  # MARC fields that identify “a work related to the work the described by the record”:
  # 247
  # 400, 410, 411, 440
  # 490 and 80x-83x
  # 500, 501, 525, 510, 533, 534, 547, 555, 580, 581
  # 600-611 with $t, and 630
  # 690 (Is a collection a work?)
  # 700-711 with $t but second indicator not “2”
  # 730 and 740 with second indicator not “2”
  # 76x-78x
  # 79x
  # And perhaps accompanying materials (300 $e)

  # marc2bibframe xquery converter
  # ???

  let(:marc_ldr_001_008) {
    '<record xmlns="http://www.loc.gov/MARC21/slim">
      <leader>01855cemaa22003131a 4500</leader>
      <controlfield tag="001">aRECORD_ID</controlfield>
      <controlfield tag="008">760219s1925    en            000 0 eng  </controlfield>'
  }

  context "500" do
    it 'need tests for 500' do
      fail 'need example data for 500'
    end
  end # 500

  context "501" do
    it 'need tests for 501' do
      fail 'need example data for 501'
    end
  end # 501

  # NOTE:  505 is covered by work_within_work spec

  context "510" do
    it 'need tests for 510' do
      fail 'need example data for 510'
    end
  end # 510

  context "525" do
    it 'need tests for 525' do
      fail 'need example data for 525'
    end
  end # 525

  context "533 (reproduction)" do
    context "electronic repro" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">533works</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">Expert podcasting practices for dummies</subfield>
              <subfield code="h">[electronic resource] /</subfield>
              <subfield code="c">by Tee Morris, Evo Terra, and Ryan Williams.</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="533">
              <subfield code="a">Electronic reproduction.</subfield>
              <subfield code="b">Boston, Mass. :</subfield>
              <subfield code="c">Safari Books Online,</subfield>
              <subfield code="d">2008.</subfield>
              <subfield code="n">Mode of access:  World Wide Web.</subfield>
              <subfield code="n">Available to subscribing institutions.</subfield>
              <subfield code="7">s2008    maun s</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '533works')
      }
      it '2 Works' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
      end
      it 'main Work reproduction of 533 work' do
          solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.prop).to eq RDF::Vocab::Bibframe.reproduction
      end
    end # electronic repro
    context "serial" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01384cas a22003377a 4500</leader>
            <controlfield tag="001">533combo_260_300_serial</controlfield>
            <controlfield tag="008">951215c19uu9999bt ar   b    f0    0eng  </controlfield>
            <datafield tag="245" ind1="1" ind2="0">
              <subfield code="a">`Budget estimates for fiscal year ...</subfield>
              <subfield code="h">[microform] :</subfield>
              <subfield code="b">Ministry of Health &amp; Education.</subfield>
            </datafield>
            <datafield tag="533" ind1=" " ind2=" ">
              <subfield code="a">Microfiche.</subfield>
              <subfield code="m">1994/95-</subfield>
              <subfield code="b">New Delhi :</subfield>
              <subfield code="c">Library of Congress Office ;</subfield>
              <subfield code="b">Washington, D.C. :</subfield>
              <subfield code="c">Library of Congress Photoduplication Service,</subfield>
              <subfield code="d">1995-</subfield>
              <subfield code="e">microfiches.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '533combo_260_300_serial')
      }
      it '2 Works' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
      end
      it 'main Work reproduction of 533 work' do
          solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.prop).to eq RDF::Vocab::Bibframe.reproduction
      end
    end # serial
    context "recording" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01779cim a2200373 a 4500</leader>
            <controlfield tag="001">533combo_260_300_recording</controlfield>
            <controlfield tag="008">931119s1958    dcunnn         f    eng  </controlfield>
            <datafield tag="245" ind1="1" ind2="0">
              <subfield code="a">Eudora Welty reading three of her short stories</subfield>
              <subfield code="h">[sound recording].</subfield>
            </datafield>
            <datafield tag="533" ind1=" " ind2=" ">
              <subfield code="a">Preservation master.</subfield>
              <subfield code="b">Washington, D.C. :</subfield>
              <subfield code="c">Library of Congress Magnetic Recording Laboratory,</subfield>
              <subfield code="d">1973.</subfield>
              <subfield code="e">1 sound tape reel : analog, 7 1/2 ips, 2 track, mono. ; 10 in.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '533combo_260_300_recording')
      }
      it '2 Works' do
        expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
      end
      it 'one Work reproduction of other Work' do
        # TODO:  is this relationship in the right direction?
        solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.prop).to eq RDF::Vocab::Bibframe.reproduction
      end
    end # recording
  end # 533

  context "534" do
    it 'need tests for 534' do
      fail 'need example data for 534'
    end
  end # 534

  context "547" do
    it 'need tests for 547' do
      fail 'need example data for 547'
    end
  end # 547

  context "555 (index)" do
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
        it '2 Works' do
          expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
        end
        it 'one Work index of other Work' do
          # TODO:  is this relationship in the right direction?
          solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.prop).to eq RDF::Vocab::Bibframe.index
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
        it '2 Works' do
          expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
        end
        it 'one Work index of other Work' do
          # TODO:  is this relationship in the right direction?
          solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.prop).to eq RDF::Vocab::Bibframe.index
        end
      end # 300s only (no 26x)
    end # single 555 single u

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
          it '2 Works' do
            # should it create a Work when there is no |u in 555?
            expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
          end
          it 'one Work index of other Work' do
            # TODO:  is this relationship in the right direction?
            solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.prop).to eq RDF::Vocab::Bibframe.index
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
          it '2 Works' do
            # should it create a Work when there is no |u in 555?
            expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 2
          end
          it 'one Work index of other Work' do
            # TODO:  is this relationship in the right direction?
            solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.prop).to eq RDF::Vocab::Bibframe.index
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
            it '3 Works' do
              expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 3
            end
            it 'two Works index of other Work' do
              # TODO:  is this relationship in the right direction?
              solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
              expect(solns.size).to eq 2
              solns.each { |soln|
                expect(soln.prop).to eq RDF::Vocab::Bibframe.index
              }
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
            it '3 Works' do
              expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 3
            end
            it 'two Works index of other Work' do
              # TODO:  is this relationship in the right direction?
              solns = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY)
              expect(solns.size).to eq 2
              solns.each { |soln|
                expect(soln.prop).to eq RDF::Vocab::Bibframe.index
              }
            end
          end # mult 300, no 260, papers
        end # each has u
      end # mult 555

  end # 555

  context "580" do
    it 'need tests for 580' do
      fail 'need example data for 580'
    end
  end # 580

  context "581" do
    it 'need tests for 581' do
      fail 'need example data for 581'
    end
  end # 581

end