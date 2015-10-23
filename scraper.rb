require 'scraperwiki'
require 'wikidata/fetcher'

pages = ['Kategorija:Poslanci_7._državnega_zbora_Republike_Slovenije']

pages = pages.map { |c| WikiData::Category.new(c, 'sl').wikidata_ids }

pages.flatten.uniq.each do |id|
  data = WikiData::Fetcher.new(id: id).data('sl')
  next if data.nil?
  warn "#{data[:id]} #{data[:name]}"
  ScraperWiki.save_sqlite([:id], data)
end
