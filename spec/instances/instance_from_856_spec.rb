require 'spec_helper'
require 'linkeddata'

describe 'instance from 856' do

# Note that the LC xquery converter generates a bf:Instance for an 856 under
# certain somewhat convoluted conditions. See https://github.com/lcnetdev/marc2bibframe
#  module.MBIB-2-BIBFRAME-Shared.xqy  L1673-L1703  or so
#
#    For example, there are cases where that code looks for:
#     in |u:   'hdl' or 'catdir'
#     absence of |3
#     in |3:  'finding aid' or 'pdf' or 'page view' or 'contents' or 'sample' or 'publisher' or 'contributor' ...
#  in some cases, the larger library community may follow similar conventions ... but perhaps not in all
#
# As of 2015-09, the tests here are attempting to capture the cases when a
# bf:Instance SHOULD be created from an 856, irrespective of the LC xquery converter code.

  context "no 26x or 300" do
    context "ind1=4" do
      context "ind2=0" do
        it 'need example 856 ind2=0, no 26x or 300' do
          fail 'need example 856 ind2=0, no 26x or 300'
        end
      end #ind2=0

      context "ind2=1" do
        it 'need example 856 ind2=1, no 26x or 300' do
          fail 'need example 856 ind2=1, no 26x or 300'
        end
      end # ind2=1

      context "ind2=2" do
        it 'if ind2=2 should create bf:Instance, need example 856 ind2=2, no 26x or 300' do
          fail 'if ind2=2 should create bf:Instance, need example 856 ind2=2, no 26x or 300'
        end
      end # ind2=2

      context "ind2=8" do
        it 'if ind2=8 should create bf:Instance, need example 856 ind2=8, no 26x or 300' do
          fail 'if ind2=8 should create bf:Instance, need example 856 ind2=8, no 26x or 300'
        end
      end # ind2=8

      context "ind2=blank" do
        it 'if ind2=blank should create bf:Instance, need example 856 ind2=blank, no 26x or 300' do
          fail 'if ind2=blank should create bf:Instance, need example 856 ind2=blank, no 26x or 300'
        end
      end # ind2=blank

      context "mult 856" do
        it 'need example mult 856, no 26x or 300' do
          fail 'need example mult 856, no 26x or 300'
        end
      end # mult 856
    end # ind1=4

    context "ind1 not 4" do
      it 'need example 856 ind1 not 4, no 26x or 300' do
        # only test data found for this so far has 2nd 856 for urn;  see 260 + 300 + 856 below
        fail 'need example 856 ind1 not 4, no 26x or 300'
      end
    end # ind1 not 4
  end # no 26x or 300

  context '26x and 856, no 300' do
    context "ind1=4" do
      context "ind2=0" do
        context "260" do
          context "online image coll - Stanford" do
            let(:g) {
              marcxml_str =
                '<record xmlns="http://www.loc.gov/MARC21/slim">
                  <leader>01998cka a2200385Ka 4500</leader>
                  <controlfield tag="001">856_ind2_0_w260</controlfield>
                  <controlfield tag="008">040518s1891    cau           s   kneng d</controlfield>
                  <datafield ind1="1" ind2="0" tag="245">
                    <subfield code="a">Fancher Creek ranch, property of James Karnes, Fresno Co.</subfield>
                    <subfield code="h">[electronic resource] ;</subfield>
                    <subfield code="b">Home ranch &amp; residence of James Karnes, 3 miles S. of Sanger.</subfield>
                  </datafield>
                  <datafield ind1=" " ind2=" " tag="260">
                    <subfield code="c">[1891]</subfield>
                  </datafield>
                  <datafield ind1="4" ind2="0" tag="856">
                    <subfield code="u">http://www.davidrumsey.com/long_url</subfield>
                  </datafield>
                </record>'
              self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '856_ind2_0_w260')
            }
            it '2 Instances' do
              expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
            end
            it '2 instanceOf' do
              expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
            end
            it 'single Work' do
              expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
            end
            it 'no direct relationship between Instances' do
              expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
            end
          end # online image coll - Stanford
          context "online image coll - LC" do
            let(:g) {
              marcxml_str =
                '<record xmlns="http://www.loc.gov/MARC21/slim">
                  <leader>02847cam a2200493 a 4500</leader>
                  <controlfield tag="001">12035509</controlfield>
                  <controlfield tag="008">990629m20009999dcugh        f000 0 eng  </controlfield>
                  <datafield tag="245" ind1="0" ind2="0">
                    <subfield code="a">Historic American sheet music, 1850-1920</subfield>
                    <subfield code="h">[electronic resource] :</subfield>
                    <subfield code="b">selected from the collections of Duke University.</subfield>
                  </datafield>
                  <datafield tag="260" ind1=" " ind2=" ">
                    <subfield code="a">[Washington, D.C.] :</subfield>
                    <subfield code="b">Library of Congress,</subfield>
                    <subfield code="c">1999-</subfield>
                  </datafield>
                  <datafield tag="856" ind1="4" ind2="0">
                    <subfield code="u">http://hdl.loc.gov/loc.gdc/collgdc.gc000022</subfield>
                  </datafield>
                </record>'
              self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '12035509')
            }
            it '2 Instances' do
              expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
            end
            it '2 instanceOf' do
              expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
            end
            it 'single Work' do
              expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
            end
            it 'no direct relationship between Instances' do
              expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
            end
          end # online image coll - LC
        end # 260
        context "264" do
          it 'need example 856 ind2=0, 264, no 300' do
            fail 'need example 856 ind2=0, 264, no 300'
          end
        end  # 264
      end # ind2=0

      context "ind2=1" do
        context "260" do
          it 'need example 856 ind2=1, 260 but no 300' do
            fail 'need example 856 ind2=1, 260 but no 300'
          end
        end # 260
        context "264" do
          it 'need example 856 ind2=1, 264 but no 300' do
            fail 'need example 856 ind2=1, 264 but no 300'
          end
        end # 264
      end # ind2=1

      context "ind2=2" do
        context "260" do
          it 'if ind2=2 should create bf:Instance, need example 856 ind2=2, 260 but no 300' do
            fail 'if ind2=2 should create bf:Instance, need example 856 ind2=2, 260 but no 300'
          end
        end # 260
        context "264" do
          it 'if ind2=2 should create bf:Instance, need example 856 ind2=2, 264 but no 300' do
            fail 'if ind2=2 should create bf:Instance, need example 856 ind2=2, 264 but no 300'
          end
        end # 264
      end # ind2=2

      context "ind2=8" do
        context "260" do
          it 'if ind2=8 should create bf:Instance, need example 856 ind2=8, 260 but no 300' do
            fail 'if ind2=8 should create bf:Instance, need example 856 ind2=8, 260 but no 300'
          end
        end # 260
        context "264" do
          it 'if ind2=8 should create bf:Instance, need example 856 ind2=8, 264 but no 300' do
            fail 'if ind2=8 should create bf:Instance, need example 856 ind2=8, 264 but no 300'
          end
        end # 264
      end # ind2=8

      context "ind2=blank" do
        context "260" do
          it 'if ind2=blank should create bf:Instance, need example 856 ind2=blank, 260 but no 300' do
            fail 'if ind2=blank should create bf:Instance, need example 856 ind2=blank, 260 but no 300'
          end
        end # 260
        context "264" do
          it 'if ind2=blank should create bf:Instance, need example 856 ind2=blank, 264 but no 300' do
            fail 'if ind2=blank should create bf:Instance, need example 856 ind2=blank, 264 but no 300'
          end
        end # 264
      end # ind2=blank

      context "mult 856" do
        context "260" do
          it 'need example mult 856, 260 but no 300' do
            fail 'need example mult 856, 260 but no 300'
          end
        end # 260
        context "264" do
          it 'need example mult 856, 264 but no 300' do
            fail 'need example mult 856, 264 but no 300'
          end
        end # 264
      end # mult 856
    end # ind1=4

    context "ind1 not 4" do
      # only test data found for this so far has 2nd 856 for urn;  see 260 + 300 + 856 below
      context "260" do
        it 'need example 856 ind1 not 4, 260 but no 300' do
          fail 'need example 856 ind1 not 4, 260 but no 300'
        end
      end # 260
      context "264" do
        it 'need example 856 ind1 not 4, 264 but no 300' do
          fail 'need example 856 ind1 not 4, 264 but no 300'
        end
      end # 264
    end # ind1 not 4
  end # 26x and 856, no 300

  context '300 and 856, no 26x' do
    context "ind1=4" do
      context "ind2=0" do
        it 'need example 856 ind2=0, 300 but no 26x' do
          fail 'need example 856 ind2=0, 300 but no 26x'
        end
      end # ind2=0

      context "ind2=1" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>06411cpcaa2201021 i 4500</leader>
              <controlfield tag="001">5802339_one856</controlfield>
              <controlfield tag="008">780918||||||||||||                 eng  </controlfield>
              <datafield tag="245" ind1="0" ind2="0">
                <subfield code="a">Abraham Lincoln papers,</subfield>
                <subfield code="f">1774-1948.</subfield>
              </datafield>
              <datafield tag="300" ind1=" " ind2=" ">
                <subfield code="a">40,550</subfield>
                <subfield code="f">items.</subfield>
              </datafield>
              <datafield tag="856" ind1="4" ind2="1">
                <subfield code="3">Abraham Lincoln Papers at the Library of Congress</subfield>
                <subfield code="u">http://hdl.loc.gov/loc.mss/collmss.ms000005</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '5802339_one856')
        }
        it '2 Instances' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
        end
        it '2 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
        end
        it 'single Work' do
          expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
        end
        it 'no direct relationship between Instances' do
          expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
        end
      end # ind2=1

      context "ind2=2" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01855cemaa22003131a 4500</leader>
              <controlfield tag="001">856_300_no26x_ind2_2</controlfield>
              <controlfield tag="008">020123q14861865sa                  eng u</controlfield>
              <datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Dr. Oscar I. Norwich collection of maps of Africa and its islands,</subfield>
                <subfield code="f">1486 - ca. 1865.</subfield>
              </datafield>
              <datafield ind1=" " ind2=" " tag="300">
                <subfield code="a">312 items.</subfield>
              </datafield>
              <datafield ind1="4" ind2="2" tag="856">
                <subfield code="3">Finding aid available online</subfield>
                <subfield code="u">http://www.oac.cdlib.org/findaid/ark:/13030/kt787007h3</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '856_300_no26x_ind2_2')
        }
        it 'should ind2=2 create bf:Instance?' do
          pending 'should ind2=2 create bf:Instance?'
        end
        it '1 Instance' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
        end
        it '1 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
        end
        it '856 ind2=2 becomes bf:Annotation' do
          solns = g.query(InstanceHelpers::ANNOTATION_BODY_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.annotationBody).to eq RDF::URI.new('http://www.oac.cdlib.org/findaid/ark:/13030/kt787007h3')
        end
        it 'single Work' do
          expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
        end
      end # ind2=2

      context "ind2=8" do
        it 'if ind2=8 should create bf:Instance, need example 856 ind2=8, 300 but no 26x' do
          fail 'if ind2=8 should create bf:Instance, need example 856 ind2=8, 300 but no 26x'
        end
      end # ind2=8

      context "ind2=blank" do
        context "mult 856" do
          let(:g) {
            marcxml_str =
              '<record xmlns="http://www.loc.gov/MARC21/slim">
                <leader>03469cpcaa2200589 a 4500</leader>
                <controlfield tag="001">14923309</controlfield>
                <controlfield tag="008">070711||||||||||||                 eng  </controlfield>
                <datafield tag="245" ind1="0" ind2="0">
                  <subfield code="a">Robert Todd Lincoln family papers,</subfield>
                </datafield>
                <datafield tag="300" ind1=" " ind2=" ">
                  <subfield code="a">2,845</subfield>
                  <subfield code="f">items.</subfield>
                </datafield>
                <datafield tag="856" ind1="4" ind2=" ">
                  <subfield code="3">Finding aid</subfield>
                  <subfield code="u">http://hdl.loc.gov/loc.mss/eadmss.ms010093</subfield>
                </datafield>
                <datafield tag="856" ind1="4" ind2=" ">
                  <subfield code="3">Finding aid (PDF)</subfield>
                  <subfield code="u">http://hdl.loc.gov/loc.mss/eadmss.ms010093.3</subfield>
                </datafield>
              </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '14923309')
          }
          it 'should ind2=blank create bf:Instance?' do
            pending 'should ind2=blank create bf:Instance?'
          end
          it '1 Instance' do
            expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
          end
          it '1 instanceOf' do
            expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
          end
          it '856 ind2=blank become bf:Annotations' do
            solns = g.query(InstanceHelpers::ANNOTATION_BODY_SPARQL_QUERY)
            expect(solns.size).to eq 2
            solns.each { |soln|
              anno_url = soln.annotationBody.to_s
              expect(anno_url).to match /^http\:\/\/hdl\.loc\.gov\/loc\.mss\/eadmss\.ms010093/
            }
          end
          it 'single Work' do
            expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
          end
        end # mult 856
      end # ind2=blank

      context "mult 856" do
        it 'need example mult 856, 300 but no 26x' do
          fail 'need example mult 856, 300 but no 26x'
        end
      end # mult 856

    end # ind1=4

    context "ind1 not 4" do
      it 'need example 856 ind1 not 4, 300 but no 26x' do
        # only test data found for this so far has 2nd 856 for urn;  see 260 + 300 + 856 below
        fail 'need example 856 ind1 not 4, 300 but no 26x'
      end
    end # ind1 not 4
  end # 300 and 856, no 26x

  context '26x, 300 and 856' do
    context "ind1=4" do
      context "ind2=0" do
        context "260" do
          let(:g) {
            marcxml_str =
              '<record xmlns="http://www.loc.gov/MARC21/slim">
                <leader>06174nam a2200445Ia 4500</leader>
                <controlfield tag="001">856_ind2_0_w_260_300</controlfield>
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
                <datafield ind1="4" ind2="0" tag="856">
                  <subfield code="z">Available to Stanford-affiliated users at:</subfield>
                  <subfield code="z">Safari Books Online</subfield>
                  <subfield code="u">http://proquest.safaribooksonline.com/?uiCode=stanford&amp;xmlId=9780470149263</subfield>
                  <subfield code="x">eLoaderURL</subfield>
                  <subfield code="x">sf4</subfield>
                  <subfield code="x">sfocm243693217</subfield>
                </datafield>
              </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '856_ind2_0_w_260_300')
          }
          it '2 Instances' do
            expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
          end
          it '2 instanceOf' do
            expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
          end
          it 'single Work' do
            expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to be 1
          end
          it 'no direct relationship between Instances' do
            expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
          end
        end # 260
        context "264" do
          let(:g) {
            marcxml_str =
              '<record xmlns="http://www.loc.gov/MARC21/slim">
                <leader>03714njm a2200649Ki 4500</leader>
                <controlfield tag="001">856_ind2_0_w_264_300</controlfield>
                <controlfield tag="008">150406s2010    ne synn o         n ger d</controlfield>
                <datafield ind1="1" ind2="0" tag="245">
                  <subfield code="a">Symphony no. 3 /</subfield>
                  <subfield code="c">Mahler.</subfield>
                </datafield>
                <datafield ind1=" " ind2="1" tag="264">
                  <subfield code="a">[Netherlands] :</subfield>
                  <subfield code="b">RCO Live,</subfield>
                  <subfield code="c">[2010]</subfield>
                </datafield>
                <datafield ind1=" " ind2=" " tag="300">
                  <subfield code="a">1 online resource (1 sound file)</subfield>
                </datafield>
                <datafield ind1="4" ind2="0" tag="856">
                  <subfield code="z">Available to Stanford-affiliated users.</subfield>
                  <subfield code="u">http://ezproxy.stanford.edu/login?url=http://stanford.naxosmusiclibrary.com/catalogue/item.asp?cid=RCO10004</subfield>
                  <subfield code="y">Naxos Music Library</subfield>
                  <subfield code="x">eLoaderURL</subfield>
                  <subfield code="x">nm4</subfield>
                  <subfield code="x">nmocn906565258</subfield>
                </datafield>
              </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '856_ind2_0_w_264_300')
          }
          it '2 Instances' do
            expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
          end
          it '2 instanceOf' do
            expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
          end
          it 'single Work' do
            expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to be 1
          end
          it 'no direct relationship between Instances' do
            expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
          end
        end # 264
      end # ind2=0

      context "ind2=1" do
        context "260" do
          let(:g) {
            marcxml_str =
              '<record xmlns="http://www.loc.gov/MARC21/slim">
                <leader>03995ckd a2200637 a 4500</leader>
                <controlfield tag="001">16530652</controlfield>
                <controlfield tag="008">101103i18391950xx nnn            kneng  </controlfield>
                <datafield tag="245" ind1="0" ind2="0">
                  <subfield code="a">Sheet music, fables, miscellaneous 19th century periodicals blah blah</subfield>
                  <subfield code="h">[graphic].</subfield>
                </datafield>
                <datafield tag="260" ind1=" " ind2=" ">
                  <subfield code="c">1839-1950.</subfield>
                </datafield>
                <datafield tag="300" ind1=" " ind2=" ">
                  <subfield code="a">67 prints :</subfield>
                  <subfield code="b">chiefly lithographs, wood engravings, letterpress, offset, and halftone, some color ;</subfield>
                  <subfield code="c">sheets 42 x 30 cm or smaller, vertical and horizontal orientation.</subfield>
                </datafield>
                <datafield tag="856" ind1="4" ind2="1">
                  <subfield code="z">Search for images in Prints &amp; Photographs Online Catalog</subfield>
                  <subfield code="u">http://lcweb2.loc.gov/pp/cphquery.html</subfield>
                </datafield>
              </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '16530652')
          }
          it '2 Instances' do
            expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
          end
          it '2 instanceOf' do
            expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
          end
          it 'single Work' do
            expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to be 1
          end
          it 'no direct relationship between Instances' do
            expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
          end
        end # 260
        context "264" do
          it 'need example 856 ind2=1, 264, 300' do
            fail 'need example 856 ind2=1, 264, 300'
          end
        end # 264
      end # ind2=1

      context "ind2=2" do
        context "260" do
          context "cover image" do
            let(:g) {
              marcxml_str =
                '<record xmlns="http://www.loc.gov/MARC21/slim">
                  <leader>03022cam a2200481 i 4500</leader>
                  <controlfield tag="001">16574557</controlfield>
                  <controlfield tag="008">101210t20112011inua          001 0 eng  </controlfield>
                  <datafield tag="245" ind1="1" ind2="0">
                    <subfield code="a">Introducing ZBrush 4 /</subfield>
                    <subfield code="c">Eric Keller.</subfield>
                  </datafield>
                  <datafield tag="250" ind1=" " ind2=" ">
                    <subfield code="a">1st Edition.</subfield>
                  </datafield>
                  <datafield tag="260" ind1=" " ind2=" ">
                    <subfield code="a">Indianapolis, Indiana :</subfield>
                    <subfield code="b">Wiley Publishing, Inc.,</subfield>
                    <subfield code="c">[2011], &#xA9;2011.</subfield>
                  </datafield>
                  <datafield tag="300" ind1=" " ind2=" ">
                    <subfield code="a">xxi, 489 pages :</subfield>
                    <subfield code="b">illustrations ;</subfield>
                    <subfield code="c">24 cm +</subfield>
                    <subfield code="e">1 computer disc (DVD-ROM ; 4 3/4 in.)</subfield>
                  </datafield>
                  <datafield tag="856" ind1="4" ind2="2">
                    <subfield code="3">Cover image</subfield>
                    <subfield code="u">http://catalogimages.wiley.com/images/db/jimages/9780470527641.jpg</subfield>
                  </datafield>
                </record>'
              self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '16574557')
            }
            it 'should ind2=2 create bf:Instance?' do
              pending 'should ind2=2 create bf:Instance?'
            end
            it '1 Instance' do
              expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
            end
            it '1 instanceOf' do
              expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
            end
            it 'single Work' do
              expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
            end
            it '856 ind2=2 becomes bf:Annotation' do
              solns = g.query(InstanceHelpers::ANNOTATION_BODY_SPARQL_QUERY)
              expect(solns.size).to eq 1
              expect(solns.first.annotationBody).to eq RDF::URI('http://catalogimages.wiley.com/images/db/jimages/9780470527641.jpg')
            end
          end # cover image
        end # 260
        context "264" do
          it 'if ind2=2 should create bf:Instance, need example data 856 ind2=2, 264, 300' do
            fail 'if ind2=2 should create bf:Instance, need example data 856 ind2=2, 264, 300'
          end
        end # 264
      end # ind2=2

      context "ind2=8" do
        context "260" do
          it 'if ind2=8 should create bf:Instance, need example 856 ind2=8, 260, 300' do
            fail 'if ind2=8 should create bf:Instance, need example 856 ind2=8, 260, 300'
          end
        end # 260
        context "264" do
          it 'if ind2=8 should create bf:Instance, need example 856 ind2=8, 264, 300' do
            fail 'if ind2=8 should create bf:Instance, need example 856 ind2=8, 264, 300'
          end
        end # 264
      end # ind2=8

      context "ind2=blank" do
        context "260" do
          let(:g) {
            marcxml_str =
              '<record xmlns="http://www.loc.gov/MARC21/slim">
                <leader>02195cam a2200433 a 4500</leader>
                <controlfield tag="001">17439166</controlfield>
                <controlfield tag="008">830121s1788    fr bf         000 0 fre d</controlfield>
                <datafield tag="245" ind1="1" ind2="0">
                  <subfield code="a">Conside&#x301;rations sur la guerre actuelle des Turcs /</subfield>
                  <subfield code="c">par Mr. de Volney.</subfield>
                </datafield>
                <datafield tag="260" ind1=" " ind2=" ">
                  <subfield code="a">A&#x300; Londres [i.e. Paris :</subfield>
                  <subfield code="b">s.n.],</subfield>
                  <subfield code="c">1788.</subfield>
                </datafield>
                <datafield tag="300" ind1=" " ind2=" ">
                  <subfield code="a">[2], 140, [4] p., [1] folded leaf of plates :</subfield>
                  <subfield code="b">1 map ;</subfield>
                  <subfield code="c">21 cm. (8vo)</subfield>
                </datafield>
                <datafield tag="856" ind1="4" ind2=" ">
                  <subfield code="u">http://www.mdz-nbn-resolving.de/urn/resolver.pl?urn=urn:nbn:de:bvb:12-bsb10557843-1</subfield>
                  <subfield code="x">Resolving-System</subfield>
                  <subfield code="z">kostenfrei</subfield>
                  <subfield code="3">Volltext // 2011 digitalisiert von: Bayerische Staatsbibliothek, blah</subfield>
                </datafield>
              </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '17439166')
          }
          it 'should ind2=blank create bf:Instance?' do
            pending 'should ind2=blank create bf:Instance?'
          end
          it '1 Instance' do
            expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
          end
          it '1 instanceOf' do
            expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
          end
          it 'single Work' do
            expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to eq 1
          end
          it '856 ind2=blank becomes bf:Annotation' do
            solns = g.query(InstanceHelpers::ANNOTATION_BODY_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.annotationBody).to eq RDF::URI('http://www.mdz-nbn-resolving.de/urn/resolver.pl?urn=urn:nbn:de:bvb:12-bsb10557843-1')
          end
        end # 260
        context "264" do
          it 'if ind2=blank should create bf:Instance, need example 856 ind2=blank, 264, 300' do
            fail 'if ind2=blank should create bf:Instance, need example 856 ind2=blank, 264, 300'
          end
        end # 264
      end # ind2=blank

      context "mult 856" do
        context "260" do
          it 'need example mult 856, 260, 300' do
            fail 'need example mult 856, 260, 300'
          end
        end # 260
        context "264" do
          it 'need example mult 856, 264, 300' do
            fail 'need example mult 856, 264, 300'
          end
        end # 264
      end # mult 856

    end # ind1=4

    context "ind1 blank" do
      context "mult 856 one ind1 blank" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01523cam a2200361 a 4500</leader>
                <controlfield tag="001">856_ind1_blank</controlfield>
                <controlfield tag="008">110715s2007    sw a     b    000 0 swe  </controlfield>
                <datafield tag="245" ind1="1" ind2="0">
                  <subfield code="a">Mellan massan och Marx :</subfield>
                  <subfield code="b">en studie av den politiska kampen inom fackfo&#x308;reningsro&#x308;relsen i Hofors 1917-1946 /</subfield>
                  <subfield code="c">Stefan Dalin.</subfield>
                </datafield>
                <datafield tag="260" ind1=" " ind2=" ">
                  <subfield code="a">Umea&#x30A; :</subfield>
                  <subfield code="b">Institutionen fo&#x308;r historiska studier, Umea&#x30A; universitet,</subfield>
                  <subfield code="c">c2007.</subfield>
                </datafield>
                <datafield tag="300" ind1=" " ind2=" ">
                  <subfield code="a">vi, 269 p. :</subfield>
                  <subfield code="b">ill. ;</subfield>
                  <subfield code="c">24 cm.</subfield>
                </datafield>
                <datafield tag="856" ind1=" " ind2="1">
                  <subfield code="u">urn:nbn:se:umu:diva-1450</subfield>
                </datafield>
                <datafield tag="856" ind1="4" ind2="1">
                  <subfield code="u">http://urn.kb.se/resolve?urn=urn:nbn:se:umu:diva-1450</subfield>
                </datafield>
              </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '856_ind1_blank')
        }
        # made Instance for 856 ind1=4;  made bf:Annotation for 856 ind1=blank
        it 'should ind1=blank create bf:Instance?' do
          pending 'should ind1=blank create bf:Instance?'
        end
        it '2 Instances' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
        end
        it '2 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
        end
        it '856 ind1=blank becomes bf:Annotation' do
          solns = g.query(InstanceHelpers::ANNOTATION_BODY_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.annotationBody).to eq RDF::URI('urn:nbn:se:umu:diva-1450')
        end
        it 'single Work' do
          expect(g.query(WorkHelpers::WORK_SPARQL_QUERY).size).to be 1
        end
        it 'no direct relationship between Instances' do
          expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
        end
      end # mult 856 one blank
    end # ind1 blank
  end # 26x, 300 and 856

end
