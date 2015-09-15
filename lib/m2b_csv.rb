require 'csv'
require 'faraday'
require 'fileutils'

##
# Run this in the lib folder to get classes, properties and their bibids from a csv file
#   with headers: className, bibid or propertyName, bibid
# #
class M2bCSV
  def m2b_classes_dir
    "../import/m2b-classes.csv".to_s
  end

  def m2b_props_dir
    "../import/m2b-properties.csv".to_s
  end

  def output_dir
    '../spec/fixtures'
  end

  def directory_out(m2b_dir)
    "#{output_dir}/loc/#{m2b_dir}"
  end

  def m2b_type(obj)
    if !obj['className'].nil?
      obj['className']
    elsif !obj['propertyName'].nil?
      obj['propertyName']
    end
  end

  def loc_sru_url
    'http://lx2.loc.gov:210/LCDB?operation=searchRetrieve&recordSchema=marcxml&maximumRecords=1&query=rec.id'
  end

  def loc_url_response(bibid)
    url = "#{loc_sru_url}=#{bibid}"
    begin
      Faraday.get(url)
    rescue Faraday::Error::ConnectionFailed
      puts "failed for: #{url}"
    end
  end

  def write(m2b_dir, bibid, type)
    dir = "#{m2b_dir}/#{type}".to_s
    response = loc_url_response(bibid)
    FileUtils.mkpath(dir) unless File.exist?(dir) unless response.nil?
    File.open("#{dir}/#{bibid}.marcxml", 'wt') { |f| f.write(response.body) } unless response.nil?
  end
end

m2b = M2bCSV.new
# Get the classes csv
m2b_classes_dir = m2b.m2b_classes_dir.to_s
# Get the props csv
m2b_props_dir = m2b.m2b_props_dir.to_s

# Make the directories and files for both
[m2b_classes_dir, m2b_props_dir].each { |dir|
  CSV.foreach(dir, headers: true) do |csv_obj|
    dir = m2b.directory_out(dir[/m2b-[\w]+/])
    bibid = csv_obj['bibid']
    type = m2b.m2b_type(csv_obj)

    unless dir.nil? | bibid.nil? | type.nil?
      bib_a = bibid.split(';')
      bib_a.each do |bib|
        puts type, bibid, dir
        m2b.write(dir, bib.gsub(/\D/, ''), type)
        sleep(4)
      end
    end
  end
}
