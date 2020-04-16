# whitman-marginalia
Data Repo | Whitman Marginalia TEI and Geography Scrapbook

[<em>The Walt Whitman Archive</em>](http://whitmanarchive.org/) endeavors to make Whitman's vast work freely and conveniently accessible to scholars, students, and general readers. Whitman's major life work, <em>Leaves of Grass</em>, went through six very different editions, each of which was issued in a number of formats, creating a book that is probably best studied as numerous distinct creations rather than as a single revised work. His many other writings—varied and significant—include fiction, notebooks, manuscript fragments, prose essays, letters, marginalia, and voluminous journalistic articles. Drawing on the resources of libraries and collections from around the world, the <em>Whitman Archive</em> is the most comprehensive record of works by and about Whitman—and continues to grow. The <em>Archive</em> is directed by Kenneth M. Price (University of Nebraska–Lincoln) and Ed Folsom (University of Iowa), with ongoing contributions from many other editor-scholars, students, information professionals, and technologists.

The <em>Walt Whitman Archive</em> data repositories include the base TEI/XML files that comprise several sections of the <em>Whitman Archive</em>.  All XML for a given section is available in the "tei" directory.  Other directories contain materials related to the process of indexing the files in SOLR and work in combination with the University of Nebraska-Lincoln Center for Digital Research in the Humanities [central data repository](https://github.com/CDRH/data). For more information about the <em>Walt Whitman Archive</em>, including encoding guidelines and editorial policy statements, see [About the <em>Whitman Archive</em>](http://whitmanarchive.org/about/index.html).

*NOTE* This repository should only be updated with production ready TEI from manuscripts/marginalia/tei and manuscripts/marginalia/tei-annotations

## Update Documents

See wiki for full instructions about updating Solr.  For help:

```
bundle exec post -h
```

Quickly post all documents to Solr:

```
bundle exec post -x solr
```

Update IIIF page viewer manifest (Geography Scrapbook):

```
bundle exec post -x iiif
```
