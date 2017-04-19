# helper methods for rspec
#  These particular methods pertain to using the bib2lod converter code
#    from the LD4L-Labs project, at https://github.com/lcnetdev/marc2bibframe2
#  Pre-Reqs:
#  1.  https://github.com/lcnetdev/marc2bibframe2  must be cloned
#  2.  location of clone repo must be in MARC2BIBFRAME_PATH
module Helpers

  MARC2BIBFRAME2_PATH = CONFIG_SETTINGS['marc2bibframe2_path']
  M2BF2_BASE_URI = CONFIG_SETTINGS['base_uri']
  M2BF2_SCRIPT_PATH = 'xsl/marc2bibframe2.xsl'
  ID_FIELD = '001'

  # given a marc record as a String containing marcxml, and a name to use for the temporary output files
  # run the marc record through the marc2bibframe2 converter and return the result as an RDF::Graph object
  # @param [String] marcxml_str an xml representaiton of a MARC record
  # @param [String] fname the name to assign to the marcxml and rdfxml files in the tmp directory
  # @return [RDF::Graph] loaded graph object from the converter for the marc record passed in
  def marc_to_graph_m2bf2(marcxml_str, fname)
    ensure_marc_parses(marcxml_str)
    marc_path = create_marcxml_file(marcxml_str, fname)
    rdfxml_path = create_rdfxml_via_marc2bibframe2_xqy(marc_path)
    load_graph_from_rdfxml(rdfxml_path)
  end

  # Call the convert-saxon.sh script in the marc2bibframe converter code.
  #  Pre-Reqs:
  #  1.  https://github.com/lcnetdev/marc2bibframe2  must be cloned
  #  2.  location of clone repo must be in MARC2BIBFRAME_PATH
  #  3.  requires an XSLT processor, such as xsltproc from libxslt
  # @param [String] the path of the marcxml file
  # @return [String] the path of the rdfxml file created
  def create_rdfxml_via_marc2bibframe2_xqy(marc_path)
    output_file = marc_path.gsub('marcxml', 'rdfxml')
    command = "xsltproc --stringparam 'baseuri' '#{M2BF2_BASE_URI}' --stringparam 'idfield' '#{ID_FIELD}'\
               #{MARC2BIBFRAME2_PATH}/#{M2BF2_SCRIPT_PATH} #{marc_path} > #{output_file}"
    `#{command}`
    output_file
  end

end
