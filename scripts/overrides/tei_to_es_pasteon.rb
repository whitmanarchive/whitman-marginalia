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
    get_text("head[1]/date")
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
  end
end
