require 'spec_helper'
require 'linkeddata'

describe 'the work described by the MARC record' do

  # Stanford:
  # MARC fields that identify “a work described by the record”:
  # 130
  # 100|110|111 and 240
  # 100|110|111 and 245
  # 245 (‡a) if no 1xx

  # marc2bibframe xquery converter
  # Each Bib Record creates a Work
  # PLUS
  # 130|240  # uniform title
  # 880 for 130|240  vernacular uniform title

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
  let(:work_title_value_squery) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  SELECT DISTINCT ?titleValue
                  WHERE {
                    ?work a bf:Work .
                    ?work bf:workTitle ?title .
                    ?title a bf:Title .
                    ?title bf:titleValue ?titleValue .
                  }") }
  let(:work_subtitle_squery) {
    SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                  SELECT DISTINCT ?subtitle
                  WHERE {
                    ?work a bf:Work .
                    ?work bf:workTitle ?title .
                    ?title a bf:Title .
                    ?title bf:subtitle ?subtitle .
                  }") }

  context "130" do
    context "‡a (+ 245) only" do
      let(:g) {
        rec_id = '130a_only'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="0" ind2=" " tag="130">
            <subfield code="a">Beowulf.</subfield>
          </datafield>
          <datafield ind1="0" ind2="0" tag="245">
            <subfield code="a">ignore me</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it 'work title from 130' do
        solns = g.query(work_title_value_squery)
        expect(solns.size).to eq 1
        title_value = solns.first.titleValue.to_s
        expect(title_value).to match(/Beowulf/)
        expect(title_value).not_to match(/ignore/)
      end
    end

    context "‡a ‡= (+ 245) only" do
      let(:g) {
        rec_id = '130a_equal'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="0" ind2=" " tag="130">
            <subfield code="a">Beowulf.</subfield>
            <subfield code="=">^A944917</subfield>
          </datafield>
          <datafield ind1="0" ind2="0" tag="245">
            <subfield code="a">ignore me</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it 'work title from 130' do
        solns = g.query(work_title_value_squery)
        expect(solns.size).to eq 1
        title_value = solns.first.titleValue.to_s
        expect(title_value).to match(/Beowulf/)
        expect(title_value).not_to match(/ignore/)
      end
    end

    context "‡a, ‡n, ‡? (+ 245) only" do
      let(:g) {
        rec_id = '130an_question_mark'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="0" ind2=" " tag="130">
            <subfield code="a">Annale.</subfield>
            <subfield code="n">Reeks B (University of Stellenbosch : 1979)</subfield>
            <subfield code="?">UNAUTHORIZED</subfield>
          </datafield>
          <datafield ind1="0" ind2="0" tag="245">
          <subfield code="a">Annale.</subfield>
          <subfield code="n">Reeks B /</subfield>
          <subfield code="c">Universiteit van Stellebosch.</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it 'work title from 130' do
        solns = g.query(work_title_value_squery)
        expect(solns.size).to eq 1
        title_value = solns.first.titleValue.to_s
        expect(title_value).to match(/Annale/)
        expect(title_value).not_to match(/van/)
      end
    end

    it 'ignore 130 ind1 (non-filing chars) in work title' do
      # Nancy Lorimer, 9/2015:  "uniform titles do not include non-filing characters by definition"
      rec_id = '130_ind1'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="4" ind2=" " tag="130">
          <subfield code="a">The annual register. 1773.</subfield>
          <subfield code="?">UNAUTHORIZED</subfield>
        </datafield>
        <datafield ind1="1" ind2="4" tag="245">
          <subfield code="a">The something</subfield>
          <subfield code="n">or a view of the history, politics, and literature, for the year 1773.</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      solns = g.query(work_title_value_squery)
      expect(solns.size).to eq 1
      title_value = solns.first.titleValue.to_s
      expect(title_value).to match(/The annual register/)
    end
  end # context 130

  context "100|110|111 and 240" do
    context '100 ‡a, ‡? and 240 ‡a, ‡?' do
      let(:g) {
        rec_id = '100a_240a_question_marks'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="1" ind2=" " tag="100">
            <subfield code="a">Davis, Miles.</subfield>
            <subfield code="?">UNAUTHORIZED</subfield>
          </datafield>
          <datafield ind1="1" ind2="0" tag="240">
            <subfield code="a">Birth of the cool</subfield>
            <subfield code="?">UNAUTHORIZED</subfield>
          </datafield>
          <datafield ind1="1" ind2="0" tag="245">
            <subfield code="a">ignored</subfield>
            <subfield code="c">Miles Davis.</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it 'work title from 240' do
        solns = g.query(work_title_value_squery)
        expect(solns.size).to eq 1
        title_value = solns.first.titleValue.to_s
        expect(title_value).to match(/Birth of the cool/)
        expect(title_value).not_to match(/ignore/) # 245a
        expect(title_value).not_to match(/Davis, Miles/) # 100a
      end
    end
    context '110 ‡a, ‡b, ‡= and 240 ‡a has single work' do
      let(:g) {
        rec_id = '110ab_240a_equal'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="1" ind2=" " tag="110">
            <subfield code="a">South Africa.</subfield>
            <subfield code="b">Department of Education</subfield>
            <subfield code="=">^A1298224</subfield>
          </datafield>
          <datafield ind1="1" ind2="0" tag="240">
            <subfield code="a">Annual report (Online)</subfield>
          </datafield>
          <datafield ind1="1" ind2="0" tag="245">
            <subfield code="a">ignore</subfield>
            <subfield code="h">[electronic resource] /</subfield>
            <subfield code="c">Department of Education.</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it 'work title from 240' do
        solns = g.query(work_title_value_squery)
        expect(solns.size).to eq 1
        title_value = solns.first.titleValue.to_s
        expect(title_value).to match(/Annual report \(Online\)/)
        expect(title_value).not_to match(/ignore/) #245a
        expect(title_value).not_to match(/South Africa/) # 110a
      end
    end
    context '111 ‡a, ‡? and 240 ‡a has single work' do
      let(:g) {
        rec_id = '111a_240a'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="2" ind2=" " tag="111">
            <subfield code="a">International Workshop on Faces.</subfield>
            <subfield code="?">UNAUTHORIZED</subfield>
          </datafield>
          <datafield ind1="1" ind2="0" tag="240">
            <subfield code="a">Proceedings (Online)</subfield>
          </datafield>
          <datafield ind1="1" ind2="0" tag="245">
            <subfield code="a">ignore a</subfield>
            <subfield code="h">[ignore h] /</subfield>
            <subfield code="c">ignore c</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it 'work title from 240' do
        solns = g.query(work_title_value_squery)
        expect(solns.size).to eq 1
        title_value = solns.first.titleValue.to_s
        expect(title_value).to match(/Proceedings \(Online\)/)
        expect(title_value).not_to match(/ignore/) # 245a
        expect(title_value).not_to match(/International Workshop on Faces/) # 111a
      end
    end

    it 'ignore 240 ind2 (non-filing chars) in work title' do
      # Nancy Lorimer, 9/2015:  "title access points do not include non-filing characters by definition"
      rec_id = '240_ind2'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="1" ind2="0" tag="100">
          <subfield code="a">Geminiani, Francesco.</subfield>
          <subfield code="d">1687-1762.</subfield>
          <subfield code="=">^A165834</subfield>
        </datafield>
        <datafield ind1="1" ind2="4" tag="240">
          <subfield code="a">The art of playing on the violin</subfield>
        </datafield>
        <datafield ind1="1" ind2="0" tag="245">
          <subfield code="a">L\'art de jouer le violon</subfield>
          <subfield code="h">[MICROFORM]</subfield>
          <subfield code="b">contenant les regles nécessaires a la perfection de cet instrument, blois blois</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      solns = g.query(work_title_value_squery)
      expect(solns.size).to eq 1
      title_value = solns.first.titleValue.to_s
      expect(title_value).to match(/The art/)
    end

    it '240 ind1 = 0  (not printed or displayed)' do
      # Nancy Lorimer, 9/2015:  "technically possible, but unlikely"
      rec_id = '240_ind1'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="1" ind2="0" tag="100">
          <subfield code="a">Carrasquilla, Tomás,</subfield>
          <subfield code="d">1858-1940.</subfield>
          <subfield code="=">^A110181</subfield>
        </datafield>
        <datafield ind1="0" ind2="0" tag="240">
          <subfield code="a">Works.</subfield>
          <subfield code="k">Selections.</subfield>
          <subfield code="f">1989.</subfield>
        </datafield>
        <datafield ind1="1" ind2="0" tag="245">
          <subfield code="a">Tomás Carrasquilla /</subfield>
          <subfield code="c">por Jaime Mejía Duque.</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      solns = g.query(work_title_value_squery)
      expect(solns.size).to eq 1
      title_value = solns.first.titleValue.to_s
      expect(title_value).to match(/Works/)
      skip "don't know what to do with these.  Currently ignore 240 ind1"
    end
  end # context 1xx and 240

  # 240 and no 1xx shouldn't happen

  context "100|110|111 and 245" do
    context '100 ‡a, ‡d, ‡e, ‡= and 245 ‡a, ‡b, ‡c' do
      let(:g) {
        rec_id = '100ade_245abc'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="1" ind2=" " tag="100">
            <subfield code="a">Lin, Hsiang-ju,</subfield>
            <subfield code="d">1931-</subfield>
            <subfield code="e">author.</subfield>
            <subfield code="=">^A1797002</subfield>
          </datafield>
          <datafield ind1="1" ind2="0" tag="245">
            <subfield code="a">Slippery noodles :</subfield>
            <subfield code="b">a culinary history of China /</subfield>
            <subfield code="c">Hsiang Ju Lin.</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it 'work title from 245' do
        solns = g.query(work_title_value_squery)
        expect(solns.size).to eq 1
        title_value = solns.first.titleValue.to_s
        expect(title_value).to match(/Slippery noodles/)
        expect(title_value).not_to match(/Lin, Hsiang-ju/) # 100a
        solns = g.query(work_subtitle_squery)
        expect(solns.size).to eq 1
        subtitle = solns.first.subtitle.to_s
        expect(subtitle).to match(/a culinary history of China/)
        expect(subtitle).not_to match(/Hsiang Ju Lin/) # 245c
        expect(subtitle).not_to match(/Lin, Hsiang-ju/) # 100a
      end
    end
    context '110 ‡a, ‡b, ‡= and 245 ‡a, ‡f' do
      let(:g) {
        rec_id = '110ab_245af'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="2" ind2=" " tag="110">
            <subfield code="a">Stanford University.</subfield>
            <subfield code="b">Women\'s Community Center.</subfield>
            <subfield code="=">^A104006</subfield>
          </datafield>
          <datafield ind1="1" ind2="0" tag="245">
            <subfield code="a">Stanford University, Women\'s Community Center, records,</subfield>
            <subfield code="f">2007-2014.</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it 'work title from 245' do
        solns = g.query(work_title_value_squery)
        expect(solns.size).to eq 1
        title_value = solns.first.titleValue.to_s
        expect(title_value).to match(/Stanford University, Women's Community Center, records/)
      end
    end
    context '111 ‡a ‡n ‡d ‡c ‡= and 245 ‡a ‡b ‡c' do
      let(:g) {
      rec_id = '111andc_245abc'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="2" ind2=" " tag="111">
            <subfield code="a">International Jean Sibelius Conference</subfield>
            <subfield code="n">(3rd :</subfield>
            <subfield code="d">2000 :</subfield>
            <subfield code="c">Helsinki, Finland)</subfield>
            <subfield code="=">^A1791312</subfield>
          </datafield>
          <datafield ind1="1" ind2="0" tag="245">
            <subfield code="a">Sibelius forum II :</subfield>
            <subfield code="b">proceedings from the third International Jean Sibelius Conference, Helsinki, December 7-10, 2000 /</subfield>
            <subfield code="c">edited by Matti Huttunen, Kari Kilpeläinen and Veijo Murtomäki.</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it 'work title from 245' do
        solns = g.query(work_title_value_squery)
        expect(solns.size).to eq 1
        title_value = solns.first.titleValue.to_s
        expect(title_value).to match(/Sibelius forum II/)
        expect(title_value).not_to match(/International Jean Sibelius Conference/)  # 245b, 111a
        solns = g.query(work_subtitle_squery)
        expect(solns.size).to eq 1
        subtitle = solns.first.subtitle.to_s
        expect(subtitle).to match(/proceedings from the third International Jean Sibelius Conference/)
        expect(subtitle).not_to match(/Finland/) #111c
      end
    end
    it '245 non-filing chars (ind2)' do
      rec_id = '100_245_non_filing'
      marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
        '<datafield ind1="1" ind2=" " tag="100">
          <subfield code="a">Walker, Alice,</subfield>
          <subfield code="d">1944-</subfield>
          <subfield code="=">^A128228</subfield>
        </datafield>
        <datafield ind1="1" ind2="4" tag="245">
          <subfield code="a">The color purple :</subfield>
          <subfield code="b">a novel /</subfield>
          <subfield code="c">by Alice Walker.</subfield>
        </datafield>
      </record>'
      g = self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      expect(g.query(work_squery).size).to eq 1
      solns = g.query(work_title_value_squery)
      expect(solns.size).to eq 1
      title_value = solns.first.titleValue.to_s
      expect(title_value).to match(/The color purple/)
      expect(title_value).not_to match(/Walker/) # 100a, 245c
      solns = g.query(work_subtitle_squery)
      expect(solns.size).to eq 1
      subtitle = solns.first.subtitle.to_s
      expect(subtitle).to match(/a novel/)
      expect(subtitle).not_to match(/Walker/) # 100a, 245c
      skip 'non-filing chars (stupidly) observed in title bf:title property on bf:Work'
    end
  end # context 1xx and 245

  context "245 no 1xx" do
    context '245 ‡a ‡b ‡c' do
      let(:g) {
        rec_id = '245only'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="0" ind2="0" tag="245">
            <subfield code="a">Primary colors :</subfield>
            <subfield code="b">a novel of politics /</subfield>
            <subfield code="c">Anonymous.</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it 'work title includes ‡a' do
        expect(g.query(work_squery).size).to eq 1
        solns = g.query(work_title_value_squery)
        expect(solns.size).to eq 1
        title_value = solns.first.titleValue.to_s
        expect(title_value).to match(/Primary colors/)
        expect(title_value).not_to match(/a novel of politics/) # 245b
        expect(title_value).not_to match(/Anonymous/) # 245c
        solns = g.query(work_subtitle_squery)
        expect(solns.size).to eq 1
        subtitle = solns.first.subtitle.to_s
        expect(subtitle).to match(/a novel of politics/)
        expect(subtitle).not_to match(/Anonymous/) # 245c
      end
    end
    context '245 non-filing chars (ind2)' do
      let(:g) {
        rec_id = '245only_non_filing'
        marcxml_str = marc_ldr_001_008.sub('RECORD_ID', rec_id) +
          '<datafield ind1="0" ind2="2" tag="245">
            <subfield code="a">A Memoir of Mary Ann /</subfield>
            <subfield code="c">by the Dominican nuns of Our Lady of Perpetual Help Home, Atlanta, Georgia ; introduction by Flannery O\'Connor.</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, rec_id)
      }
      it 'single work' do
        expect(g.query(work_squery).size).to eq 1
      end
      it 'work title includes ‡a' do
        expect(g.query(work_squery).size).to eq 1
        solns = g.query(work_title_value_squery)
        expect(solns.size).to eq 1
        title_value = solns.first.titleValue.to_s
        expect(title_value).to match(/A Memoir of Mary Ann/)
        expect(title_value).not_to match(/by the Dominican nuns of Our Lady of Perpetual Help Home/)
        solns = g.query(work_subtitle_squery)
        expect(solns.size).to eq 0 # no 245b
        skip 'non-filing chars (stupidly) observed in title bf:title property on bf:Work'
      end
    end
  end # context 245 no 1xx

end
