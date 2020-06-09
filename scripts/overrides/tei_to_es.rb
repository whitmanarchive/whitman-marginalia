class TeiToEs

  ################
  #    XPATHS    #
  ################

  # in the below example, the xpath for "person" is altered
  def override_xpaths
    xpaths = {}
    xpaths["contributors"] = [
      "//titleStmt/respStmt/persName"
    ]
    xpaths["date"] = {
      "not_after" => "//sourceDesc/bibl/date/@notAfter",
      "not_before" => "//sourceDesc/bibl/date/@notBefore",
      "known" => "//sourceDesc/bibl[1]/date/@when"
    }
    xpaths["date_display"] = "//sourceDesc/bibl[1]/date"
    xpaths["rights"] = "//publicationStmt/availability"
    xpaths["rights_uri"] = "//publicationStmt/availability//ref/@target"
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

  def date(before=true)
    dt = get_text(@xpaths["date"]["known"])
    if dt.empty?
      # if there is no known date, use the not_before date
      # as the primary date for general searches / filtering
      dt = get_text(@xpaths["date"]["not_before"])
    end
    Datura::Helpers.date_standardize(dt)
  end

  def date_not_after
    dt = get_text(@xpaths["date"]["not_after"])
    dt.empty? ? date(false) : Datura::Helpers.date_standardize(dt, false)
  end

  def date_not_before
    dt = get_text(@xpaths["date"]["date_not_before"])
    dt.empty? ? date : Datura::Helpers.date_standardize(dt)
  end

  def language
    # TODO verify that none of these are primarily english
    "en"
  end

  def languages
    # TODO verify that none of these are multiple languages
    [ "en" ]
  end

  def rights
    get_text(@xpaths["rights"])
  end

  def rights_uri
    get_text(@xpaths["rights_uri"])
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
