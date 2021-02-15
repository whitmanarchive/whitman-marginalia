require "csv"
require "nokogiri"

xml_in = "../anc.02129.xml"
csv_in = "owu_sources.csv"
xml_out = "reading_db_update.xml"

def remove_quotes(title)
  title ? title.gsub("\"", "").strip : ""
end

# read in the current reading db xml and convert to xml object
xml_filepath = File.join(__dir__, xml_in)
xml_string = File.read(xml_filepath)
xml = Nokogiri::XML(xml_string, &:noblanks)
xml.remove_namespaces!

# read in the csv that will be imported and convert to csv object
csv_filepath = File.join(__dir__, csv_in)
csv = CSV.read(csv_filepath, headers: true)

# find the final bibl in the document to get an idea of where
# to start with the numbering system and as a convenient place to start adding siblings

last_bibl = xml.xpath("//bibl").last
last_id = last_bibl["id"][/rd_(\d{3})/,1].to_i

current_id = last_id+1
current_node = last_bibl
puts "starting at #{current_id}"

csv.each do |item|
  new_bibl = Nokogiri::XML::Builder.new do |doc|
    doc.bibl(id: "rd_#{current_id}", resp: "#km") {
      doc.author(item["Author"])
      doc.title(remove_quotes(item["Title"]), level: "a")
      doc.title(remove_quotes(item["Title of Periodical"]), level: "j")
      doc.pubPlace(item["Place of publication"])
      doc.publisher(item["Name of Publisher"])
      doc.date(item["Publication date"], type: "publicationDate")
      doc.date("", type: "readingDate")
      doc.biblScope(item["Volume (if applicable)"], type: "vol")
      doc.biblScope(item["Page(s)"], type: "pages")
      doc.idno("owu.00090", type: "wwa")
      doc.note("", type: "reaction")
      doc.note("This source was part of Whitman's cultural geography scrapbook.", type: "comments")
      doc.note(type: "source") {
        doc.ref(target: "#wc")
        doc.ref(target: "owu.00090", type: "wwa")
      }
    }
  end

  # do some fancy footwork to add the new bibl
  # and then make that the new "current" so the
  # next one inserted will be after it
  current_node.add_next_sibling(new_bibl.doc.root)
  current_node = current_node.next_sibling
  current_id += 1
end

puts "writing updated xml to '#{xml_out}.xml'"
File.open(xml_out, "w") { |f| f.write(xml.to_xml(indent: 2)) }
