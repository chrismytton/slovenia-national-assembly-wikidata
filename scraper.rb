require 'scraperwiki'
require 'wikidata/fetcher'
require 'nokogiri'
require 'open-uri/cached'
require 'rest-client'

OpenURI::Cache.cache_path = '.cache'

def noko_for(url)
  Nokogiri::HTML(open(URI.escape(URI.unescape(url))).read)
end

def wikinames_from(url)
  noko = noko_for(url)
  names = noko.xpath('//h2/following-sibling::ul//a[contains(@href, "/wiki/") and not(@class="new")]/@title').map(&:text)
  abort "No names" if names.count.zero?
  names
end

def fetch_info(names)
  ids_from_names = WikiData.ids_from_pages('sl', names).values
  categories = ['Kategorija:Poslanci_7._državnega_zbora_Republike_Slovenije']
  ids_from_categories = categories.map { |c| WikiData::Category.new(c, 'sl').wikidata_ids }
  ids = ids_from_categories.flatten.uniq | ids_from_names.flatten.uniq

  ids.each do |id|
    data = WikiData::Fetcher.new(id: id).data('sl')
    next if data.nil?
    warn "#{data[:id]} #{data[:name]}"
    data[:original_wikiname] = data[:name]
    ScraperWiki.save_sqlite([:id], data)
  end
end

names = wikinames_from('https://sl.wikipedia.org/wiki/Seznam_poslancev_7._državnega_zbora_Republike_Slovenije')

fetch_info names.uniq

warn RestClient.post(ENV['MORPH_REBUILDER_URL'], {}) if ENV['MORPH_REBUILDER_URL']
