require 'wikidata/fetcher'

from_cat = WikiData::Category.new( 'Kategorija:Poslanci_7._državnega_zbora_Republike_Slovenije', 'sl').member_titles
from_page = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://sl.wikipedia.org/wiki/Seznam_poslancev_7._državnega_zbora_Republike_Slovenije',
  xpath: '//h2/following-sibling::ul//a[contains(@href, "/wiki/") and not(@class="new")]/@title',
)

EveryPolitician::Wikidata.scrape_wikidata(names: { sl: from_cat | from_page })
