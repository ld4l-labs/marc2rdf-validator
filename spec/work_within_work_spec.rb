require 'spec_helper'
require 'linkeddata'

describe 'work within the work described by the MARC record' do

  # Stanford:
  # MARC fields that identify “a work within the described by the record”:
  # 505
  # 700-711 with ind2 = 2 and ‡t
  # 730|740 with ind2 = 2

  # marc2bibframe xquery converter
  # ???

  let(:marc_ldr_001_008) {
    '<record xmlns="http://www.loc.gov/MARC21/slim">
      <leader>01855cemaa22003131a 4500</leader>
      <controlfield tag="001">aRECORD_ID</controlfield>
      <controlfield tag="008">760219s1925    en            000 0 eng  </controlfield>'
  }
  let(:work_squery) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  SELECT DISTINCT ?work
                  WHERE {
                    ?work a bf:Work .
                  }") }
  let(:main_part_work_sqy) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  SELECT DISTINCT ?mainwork ?workpart
                  WHERE {
                    ?mainwork a bf:Work .
                    ?mainwork bf:hasPart ?workpart .
                    ?workpart a bf:Work .
                  }") }

  context "505" do
    # ind1  0 (Contents), 1 (Incomplete contents), 2 (Partial contents)
    context "ind1 = 0" do
      context "‡a (formatted contents note)" do
        context "-- no spaces" do
          let(:g) {
            rec_id = 'dashes_no_spaces'
            marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
              '<datafield ind1="0" ind2="0" tag="245">
                <subfield code="a">Dennis Brain:</subfield>
                <subfield code="b">The art of the French horn.</subfield>
                <subfield code="h">[Sound recording]</subfield>
              </datafield>
              <datafield ind1="0" ind2=" " tag="505">
                <subfield code="a">Brahms.  Horn trio in E flat, op. 40.--Mozart.  Horn quintet in E flat, K. 407.--Marais, M. Le basque.</subfield>
              </datafield>
            </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
          }
          it '4 works' do
            expect(g.query(work_squery).size).to eq 4
          end
          it 'main work hasPart each 505 work' do
            expect(g.query(main_part_work_sqy).size).to eq 3
          end
        end # -- no spaces
        context "-- spaces" do
          let(:g) {
            rec_id = 'semicolons'
            marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
              '<datafield ind1="0" ind2="4" tag="245">
                <subfield code="a">The world\'s greatest animation</subfield>
                <subfield code="h">[videorecording] /</subfield>
                <subfield code="c">produced by Terry Thoren.</subfield>
              </datafield>
              <datafield ind1="0" ind2=" " tag="505">
                <subfield code="a">Creature comforts -- Balance -- Technological threat -- The cat came back -- Your face -- A Greek tragedy -- Anna and Bella -- The big snit -- Charade -- Sundae in New York -- The great cognito -- Tango -- Crac -- The fly -- Every child -- Special delivery.</subfield>
              </datafield>
            </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
          }
          it '17 works' do
            expect(g.query(work_squery).size).to eq 17
          end
          it 'main work hasPart each 505 work' do
            expect(g.query(main_part_work_sqy).size).to eq 16
          end
        end # -- spaces
        context "-- and semicolons" do
          let(:g) {
            rec_id = 'semicolons'
            marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
              '<datafield ind1="1" ind2="4" tag="245">
                <subfield code="a">The complete birth of the cool</subfield>
                <subfield code="h">[sound recording].</subfield>
              </datafield>
              <datafield ind1="0" ind2=" " tag="505">
                <subfield code="a">The studio sessions. Move (2:33) ; Jeru (3:13) ; Moon dreams (3:19) ; Venus de Milo (3; 13) ; Budo (2:34) ; Deception (2:49) ; Godchild (3:11) ; Boplicity (3:00) ; Rocker (3:06) ; Israel (2:18) ; Rouge (3:15) ; Darn that dream (3:25) -- The live sessions. Birth of the cool theme (0:19) ; Symphony Sid announces the band (1:02) ; Move (3:40) ; Why do I love you (3:41) ; Godchild (5:51) ; Symphony Sid introduction (0:27) ; S\'il vous plait (4:22) ; Moon dreams (5:06) ; Budo (Hallucination) (1:25) ; Darn that dream (4:25) ; Move (4:48) ; Moon dreams (3:46) ; Budo (Hallucinations) (4:23).</subfield>
              </datafield>
            </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
          }
          it '3 works' do
            expect(g.query(work_squery).size).to eq 3
          end
          it 'main work hasPart each 505 work' do
            expect(g.query(main_part_work_sqy).size).to eq 2
          end
        end # -- and semicolons
        context "-|-  (Nielsen)" do
          #https://github.com/sul-dlss/SearchWorks/blob/c8da26f975a44d99849670a1212097230a6b8758/app/helpers/marc_helper.rb#L273
        end
        context "mult 505s" do
          let(:g) {
            rec_id = '505_mult_w_a'
            marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
              '<datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Symphony no. 3 /</subfield>
                <subfield code="c">Mahler.</subfield>
              </datafield>
              <datafield ind1="0" ind2=" " tag="505">
                <subfield code="a">CD 1. Kräftig, Entschieden (Der Sommer marschiert ein) (34:19).</subfield>
              </datafield>
              <datafield ind1="0" ind2=" " tag="505">
                <subfield code="a">CD 2. Tempo di Menuetto. Sehr mässig (Was mir die Blumen auf der Wiese erzählen) (9:54) -- Comodo. Scherzando. Ohne Hast (Was mir die Tiere im Walde erzählen) (17:37) -- Sehr Langsam. Misterioso. Durchaus ppp: &quot;O Mensch! Gib Acht!&quot; (Was mir die Nacht erzählt) (9:01) -- Listig im tempo und keck im Ausdruck: &quot;Es sungen drei Engel&quot; (Was mir die Morgenglocken erzählen) (4:20) -- Langsam. Ryhevoll. Empfunden (Was mir die Liebe erzählt) (22:57).</subfield>
              </datafield>
            </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
          }
          it '4 works' do
            expect(g.query(work_squery).size).to eq 4
          end
          it 'main work hasPart each 505 work' do
            expect(g.query(main_part_work_sqy).size).to eq 3
          end
        end # mult 505s
      end # ‡a

      context "‡t (title)" do
        context "single ‡t" do
          let(:g) {
            rec_id = '505_mult_t'
            marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
              '<datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Fake</subfield>
              </datafield>
              <datafield ind1="0" ind2="0" tag="505">
                <subfield code="t">fake content</subfield>
              </datafield>
            </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
          }
          it '2 works' do
            expect(g.query(work_squery).size).to eq 2
          end
          it 'main work hasPart each 505 work' do
            expect(g.query(main_part_work_sqy).size).to eq 1
          end
        end
        context "multiple ‡t" do
          let(:g) {
            rec_id = '505_mult_t'
            marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
              '<datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Birth of the cool /</subfield>
                <subfield code="c">Miles Davis.</subfield>
              </datafield>
              <datafield ind1="0" ind2="0" tag="505">
                <subfield code="t">Birth of the cool theme --</subfield>
                <subfield code="t">Boplicity (Be bop lives) --</subfield>
                <subfield code="t">Budo --</subfield>
                <subfield code="t">Deception --</subfield>
                <subfield code="t">Godchild --</subfield>
                <subfield code="t">Israel --</subfield>
                <subfield code="t">Jeru --</subfield>
                <subfield code="t">Joost at the roost --</subfield>
                <subfield code="t">Moon dreams --</subfield>
                <subfield code="t">Move --</subfield>
                <subfield code="t">Rock salt a.k.a. rocker --</subfield>
                <subfield code="t">Rouge --</subfield>
                <subfield code="t">Venus de Milo.</subfield>
              </datafield>
            </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
          }
          it '14 works' do
            expect(g.query(work_squery).size).to eq 14
          end
          it 'main work hasPart each 505 work' do
            expect(g.query(main_part_work_sqy).size).to eq 13
          end
        end # multiple ‡t
        context "multiple 505" do
          let(:g) {
            rec_id = '505_mult_w_t'
            marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
              '<datafield ind1="0" ind2="0" tag="245">
                <subfield code="a">WWII, the ultimate collection</subfield>
                <subfield code="h">[videorecording] :</subfield>
                <subfield code="b">30 films.</subfield>
              </datafield>
              <datafield ind1="0" ind2="0" tag="505">
                <subfield code="g">Disc 1:</subfield>
                <subfield code="t">The true glory</subfield>
                <subfield code="g">(1945, b&amp;w, 84 min.) /</subfield>
                <subfield code="r">narrated by Dwight D. Eisenhower --</subfield>
                <subfield code="t">Know your enemy: Japan</subfield>
                <subfield code="g">(1944, b&amp;w, 63 min.) /</subfield>
                <subfield code="r">directed by Frank Capra --</subfield>
                <subfield code="t">Target for tonight</subfield>
                <subfield code="g">(1941, b&amp;w, 50 min.) /</subfield>
                <subfield code="r">writer/director, Harry Wyatt.</subfield>
              </datafield>
              <datafield ind1="8" ind2="0" tag="505">
                <subfield code="g">Disc 3:</subfield>
                <subfield code="t">Prelude to war</subfield>
                <subfield code="g">(1942, b&amp;w, 52 min.) /</subfield>
                <subfield code="r">Frank Capra --</subfield>
                <subfield code="t">Adolf Hitler</subfield>
                <subfield code="g">(1948, b&amp;w, 80 min.)</subfield>
              </datafield>
            </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
          }
          it '6 works' do
            expect(g.query(work_squery).size).to eq 6
          end
          it 'main work hasPart each 505 work' do
            expect(g.query(main_part_work_sqy).size).to eq 5
          end
        end # mult 505
      end # ‡t
    end # ind1 = 0

    context "ind1 = 1" do
      context "‡a (formatted contents note)" do
        context "-- no spaces" do
          let(:g) {
            rec_id = 'dashes_no_spaces'
            marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
              '<datafield ind1="0" ind2="4" tag="245">
                <subfield code="a">The Mack Sennett collection.</subfield>
                <subfield code="n">Vol. one.</subfield>
              </datafield>
              <datafield ind1="1" ind2=" " tag="505">
                <subfield code="a">disc 1. The curtain pole (1909) / American Biograph ; director, D.W. Griffith, author, Mack Sennett ; cast: Mack Sennett, Harry Solter, Florence Lawrence (10:02).  The manicure lady (1911) / American Biograph ; director, Mack Sennett ; author, Edwin August ; cast: Mack Sennett, Vivian Prescott, Eddie Dillon, Kate Bruce (11:22). Bonus features: The water nymph and bathing beauties (outtakes and rushes, 9:01); The Mack Sennett Studio (1:03); The Crossroads of New York [trailer] (1:22); The Sennett Story by Joe Adamson.</subfield>
              </datafield>
              <datafield ind1="8" ind2=" " tag="505">
                <subfield code="a">-- disc 2. Her torpedoed love (1917) / Triangle Keystone ; director, Frank C. Griffin ; cast: Louise Fazenda, Ford Sterling (21:08). A clever dummy (1917) / Triangle Keystone ; director, Herman C. Raymaker ; cast: Ben Turpin, Chester Conklin, Wallace Beery (19:23). Bonus features: Mack Sennett on the air (Textaco Star Theatre, 1939, 30:00, Lawrence Welk Show 1949, 3:00), Meet the stars: Stars past and present (dedication of the Mabel Normand soundstage, 1941, 6:39), Erskine Johnson\'s Hollywood reel (1950, 2:57); Mack Sennett\'s 70th birthday party (1950, 5:18).</subfield>
              </datafield>
            </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
          }
          it '4 works' do
            expect(g.query(work_squery).size).to eq 4
          end
          it 'main work hasPart each 505 work' do
            expect(g.query(main_part_work_sqy).size).to eq 3
          end
        end # -- no spaces
      end # ‡a
    end # ind1 = 1

    context "ind1 = 2" do
      it 'need example data 505 ind1 =2' do
        fail 'need example data 505 ind1 =2'
      end
    end # ind1 = 2
  end # 505

  context "700-711 with ind2 = 2 and ‡t" do
    context "700" do
      context "ind2 = 2" do
        context "with ‡t" do
          let(:g) {
            rec_id = '700_t'
            marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
              '<datafield ind1="0" ind2="0" tag="245">
                <subfield code="a">Symphonies nos. 3 and 4 /</subfield>
                <subfield code="c">Gustav Mahler.</subfield>
              </datafield>
              <datafield ind1="1" ind2="2" tag="700">
                <subfield code="a">Mahler, Gustav,</subfield>
                <subfield code="d">1860-1911.</subfield>
                <subfield code="t">Symphonies,</subfield>
                <subfield code="n">no. 4,</subfield>
                <subfield code="r">G major.</subfield>2 work
                <subfield code="=">^A893495</subfield>
              </datafield>
            </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
          }
          it '2 works' do
            expect(g.query(work_squery).size).to eq 2
          end
          it 'main work hasPart for 700 work' do
            expect(g.query(main_part_work_sqy).size).to eq 1
          end
        end # with ‡t
        context "without ‡t" do
          let(:g) {
            rec_id = '700_no_t'
            marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
              '<datafield ind1="1" ind2="4" tag="245">
                <subfield code="a">The Grapes of Wrath :</subfield>
                <subfield code="k">videorecording / narrated by Donald Sutherland ; produced and written by Ricki Green ; produced by Cronkite-Ward Co.,</subfield>
                <subfield code="f">2000.</subfield>
              </datafield>
              <datafield ind1="1" ind2="2" tag="700">
                <subfield code="a">Sutherland, Donald,</subfield>
                <subfield code="d">1935-</subfield>
                <subfield code="=">^A515747</subfield>
              </datafield>
            </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
          }
          it '1 work' do
            expect(g.query(work_squery).size).to eq 1
          end
          it '0 main work hasPart' do
            expect(g.query(main_part_work_sqy).size).to eq 0
          end
        end # without ‡t
        context "mult with ‡t" do
          let(:g) {
            rec_id = 'mult_700_t'
            marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
              '<datafield ind1="0" ind2="0" tag="245">
                <subfield code="a">Dennis Brain:</subfield>
                <subfield code="b">The art of the French horn.</subfield>
                <subfield code="h">[Sound recording]</subfield>
              </datafield>
              <datafield ind1="1" ind2="2" tag="700">
                <subfield code="a">Brahms, Johannes,</subfield>
                <subfield code="d">1833-1897.</subfield>
                <subfield code="t">Trios,</subfield>
                <subfield code="m">piano, violin, horn,</subfield>
                <subfield code="n">op. 40,</subfield>
                <subfield code="r">E♭ major.</subfield>
                <subfield code="=">^A237843</subfield>
              </datafield>
              <datafield ind1="1" ind2="2" tag="700">
                <subfield code="a">Mozart, Wolfgang Amadeus,</subfield>
                <subfield code="d">1756-1791.</subfield>
                <subfield code="t">Quintets,</subfield>
                <subfield code="m">horn, violin, violas (2), cello,</subfield>
                <subfield code="n">K. 407,</subfield>
                <subfield code="r">E♭ major</subfield>
                <subfield code="=">^A710672</subfield>
              </datafield>
              <datafield ind1="1" ind2="2" tag="700">
                <subfield code="a">Marais, Marin,</subfield>
                <subfield code="d">1656-1728</subfield>
                <subfield code="t">Pièces de violes, 4e livre. 1ère partie. 39-40;</subfield>
                <subfield code="o">arranged.</subfield>
                <subfield code="=">^A238190</subfield>
              </datafield>
            </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
          }
          it '4 works' do
            expect(g.query(work_squery).size).to eq 4
          end
          it 'main work hasPart to 700 work' do
            expect(g.query(main_part_work_sqy).size).to eq 3
          end
        end # mult with ‡t
      end # ind2 = 2
      context "ind2 blank w ‡t" do
        let(:g) {
          rec_id = '700_ind2_blank_t'
          marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
            '<datafield ind1="0" ind2="4" tag="245">
              <subfield code="a">The grapes of wrath</subfield>
              <subfield code="h">[videorecording] /</subfield>
              <subfield code="c">Twentieth Century-Fox presents Darryl F. Zanuck\'s production ; directed by John Ford ; screenplay by Nunnally Johnson.</subfield>
            </datafield>
            <datafield ind1="1" ind2=" " tag="700">
              <subfield code="a">Steinbeck, John,</subfield>
              <subfield code="d">1902-1968.</subfield>
              <subfield code="t">Grapes of wrath.</subfield>
              <subfield code="=">^A2091926</subfield>
            </datafield>
          </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
        }
        it '1 work' do
          expect(g.query(work_squery).size).to eq 1
        end
        it '0 main work hasPart' do
          expect(g.query(main_part_work_sqy).size).to eq 0
        end
      end
    end # 700
    context "710" do
      context "ind 2 = 2" do
        context "with ‡t" do
          it 'need example 710 ind2 2 with ‡t' do
            fail 'need example 710 ind2 2 with ‡t'
          end
        end # with ‡t
        context "without ‡t" do
          let(:g) {
            rec_id = '710_no_t'
            marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
              '<datafield ind1="1" ind2="4" tag="245">
                <subfield code="a">The Grapes of Wrath :</subfield>
                <subfield code="k">videorecording / narrated by Donald Sutherland ; produced and written by Ricki Green ; produced by Cronkite-Ward Co.,</subfield>
                <subfield code="f">2000.</subfield>
              </datafield>
              <datafield ind1="2" ind2="2" tag="710">
                <subfield code="a">Cronkite Ward Company.</subfield>
                <subfield code="=">^A1623972</subfield>
              </datafield>
            </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
          }
          it '1 work' do
            expect(g.query(work_squery).size).to eq 1
          end
          it '0 main work hasPart' do
            expect(g.query(main_part_work_sqy).size).to eq 0
          end
        end # without ‡t
        context "mult with ‡t" do
          it 'need example mult 710 ind2 2 with ‡t' do
            fail 'need example mult 710 ind2 2 with ‡t'
          end
        end # mult with ‡t
      end # ind2 = 2
      # ind2 not 2 with ‡t?
      it 'need example 710 ind2 not 2 with ‡t' do
        fail 'need example 710 ind2 not 2 with ‡t'
      end
    end # 710
    context "711" do
      context "ind 2 = 2" do
        context "with ‡t" do
          it 'need example 711 ind2 = 2 with ‡t' do
            fail 'need example 711 ind2 = 2 with ‡t'
          end
        end # with ‡t
        context "without ‡t" do
          it 'need example 711 ind2 = 2 without ‡t' do
            fail 'need example 711 ind2 = 2 without ‡t'
          end
        end # without ‡t
        context "mult with ‡t" do
          it 'need example mult 711 ind2 = 2 with ‡t' do
            fail 'need example mult 711 ind2 = 2 with ‡t'
          end
        end # mult with ‡t
      end # ind2 = 2
      # ind2 not 2 with ‡t?
      it 'need example 711 ind2 not 2 with ‡t' do
        fail 'need example 711 ind2 not 2 with ‡t'
      end
    end # 711
  end  # 700-711 with ind2 = 2 and ‡t

  context "730" do
    context "ind2 = 2" do
      context "single 730" do
        let(:g) {
          rec_id = '730'
          marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
            '<datafield ind1="0" ind2="2" tag="245">
              <subfield code="a">L\'homme de Rio /</subfield>
              <subfield code="c">Les Films Ariane et Les Productions Artistes Associés présentent.</subfield>
            </datafield>
            <datafield ind1="0" ind2="2" tag="730">
              <subfield code="i">Contains (work):</subfield>
              <subfield code="a">Adventurs d\'Adrien.</subfield>
              <subfield code="?">UNAUTHORIZED</subfield>
            </datafield>
          </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
        }
        it '2 works' do
          expect(g.query(work_squery).size).to eq 2
        end
        it 'main work hasPart to 730 work' do
          expect(g.query(main_part_work_sqy).size).to eq 1
        end
      end # single 730
      context "multiple 730" do
        let(:g) {
          rec_id = '730_3_of_em'
          marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
            '<datafield ind1="0" ind2="0" tag="245">
              <subfield code="a">Creative loafing.</subfield>
            </datafield>
            <datafield ind1="0" ind2="2" tag="730">
              <subfield code="a">Atlantan.</subfield>
              <subfield code="?">UNAUTHORIZED</subfield>
            </datafield>
            <datafield ind1="0" ind2="2" tag="730">
              <subfield code="a">Femme.</subfield>
              <subfield code="?">UNAUTHORIZED</subfield>
            </datafield>
            <datafield ind1="0" ind2="2" tag="730">
              <subfield code="a">Vibes.</subfield>
              <subfield code="?">UNAUTHORIZED</subfield>
            </datafield>
          </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
        }
        it '4 works' do
          expect(g.query(work_squery).size).to eq 4
        end
        it 'main work hasPart to each 730 work' do
          expect(g.query(main_part_work_sqy).size).to eq 3
        end
      end # mult 730
    end # ind2 = 2
    context "ind2 blank" do
      let(:g) {
        rec_id = '730_ind2blank'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="0" ind2="0" tag="245">
            <subfield code="a">Alfred Hitchcock, the masterpiece collection</subfield>
            <subfield code="h">[videorecording].</subfield>
          </datafield>
          <datafield ind1="0" ind2=" " tag="730">
            <subfield code="a">Rope (Motion picture)</subfield>
            <subfield code="=">^A3046122</subfield>
          </datafield>
          <datafield ind1="0" ind2=" " tag="730">
            <subfield code="a">Rear window (Motion picture)</subfield>
            <subfield code="=">^A1268811</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it '1 work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it '0 main work hasPart' do
        expect(g.query(main_part_work_sqy).size).to eq 0
      end
    end # ind2 blank
  end # 730

  context "740" do
    context "ind2 = 2" do
      context "single 740" do
        let(:g) {
          rec_id = '740'
          marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
            '<datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">Fancher Creek ranch, property of James Karnes, Fresno Co.</subfield>
              <subfield code="h">[electronic resource] ;</subfield>
              <subfield code="b">Home ranch &amp; residence of James Karnes, 3 miles S. of Sanger.</subfield>
            </datafield>
            <datafield ind1="0" ind2="2" tag="740">
              <subfield code="a">Home ranch &amp; residence of James Karnes, 3 miles S. of Sanger.</subfield>
            </datafield>
         </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
        }
        it '2 works' do
          expect(g.query(work_squery).size).to eq 2
        end
        it 'main work hasPart to 740 work' do
          expect(g.query(main_part_work_sqy).size).to eq 1
        end
      end # single 740
      context "multiple 740" do
        let(:g) {
          rec_id = '740_twice'
          marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
            '<datafield ind1="0" ind2="0" tag="245">
              <subfield code="a">Julia Child</subfield>
              <subfield code="h">[videorecording] :</subfield>
              <subfield code="b">the French chef /</subfield>
              <subfield code="c">WGBH/Boston.</subfield>
            </datafield>
            <datafield ind1="0" ind2="2" tag="740">
              <subfield code="a">Julia Child!, America\'s favorite chef.</subfield>
            </datafield>
            <datafield ind1="0" ind2="2" tag="740">
              <subfield code="a">Julia Child, the French chef.</subfield>
            </datafield>
          </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
        }
        it '3 works' do
          expect(g.query(work_squery).size).to eq 3
        end
        it 'main work hasPart to each 740 work' do
          expect(g.query(main_part_work_sqy).size).to eq 2
        end
      end # mult 740
    end # ind2 = 2

    context "ind2 = 1" do
      let(:g) {
        rec_id = '740ind2_1'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="1" ind2="4" tag="245">
            <subfield code="a">The grapes of wrath.</subfield>
          </datafield>
          <datafield ind1="0" ind2="1" tag="740">
            <subfield code="a">Screenplay collection.</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it '1 work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it '0 main work hasPart' do
        expect(g.query(main_part_work_sqy).size).to eq 0
      end
    end # ind2 = 1

    context "ind2 blank" do
      let(:g) {
        rec_id = '740ind2blank'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="1" ind2="0" tag="245">
            <subfield code="6">880-01</subfield>
            <subfield code="a">Punno ŭi p\'odo =</subfield>
            <subfield code="b">The Grapes of wrath /</subfield>
            <subfield code="c">John E. Steinbeck ; Sisa Yŏngŏsa P\'yŏnjipkuk yŏk.</subfield>
          </datafield>
          <datafield ind1="0" ind2=" " tag="740">
            <subfield code="a">Grapes of wrath.</subfield>
          </datafield>
       </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it '1 work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it '0 main work hasPart' do
        expect(g.query(main_part_work_sqy).size).to eq 0
      end
    end # ind2 blank
  end # 740

end