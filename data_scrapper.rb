require 'nokogiri'
require 'open-uri'

# This service does scrape the data from the openfoodfacts.org website
# step by step :
# - get html from the website using the provided ean
# - extract the data we want from the html
# - return the data as a hash
class DataScrapper
  URL = 'https://fr.openfoodfacts.org/product'.freeze

  def fetch(ean)
    @ean = ean

    get_data
  end

  private

  def get_webpage
    # Get and return the html from the webpage using Nokogiri::HTML
    # URI#open is used to open the webpage for use with nokogiri

    # WARNING: Using URI#open is a security risk, try and replace that
    Nokogiri::HTML(URI.open("#{URL}/#{@ean}"))
  end

  def get_data
    # parse the html returned from #get_webpage using xpath and
    # return the data in a structured hash

    html = get_webpage
    data = {}

    data[:ean] = @ean

    # We need to use Object#to_s because Nokogiri::HTML#xpath will return a nokogiri object
    data[:name] = html.xpath('//*[@id="main_column"]/div[4]/h1/text()').to_s

    # We need to interpolate the url at the beginning of the string because
    # the src attribute from the img tag does not includes it
    data[:image_url] = "#{URL}#{html.xpath('//*[@id="og_image"]').attr('src')}"

    data
  end
end

DataScrapper.new.fetch('3017620425035')
