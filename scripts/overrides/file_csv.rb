require "csv"
require "fileutils"
require "iiif/presentation"

class FileCsv

  def create_manifest_base
    IIIF::Presentation::Manifest.new({
      "@id" => "https://whitman-dev.unl.edu/media/data/whitman-marginalia/output/#{@options["environment"]}/manifests/geography_scrapbook.json",
      "label" => "Whitman's Cultural Geography Scrapbook",
      #"description" => [
      #  "@value" => "This is a description",
      #  "@language" => "en"
      # ],
      # "license" => "some license information here",
      "attribution" => "TODO",
      "viewingDirection" => "left-to-right",
      "viewingHint" => "paged",
      # "logo" => "#{@iiif_path}TODO.jpg/#{@iiif_thumb}"
    })
  end

  def print_iiif(json, filename)
    output_dir = File.join(@options["collection_dir"], "output", @options["environment"], "manifests")
    File.open(File.join(output_dir, "geography_scrapbook.json"), "w") { |f| f.write(json.to_json(pretty: true)) }
  end

  def row_to_canvas(page)
    # TODO SOMETHING WEIRD IS HAPPENING HERE BUT WHY??
    image_filename = page[0]
    puts image_filename
    label = page["Label"]

    canvas = IIIF::Presentation::Canvas.new()
    full_url = "#{@iiif_path}%2F#{image_filename}/#{@iiif_end}"
    thumb_url = "#{@iiif_path}%2F#{image_filename}/#{@iiif_thumb}"

    canvas["@id"] = "https://whitmanarchive.org/TODO/#{image_filename}"
    canvas.label = "#{label}"
    canvas.thumbnail = thumb_url

    # create an annotation
    # TODO fill in more annotation stuff
    annotation = IIIF::Presentation::Annotation.new
    begin
      annotation.resource = IIIF::Presentation::ImageResource.create_image_api_image_resource({
        service_id: "#{@iiif_path}%2F#{image_filename}"
      })
    rescue => e
      puts "error with #{e}"
      @errors << "#{image_filename} : #{e}"
      return nil
    end
    annotation["on"] = "https://whitmanarchive.org/TODO/#{image_filename}"
    annotation["@id"] = "https://whitmanarchive.org/TODO/annotation/#{image_filename}"
    canvas.images << annotation
    canvas.width = annotation.resource.width
    canvas.height = annotation.resource.height

    # output all the canvas methods for inspection
    # puts canvas.methods(false).sort
  end

  def transform_iiif
    # iiif config
    @iiif_path = "https://whitmanarchive.org/iiif/2/manuscripts%2Fmarginalia%2Ffigures%2F"
    @iiif_end = "full/full/0/default.jpg"
    @iiif_thumb = "full/!150,150/0/default.jpg"
    @errors = []

    manifest = create_manifest_base
    sequence_primary = IIIF::Presentation::Sequence.new({
      "label" => "Page Order"
    })

    scrapbook_filepath = File.join(
      @options["collection_dir"], "source", "csv", "scrapbook_images.csv"
    )
    csv = CSV.read(scrapbook_filepath, headers: true)

    csv.each do |page|
      canvas = row_to_canvas(page)
      sequence_primary.canvases << canvas
    end

    manifest.sequences << sequence_primary
    print_iiif(manifest, "geography_scrapbook.json")
    puts @errors
    manifest
  end

end
