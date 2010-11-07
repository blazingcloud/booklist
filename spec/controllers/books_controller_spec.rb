require 'spec_helper'
require 'capybara/rails'

describe BooksController do
  include Capybara
  render_views

  before do
    @twist_attrs = { :title => "Oliver Twist",
                     :description => "A book about an orphan",
                     :year => 1838 }
    @potter_attrs = { :title => "Harry Potter and the Sorcerer's Stone",
                     :description => "A book about a magic orphan",
                     :year => 2001 }
    Book.create! @twist_attrs
    Book.create! @potter_attrs
  end

  describe "home page" do
    it "should list books" do
      visit root_path
      #save_and_open_page
      page.should have_content("Harry Potter")
      page.should have_content("Oliver Twist")
    end

    it "should have a link to create a new book" do
      visit root_path
      click_link "New Book"
      current_path.should == new_book_path
    end
  end

  describe "show page" do
    it "should display all the info about the book" do
      @book = Book.first
      visit book_path(@book)
      page.should have_content(@book.title)
      page.should have_content(@book.description)
      page.should have_content(@book.year.to_s)

    end
  end

  describe "new page" do
    describe "should allow creation of a book" do
      before do
        visit new_book_path
        fill_in('Title', :with => 'Dune')
        fill_in('Description', :with => 'A boy goes into the desert and turns into a worm.')
        fill_in("Year", :with => 1965)
        click_button('Create Book')
        @new_book = Book.last
      end
      it "and save it" do
        @new_book.should_not be_new_record
        @new_book.title.should == "Dune"
      end
      it "and show book page" do
        current_path.should == book_path(@new_book)
        page.should have_content("Dune")
      end
    end

    it "should redirect to new page on failure" do
      visit new_book_path
      fill_in("Year", :with => 1965)
      click_button('Create Book')
      #save_and_open_page
      page.should have_xpath('//form/input', :value => "1965")
      page.should have_content("Sorry I couldn't save your book...")
      page.should have_content("Title can't be blank")
    end
  end
  
  describe "edit page" do
    describe "should allow use to edit book" do
      before do
        @book = Book.first
        visit edit_book_path(@book)
        fill_in('Year', :with => 1900)
        click_button('Update Book')
        @book.reload
      end
      it "and save it" do
        @book.year.should == 1900
      end
      it "and show book page" do
        current_path.should == book_path(@book)
        page.should have_content("1900")
      end
    end

    it "should redirect to edit page on failure" do
      @book = Book.first
      visit edit_book_path(@book)
      fill_in("Year", :with => "")
      click_button('Update Book')
      save_and_open_page
      page.should have_xpath('//form/input', :value => "")
      page.should have_content("Sorry I couldn't save your book...")
      page.should have_content("Year is not a number")
    end
  end

end
