require 'spec_helper'
require 'linkeddata'

describe 'instance related to the work described by the MARC record' do

# mbshared:related-works calls mbshared:generate-related-instance for any of
#   (400|410|411|430|440|490|533|534|630|700|710|711|730|740|760|762|765|767|770|772|773|774|775|777|780|785|787|800|810|811|830)

  context "hasInstance" do
    # /m2b-properties/hasInstance/630296.ttl  (or not)
  end

  context "instanceOf" do
    # /m2b-properties/instanceOf/15798171.ttl
  end

end