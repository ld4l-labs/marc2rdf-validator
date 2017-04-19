RSpec.configure { |c| c.before(:each, bib2lod: true) { MARC2BF_GRAPH_METHOD ||= 'marc_to_graph_bib2lod' } }
