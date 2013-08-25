class DSAScraper

  require 'mechanize'

  def initialize(existing_date)
    @existing_date = existing_date
    @available_date = scraper_date
  end

  def newer_date_available?
    @available_date
  end

  def available_date
    @available_date
  end

  private

  def scraper_date

    agent = Mechanize.new

    manage_page = scraper_login(agent)
    select_page = manage_page.link_with(:id => "date-time-change").click.
      forms.first.submit

    best_date = get_date(select_page)

    if Date.parse(best_date) < @existing_date
      best_date
    else
      false
    end
  end

  def scraper_login(agent)
    agent.get('https://www.gov.uk/change-date-practical-driving-test').
      link_with(:text => /Start now/).click.
      form_with(:action => '/login') do |form|
      form.username = ENV['DSADRIVERNUMBER']
      form.password = ENV['DSAAPPOINTMENTNUMBER']
      end.click_button
  end

  def get_date(page)
    page.at('.button-board a').text
  end
end
