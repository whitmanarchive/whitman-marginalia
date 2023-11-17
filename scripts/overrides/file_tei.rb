class FileTei

  def transform_iiif
    # commenting out default behavior of raising an error
    # because this repository does not want any TEI to IIIF
    # functionality at the moment
  end

  def subdoc_xpaths
    # match subdocs against classes
    #note: match id, not xml:id
    {
      "/" => TeiToEs,
      # "/TEI[@id='owu.00090']/text/body/add[@rend='pasteon']" => TeiToEsPasteon
    }
  end

end
