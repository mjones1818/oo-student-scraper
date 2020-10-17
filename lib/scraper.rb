require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open("https://learn-co-curriculum.github.io/student-scraper-test-page/index.html")
    doc = Nokogiri::HTML(html)
    roster = doc.css(".student-card")
    student_hash = []
    roster.each do |student|
      name = student.css("a .card-text-container h4").text
      location = student.css("a .card-text-container p").text
      profile_url = student.css("a").attribute("href").value
      students = {
        :name => name,
        :location => location,
        :profile_url => profile_url
      }
      student_hash << students
      
    end
    student_hash
    
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    profile = doc.css(".social-icon-container")
    social = profile.css("a")
    social_hash = {}
    websites = ['twitter','linkedin','github']
    social.each do |address|
      name = address.attribute("href").value.split("/")[2].split(".")[0]
      if name == "www"
        name = address.attribute("href").value.split("/")[2].split(".")[1]
      elsif websites.any? {|site| site == name} == false
        name = 'blog'  
      end 
      web_address = address.attribute("href").value
      social_hash[name.to_sym] = web_address
    end
    social_hash["profile_quote".to_sym] = doc.css(".vitals-text-container .profile-quote").text
    social_hash["bio".to_sym] = doc.css(".details-container p").text
    social_hash

    
  end

end

# roster.css(".student-card")
# roster.css(".student-card a .card-text-container h4").text
# student.css("a").attribute("href").value

# twitter      profile.css("a").attribute("href").value