require "spec_helper"

describe "Steps" do  
  def run_steps(steps)
    script = Capybara::Script::Base.new(steps)
    script.run
    script
  end
  
  describe Capybara::Script::Steps::Visit do
    it "visits google" do
      script = run_steps([[:visit, {:url => "http://www.google.com"}]])
      script.session.current_url.should eq "http://www.google.com/"
    end
  end
  
  describe Capybara::Script::Steps::FillIn do
    it "fills in a form" do
      script = run_steps [
        [:visit,    {:url => "http://en.wikipedia.org/wiki/Main_Page"}],
        [:fill_in,  {:selector => "search", :value => "test"}]
      ]
      script.session.find_field("search").value.should eq "test"
    end
  end
  
  describe Capybara::Script::Steps::ClickOn do
    it "clicks links, respects 'within'" do
      script = run_steps [
        [:visit,      {:url => "http://dleavitt-test.s3.amazonaws.com/within_spec.html"}],
        [:fill_in,    {:selector => "Search", :value => "test", :within => "#form2"}],
        [:click_on,   {:selector => "submit", :within => "#form2"}],
      ]
      
      script.session.current_url.split('?')[-1].should eq "search=test&formno=2"
    end
  end
  
  describe Capybara::Script::Steps::Check do
    it "checks the box" do
      script = run_steps [
        [:visit,      {:url => "http://dleavitt-test.s3.amazonaws.com/within_spec.html"}],
        [:check,      {:selector => "Checkbox Test"}],
        [:click_on,   {:selector => "submit_checkbox"}],
      ]
      
      script.session.current_url.split('?')[-1].should eq "checkbox_test=1"
    end
  end
end