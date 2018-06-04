require 'rspec'
require 'airborne'
require 'byebug'
require 'active_support/all'

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
  config.slack_webhook_url = 'https://hooks.slack.com/services/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'
end

RSpec.describe 'Check meta by sitemap:' do
  config = MetaChecker.configuration
  path_to_sitemap = config.path_to_sitemap
  send_notification = ->(missing_tags, url) {
    `curl -X POST --data-urlencode 'payload={"text": "#{url}: отсутствуют метатеги [ #{missing_tags.join(', ')} ]"}' #{config.slack_webhook_url}`
  }

  SitemapProcessor.new(path_to_sitemap).to_a.each do |url|
    context "#{url}" do
      before(:context) do
        @missing_tags = []
        get url
        @checker = MetaChecker::Parser.new(response.body)
      end

      after(:context) do
        send_notification.(@missing_tags, url) if @missing_tags.present?
      end

      it "contains correct meta with names" do
        result = config.required_meta_names - @checker.meta_names_keys
        @missing_tags.concat(result)

        expect(result).to eq []
      end

      it "contains correct meta with properties" do
        result = config.required_meta_properties - @checker.meta_properties_keys

        @missing_tags.concat(result)
        expect(result).to eq []
      end
    end
  end
end
