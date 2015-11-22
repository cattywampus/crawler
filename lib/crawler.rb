require 'mechanize'
require 'byebug'

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
    page = grab(url)
    page.links.each do |link|
      begin
        href = link.href.strip
        next if href =~ /\Atel:|mailto:|javascript:/
        follow = URI(link.href.strip)
        follow.host ||= uri.host
        follow.scheme ||= uri.scheme
        follow.port ||= uri.port
        @agent.get(follow.to_s)
      rescue Mechanize::ResponseCodeError => e
        failures << {
          name: link.text.strip,
          url: follow.to_s,
          code: e.response_code
        }
      rescue Mechanize::UnsupportedSchemeError => e
        next
      rescue => e
        byebug
        puts e.message
      end
    end
    failures
  end
end
