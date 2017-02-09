# Generic helpers that do work on MARCXML, which should be a common record-data starting point for most converters.

module Helpers

  # @param [String] the path of the rdfxml file to be loaded
  # @return [RDF::Graph] graph object per the rdfxml file
  def load_graph_from_rdfxml(rdfxml_path)
    require 'rdf'
    require 'rdf/rdfxml'
    RDF::Graph.new.from_rdfxml(File.open(rdfxml_path))
  end

  # Write marcxml_str to a file named tmp/[fname].marcxml
  # @param [String] marcxml_str an xml representaiton of a MARC record
  # @param [String] fname the name to assign the file in the tmp directory
  # @return [String] the path of the marcxml file created
  def create_marcxml_file(marcxml_str, fname)
    output_dir = "#{Dir.pwd}/tmp"
    Dir.mkdir(output_dir) unless Dir.exist? output_dir
    output_path = "#{output_dir}/#{fname}.marcxml"
    File.open(output_path, 'w') { |f| f << marcxml_str }
    output_path
  end

  # @param [String] marcxml_str an xml representation of a MARC record
  # @raise [Marc::Exception] if nil returned from MARC::XMLReader
  # @return [MARC::Record] parsed marc_record
  def ensure_marc_parses(marcxml_str)
    require 'marc'
    marc_record = MARC::XMLReader.new(StringIO.new(marcxml_str)).to_a.first
    fail(MARC::Exception, "unable to parse marc record: " + marcxml_str, caller) if marc_record.nil?
    marc_record
  end

end
