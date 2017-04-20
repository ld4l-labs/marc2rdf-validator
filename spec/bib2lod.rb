RSpec.configure { |c| c.before(:each) { MARC2BF_GRAPH_METHOD ||= 'marc_to_graph_bib2lod' } }
