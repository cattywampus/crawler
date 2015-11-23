require 'mechanize'
require 'byebug'
require 'ruby-progressbar'

module Crawler
  class Crawler
    SAFE_CODES = %w(200 302 304)
    def initialize
      @agent = Mechanize.new
    end
  
    def grab(url)
      @agent.get(url)
    end
  
    def find_bad_links(url)
      uri = URI(url)
      failures = []
      
      begin
        page = grab(url)
      rescue Mechanize::ResponseCodeError => e
        return {
          url: url,
	  title: "PAGE DOES NOT EXIST! (404)",
	  failures: []
	}
      end

      progressbar = ProgressBar.create title: "Checking links", starting_at: 0, total: page.links.size
      page.links.each do |link|
        progressbar.increment
        begin
          href = link.href.to_s.strip
          next if href =~ /\Atel:|mailto:|javascript:/
          follow = URI(href)
          follow.host ||= uri.host
          follow.scheme ||= uri.scheme
          follow.port ||= uri.port
          @agent.get(follow.to_s)
        rescue Mechanize::ResponseCodeError => e
          failures << {
            name: link.text.to_s.strip,
            url: follow.to_s,
            code: e.response_code
          }
        rescue Mechanize::UnsupportedSchemeError => e
          next
        rescue => e
	  puts "UNHANDLED FAILURE!"
	  puts "  page: #{url}"
	  puts "  link: #{follow.to_s}"
	  puts "  error: #{e.message}"
	  next
        end
      end
      
      result = {}
      result[:title] = page.title
      result[:url] = url
      result[:failures] = failures
  
      result
    end
  end
end
