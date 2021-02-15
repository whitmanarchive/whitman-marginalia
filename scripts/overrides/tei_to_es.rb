class TeiToEs

  ################
  #    XPATHS    #
  ################

  # in the below example, the xpath for "person" is altered
  def override_xpaths
    xpaths = {}
    xpaths["rights_holder"] = "//fileDesc/publicationStmt/distributor"
    xpaths["topics"] = "/TEI/text/@type"
    xpaths
  end

  #################
  #    GENERAL    #
  #################

  # Add more fields
  #  make sure they follow the custom field naming conventions
  #  *_d, *_i, *_k, *_t
  def assemble_collection_specific
    # TODO custom field text_type_k
  end

  ################
  #    FIELDS    #
  ################

  # Overrides of default behavior
  # Please see docs/tei_to_es.rb for complete instructions and examples

  def category
    "manuscripts"
  end

  def language
    # TODO verify that none of these are primarily english
    "en"
  end

  def languages
    # TODO verify that none of these are multiple languages
    [ "en" ]
  end

  def subcategory
    "marginalia"
  end

  def topics
    get_text(@xpaths["topics"])
  end

  def uri
    # TODO this may be altered in the new rails structure
    text_type = get_text(@xpaths["topics"])
    if text_type == "marginalia"
      "#{@options["site_url"]}/manuscripts/marginalia/transcriptions/#{@filename}.html"
    else
      "#{@options["site_url"]}/manuscripts/marginalia/annotations/#{@filename}.html"
    end
  end

end
