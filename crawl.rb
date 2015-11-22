require 'mechanize'
require 'byebug'

agent = Mechanize.new

unless ARGV[0]
  puts "You need to provide a file of URLs to scrape"
  exit
end

count = 0
File.read(ARGV[0]).each_line do |url|
  next if url.empty?

  page = agent.get(url)

  puts "URL: #{url} has #{page.links.count} links"
  page.links.each do |link|
    text = link.text.strip
    next if text.empty?
    next if link.href =~ /tel:/
    next if link.href =~ /mailto:/
    puts "\t#{text}"
  end
  count += 1

  break
end

puts "found #{count} urls"
