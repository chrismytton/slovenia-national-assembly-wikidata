#!/usr/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

from_cat = WikiData::Category.new( 'Kategorija:Poslanci_7._državnega_zbora_Republike_Slovenije', 'sl').member_titles
from_page = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://sl.wikipedia.org/wiki/Seznam_poslancev_7._državnega_zbora_Republike_Slovenije',
  xpath: '//h2/following-sibling::ul//a[contains(@href, "/wiki/") and not(@class="new")]/@title',
)

sparq = 'SELECT DISTINCT ?item WHERE { ?item p:P39 [ ps:P39 wd:Q21296001  ; pq:P2937 wd:Q19932345 ] }'
ids = EveryPolitician::Wikidata.sparql(sparq)

EveryPolitician::Wikidata.scrape_wikidata(ids: ids, names: { sl: from_cat | from_page })
