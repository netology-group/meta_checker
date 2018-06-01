require 'sitemap-parser'

class SitemapProcessor
  attr_reader :sitemap_url, :parser

  def initialize(sitemap_url = "https://netology.ru/sitemap.xml")
    @sitemap_url = sitemap_url
    @parser = SitemapParser.new(sitemap_url)
  end

  def to_a
    parser.to_a
  end
end
