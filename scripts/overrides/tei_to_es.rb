require "byebug"
require_relative "../../../whitman-scripts/scripts/ruby/get_works_info.rb"
class TeiToEs
  attr_reader :parent_xml 
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
    "Literary Manuscripts"
  end

  def category2
    "Literary Manuscripts / Marginalia and Annotations"
  end

  def category3
    category3 = "In Whitman's Hand / Marginalia / " + get_text(@xpaths["topics"]).capitalize()
    category3
  end

  def language
    # TODO verify that none of these are primarily english
    "en"
  end

  # def languages
  #   # TODO verify that none of these are multiple languages
  #   [ "en" ]
  # end

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

  def date_not_after
    datestr = get_text(@xpaths["date_not_after"])
    if datestr && !datestr.empty?
      Datura::Helpers.date_standardize(datestr, true)
    else
      date(true)
    end
  end

  def date_not_before
    datestr = get_text(@xpaths["date_not_before"])
    if datestr && !datestr.empty?
      Datura::Helpers.date_standardize(datestr, true)
    else
      date(true)
    end
  end

  def citation
    # WorksInfo is get_works_info.rb in whitman-scripts repo
    @works_info = WorksInfo.new(xml, @id, work_xpath = ".//relations/work/@ref")
    ids, names = @works_info.get_works_info
    citations = []
    if ids && ids.length > 0
      ids.each_with_index do |id, idx|
        name = names[idx]
        citations << {
          "id" => id,
          "title" => name,
          "role" => "whitman_id"
        }
      end
    end
    citations
  end

    def text
      # handling separate fields in array
      # means no worrying about handling spacing between words
      text_all = []
      body = get_text(@xpaths["text"], keep_tags: false, delimiter: '')
      text_all << body
      # TODO: do we need to preserve tags like <i> in text? if so, turn get_text to true
      # text_all << CommonXml.convert_tags_in_string(body)
      text_all += text_additional
      Datura::Helpers.normalize_space(text_all.join(" "))[0..999999]
    end

end
