require 'minitest/autorun'
require 'crawler'

class TestCrawler < Minitest::Test
  URL = 'http://dev.csweweb.indigo-interactive.com/CSWE_2/Centers-Initiatives.aspx'

  def setup
    @crawler = Crawler.new
  end

  def test_that_it_gets_the_page
    page = @crawler.grab URL
    assert_equal "200", page.code
  end

  def test_checking_good_urls_is_ok
    results = @crawler.find_bad_links URL
    assert_equal [], results
  end

end
