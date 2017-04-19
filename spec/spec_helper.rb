require 'yaml'
require 'linkeddata'

CONFIG_SETTINGS = YAML.load_file('config.yml')

# these MUST go after CONFIG_SETTINGS and MARC2BF_GRAPH_METHOD constants:
require 'support/m2rdf_helpers'
  # Specific converter helpers go here:
require 'support/m2bf_helpers'
require 'support/m2bf2_helpers'
require 'support/bib2lod_helpers'
# Specific RDF entity helpers go here, e.g. require 'works/work_helpers'

RSpec.configure do |config|
  config.include Helpers
  #Specific includes for other helpers go here, e.g. config.include WorkHelpers
  # config.add_setting :helper_method

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  # config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
end

TRIPLES_QUERY = SPARQL.parse("SELECT ?s ?p ?o WHERE { ?s ?p ?o }")

MARC2BF_GRAPH_METHOD = CONFIG_SETTINGS['helper_method'].to_sym if CONFIG_SETTINGS['helper_method']
