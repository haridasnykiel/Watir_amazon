require './spec_helper.rb'

describe "Amazon Search" do

  before :all do
    @driver = Watir::Browser.start"https://www.amazon.co.uk"
    @test = YAML.load(File.open("./test_data.yml"))["test_data"]
  end

  after :all do
    # @driver.close
    # puts "        Your tests are successful        "
  end

  it "Load YAML file" do
    expect(@test.to_a.size).to eq 1
    expect(@test["search"]).to eq "Object Oriented Programming Questions and Answers"
  end

  it "Should be able to search for object oriented programming books" do
    search_box = @driver.div(:class => "nav-search-field").text_field(:id => "twotabsearchtextbox")
    search_box.set @test["search"]
    press = @driver.div :class => "nav-search-submit nav-sprite"
    press.click
    sleep 1
    book_title = @driver.ul(:id => "s-results-list-atf").div(:class => "s-item-container").a(:class, "a-link-normal s-access-detail-page  a-text-normal")
    book_title.click
    book_price = @driver.span(:id, "a-autoid-3").span(:class, "a-color-price")
    expect(book_price.text).to eq "£10.30"
  end

  it "List all the Questions and Answers books which are the results of the search, with the price." do
    list = []
    press = @driver.div :class => "nav-search-submit nav-sprite"
    press.click
    book_list = @driver.ul(:id => "s-results-list-atf")
    book_list.lis.each do |item|
      list.push(@driver.li(:id => item.id).h2.text + " - " + @driver.li(:id => item.id).span(:class, "a-size-base a-color-price s-price a-text-bold").text) # The .id section will just grab the id of that element.
    end

    open('list_of_items.txt', 'w') do |file| # file represents the the text file.
      file.puts "Amazon Object Oriented Programming Book List\n\n"

      list.each do |item| # item represents each item in the array list.
        file.puts item
      end
    end

  end
  # title = book_list.h2(:class, "a-size-medium a-color-null s-inline  s-access-title  a-text-normal").text
  #
  # price = book_list.span(:class, "a-size-base a-color-price s-price a-text-bold").text


end
