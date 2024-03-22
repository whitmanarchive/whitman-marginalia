class TeiToEsPasteon < TeiToEs


  def get_id
    if @xml["id"]
      id = @xml["id"]
    elsif @xml.at_xpath(".//pb")
      id = @xml.at_xpath(".//pb")["id"]
    else
      return nil
    end
    "#{@filename}_#{id}"
  end

  def title
    # an attempt to get the most plausible title for each scrapbook note
    text = get_text(".//head") || get_text(".//div1/note[not(list)][1]") || get_text(".//list[1]/item[1]") ||
      get_text(".//p[1]") || get_text(".//div1/fw") || get_text(".//div1/figure/caption") || get_text(".//ab")
    # only take the first fifteen words
    text.split(" ")[0..15].join(" ") if text
  end

  def extent
    "pasteon"
  end

  def has_part
  end

  def is_part_of
    title = @xml.at_xpath("./ancestor::TEI//titleStmt/title[1]")
    {
      "role" => "containing manuscript",
      "id" => @filename,
      "title" => title.text
    }
  end

  def previous_item
    prev_node = @xml.at_xpath("./preceding::add[@rend='pasteon'][1]")
    if prev_node
      pasteon = TeiToEsPasteon.new(prev_node, {}, nil, @filename)
      prev_id = pasteon.get_id
      prev_title = pasteon.title
      {
        "role" => "previous poem",
        "id" => prev_id,
        "title" => prev_title
      }
    end
  end

  def next_item
    next_node = @xml.at_xpath("./following::add[@rend='pasteon'][1]")
    if next_node
      pasteon = TeiToEsPasteon.new(next_node, {}, nil, @filename)
      next_id = pasteon.get_id
      next_title = pasteon.title
      {
        "role" => "next poem",
        "id" => next_id,
        "title" => next_title
      }
    end
  end

  def uri
    "#{@options["site_url"]}/item/#{get_id}"
  end

  def text
    # handling separate fields in array
    # means no worrying about handling spacing between words
    text_all = []
    body = get_text(".//text()", keep_tags: false, delimiter: '')
    text_all << body
    # TODO: do we need to preserve tags like <i> in text? if so, turn get_text to true
    # text_all << CommonXml.convert_tags_in_string(body)
    text_all += text_additional
    Datura::Helpers.normalize_space(text_all.join(" "))
  end

  def date_display
    get_text(".//date")
  end

  def date(before=true)
    if get_list(".//date/@when")
      datestr = get_list(".//date/@when").first
    else
      datestr = nil
    end
    if datestr && !datestr.empty?
      Datura::Helpers.date_standardize(datestr, false)
    end
  end

end
