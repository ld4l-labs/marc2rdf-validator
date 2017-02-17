require 'yaml'

CONFIG_SETTINGS = YAML.load_file('config.yml')
MARC2BF_GRAPH_METHOD = CONFIG_SETTINGS['helper_method'].to_sym

# these MUST go after CONFIG_SETTINGS and MARC2BF_GRAPH_METHOD constants:
require 'support/m2rdf_helpers'
  # Specific converter helpers go here:
require 'support/m2bf_xquery_helpers'
require 'support/bib2lod_helpers'
  # Specific RDF entity helpers go here:
# require 'instances/instance_helpers'
# require 'publications/publication_helpers'
# require 'works/work_helpers'

RSpec.configure do |config|
  config.include Helpers
  # config.include InstanceHelpers
  # config.include PublicationHelpers
  # config.include WorkHelpers

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
