require 'open-uri'
require 'addressable/uri'
require 'public_suffix'
require 'typhoeus'

require_relative 'site-inspector/cache'
require_relative 'site-inspector/compliance'
require_relative 'site-inspector/disk_cache'
require_relative 'site-inspector/domain'
require_relative 'site-inspector/checks/check'
require_relative 'site-inspector/checks/content'
require_relative 'site-inspector/checks/dns'
require_relative 'site-inspector/checks/headers'
require_relative 'site-inspector/checks/hsts'
require_relative 'site-inspector/checks/https'
require_relative 'site-inspector/checks/sniffer'
require_relative 'site-inspector/endpoint'
require_relative 'site-inspector/version'

class SiteInspector
  class << self

    attr_writer :timeout, :cache

    def cache
      @cache ||= if ENV['CACHE']
        SiteInspector::DiskCache.new
      else
        SiteInspector::Cache.new
      end
    end

    def timeout
      @timeout || 10
    end

    def inspect(domain)
      Domain.new(domain)
    end

    def typhoeus_defaults
      {
        :followlocation => false,
        :timeout => SiteInspector.timeout,
        :headers => {
          "User-Agent" => "Mozilla/5.0 (compatible; SiteInspector/#{SiteInspector::VERSION}; +https://github.com/benbalter/site-inspector-ruby)"
        }
      }
    end
  end
end

Typhoeus::Config.cache = SiteInspector.cache
#Typhoeus::Config.memoize = true
