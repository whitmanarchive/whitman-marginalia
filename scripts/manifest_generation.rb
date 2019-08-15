require "fileutils"
require "iiif/presentation"
require "nokogiri"

# iiif config
iiif_path = "https://whitmanarchive.org/iiif/2/manuscripts%2Fmarginalia%2Ffigures%2F"
iiif_end = "full/full/0/default.jpg"
iiif_thumb = "full/!150,150/0/default.jpg"

file_dir = File.join(File.expand_path(File.dirname(__FILE__)), "..")
puts file_dir
# fake placeholder for now
options = {
  "environment" => "development",
  "collection_dir" => file_dir
}

errors = []

# create a manifest with basic LoG stuff

manifest = IIIF::Presentation::Manifest.new({
  "@id" => "https://whitman-dev.unl.edu/media/data/whitman-marginalia/output/#{options["environment"]}/manifests/owu.00090.json",
  "label" => "Whitman's Cultural Geography Scrapbook",
  #"description" => [
  #  "@value" => "This is a description",
  #  "@language" => "en"
  # ],
  # "license" => "some license information here",
  "attribution" => "TODO",
  "viewingDirection" => "left-to-right",
  "viewingHint" => "paged",
  # "logo" => "#{iiif_path}ppp.00271.001.jpg/#{iiif_thumb}"
})

sequence_primary = IIIF::Presentation::Sequence.new({
  "label" => "Page Order"
})

scrapbook_filepath = File.join(
  options["collection_dir"], "source", "tei", "owu.00090.xml"
)
xml = File.open(scrapbook_filepath) { |f| Nokogiri::XML(f).remove_namespaces! }

pbs = xml.xpath("//pb")

pbs.each do |page|
  images = page["facs"].split(" ")
  images.each do |image_filename|
    puts image_filename
    canvas = IIIF::Presentation::Canvas.new()
    full_url = "#{iiif_path}%2F#{image_filename}/#{iiif_end}"
    thumb_url = "#{iiif_path}%2F#{image_filename}/#{iiif_thumb}"

    canvas["@id"] = "https://whitmanarchive.org/TODO/#{image_filename}-#{page["id"]}"
    canvas.label = "#{page["rend"]} #{page["id"]}"
    canvas.thumbnail = thumb_url

    # create an annotation
    # TODO fill in more annotation stuff
    annotation = IIIF::Presentation::Annotation.new
    begin
      annotation.resource = IIIF::Presentation::ImageResource.create_image_api_image_resource({
        service_id: "#{iiif_path}%2F#{image_filename}"
      })
    rescue => e
      puts "error with #{image_filename}"
      errors << "#{image_filename} : #{e}"
      next
    end
    # TODO see this part of documentation for "on": https://iiif.io/api/presentation/2.1/#image-resources
    annotation["on"] = "https://whitmanarchive.org/TODO/#{image_filename}-#{page["id"]}"
    annotation["@id"] = "https://whitmanarchive.org/TODO/annotation/#{image_filename}"
    canvas.images << annotation
    canvas.width = annotation.resource.width
    canvas.height = annotation.resource.height

    # output all the canvas methods for inspection
    # puts canvas.methods(false).sort

    sequence_primary.canvases << canvas
  end
end

manifest.sequences << sequence_primary
# puts manifest.to_json(pretty: true)

puts errors

output_dir = File.join(options["collection_dir"], "output", options["environment"], "manifests")
FileUtils.mkdir_p(output_dir)
File.open(File.join(output_dir, "owu.00090.json"), "w") { |f| f.write(manifest.to_json(pretty: true)) }
