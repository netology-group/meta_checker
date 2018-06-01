require 'rspec'

# Internal deps
require 'meta_checker'
require 'sitemap_processor'

MetaChecker.configure do |config|
  config.path_to_sitemap = 'https://netology.ru/sitemap.xml'
  # config.path_to_sitemap = './examples/foxford/sitemap.xml'
  # config.required_meta_names = [
  #   'description',
  #   'keywords',
  #   'viewport',
  #   'fragment'
  # ]
end

RSpec.describe 'Check meta by sitemap:' do
  config = MetaChecker.configuration
  path_to_sitemap = config.path_to_sitemap || './examples/foxford/sitemap.xml'

  SitemapProcessor.new(path_to_sitemap).to_a.each do |url|
    context "#{url}" do
      before { get url; @checker = MetaChecker::Parser.new(response.body) }

      it "contains correct meta with names" do
        expect(config.required_meta_names - @checker.meta_names_keys).to eq []
      end

      it "contains correct meta with properties" do
        expect(config.required_meta_properties - @checker.meta_properties_keys).to eq []
      end
    end
  end
end
