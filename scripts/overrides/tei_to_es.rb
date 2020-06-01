class TeiToEs

  ################
  #    XPATHS    #
  ################

  # in the below example, the xpath for "person" is altered
  def override_xpaths
    xpaths = {}
    # TODO I am not sure that the first bibl is necessarily what we want as there are multiple
    xpaths["date"] = [
      "/TEI/teiHeader/fileDesc/sourceDesc/bibl[1]/date/@notBefore",
      "/TEI/teiHeader/fileDesc/sourceDesc/bibl[1]/date/@when"
    ]
    xpaths["date_display"] = "/TEI/teiHeader/fileDesc/sourceDesc/bibl[1]/date"
    # custom xpath for marginalia
    xpaths["text_type"] = "/TEI/text/@type"
    return xpaths
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

  def date(before=true)
    date = ""
    @xpaths["date"].each do |xpath|
      date = get_text(xpath)
      break if !date.empty?
    end
    CommonXml.date_standardize(date, before)
  end

  def language
    # TODO verify that none of these are primarily english
    "en"
  end

  def languages
    # TODO verify that none of these are multiple languages
    [ "en" ]
  end

  # TODO place, publisher, rights, rights_uri, rights_holder, source

  def subcategory
    "marginalia"
  end

  def topics
    get_text(@xpaths["text_type"])
  end

  # TODO text other from author, title, publisher, pubplace, and date[@when]

  def uri
    # text_type as a custom field in the API has yet to be implemented, but using
    # the value to determine the URI structure
    text_type = get_text(@xpaths["text_type"])
    if text_type == "marginalia"
      "#{@options["site_url"]}/manuscripts/marginalia/transcriptions/#{@filename}.html"
    else
      "#{@options["site_url"]}/manuscripts/marginalia/annotations/#{@filename}.html"
    end
  end

end
