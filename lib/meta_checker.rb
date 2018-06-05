require 'nokogiri'

module MetaChecker
  # CONFIGURATION

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :path_to_sitemap
    attr_accessor :required_meta_names
    attr_accessor :required_meta_properties

    attr_accessor :slack_webhook_url
    attr_accessor :default_title
    attr_accessor :main_page_url

    def initialize
      @path_to_sitemap = nil
      @required_meta_names = [
        'description',
        'keywords',
        'viewport',
        'fragment'
      ]

      @required_meta_properties = [
        'og:title',
        'og:type',
        'og:image',
        'og:description'
      ]

      @slack_webhook_url = nil
      @default_title = nil
      @main_page_url = nil
    end
  end

  # PAYLOAD
  class Parser
    attr_reader :meta_tags, :meta_with_name, :meta_with_property, :title

    def initialize(html_response_body)
      meta_tags = Nokogiri::HTML(html_response_body).search('meta')
      @title = Nokogiri::HTML(html_response_body).search('title').try(:[], 0)&.children&.to_s

      @meta_with_name, @meta_with_property = meta_tags.partition {|el| el.attributes['name']}
    end

    def meta_names_keys
      @meta_name_keys ||= meta_names.map {|tag| tag[:name]}.compact.sort
    end

    def meta_names_values
      @meta_name_values ||= meta_names.map {|tag| tag[:value]}.compact.sort
    end

    def meta_properties_keys
      @meta_property_keys ||= meta_properties.map {|tag| tag[:name]}.compact.sort
    end

    def meta_property_values
      @meta_property_keys ||= meta_properties.map {|tag| tag[:value]}.compact.sort
    end

    private

    def meta_names
      meta_with_name.map {|el| {name: el.attributes['name']&.value, value: el.attributes['content']&.value} }
    end

    def meta_properties
      meta_with_property.map {|el| {name: el.attributes['property']&.value, value: el.attributes['content']&.value} }
    end

  end
end
