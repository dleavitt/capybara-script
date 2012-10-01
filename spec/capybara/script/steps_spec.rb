require "spec_helper"

describe "Steps" do  
  def new_script(steps)
    session = Capybara::Session.new(:rack_test, TestApp)
    script = Capybara::Script.new(steps, :session => session)
  end
  
  def extract_results(session)
    YAML.load Nokogiri::HTML(session.body).xpath("//pre[@id='results']").first.text
  end
  
  describe Capybara::Script::Steps::Visit do
    let(:script) { new_script([[:visit, {:url => "/foo"}]]) }
    
    it "calls visit" do
      script.session.should_receive(:visit).with("/foo")
      script.run
    end
    
    it "changes the path" do
      script.run
      script.session.current_path.should eq "/foo"
    end
  end
  
  describe Capybara::Script::Steps::FillIn do
    let(:script) do 
      new_script [
        [:visit,    {:url => "/form"}],
        [:fill_in,  {:selector => "Last Name", :value => "test"}]
      ]
    end
    
    it "fills in a form" do
      script.run
      script.session.find_field("Last Name").value.should eq "test"
    end
  end
  
  describe Capybara::Script::Steps::ClickOn do
    let(:script) do
      new_script [
        [:visit,      {:url => "/with_scope"}],
        [:fill_in,    {:selector => "First Name", :value => "Daniel", :within => "form[action='/form']"}],
        [:click_on,   {:selector => "Go", :within => "form[action='/form']"}],
      ]
    end
    
    it "clicks links, respects 'within'" do
      script.run
      script.session.current_path.should eq "/form"
      extract_results(script.session)['first_name'].should == "Daniel"
    end
  end
  
  describe Capybara::Script::Steps::Check do
    let(:script) do
      new_script [
        [:visit,      {:url => "/form"}],
        [:fill_in,    {:selector => "Name", :value => "Piggus Maloy"}],
        [:check,      {:selector => "Cat"}],
        [:click_on,   {:selector => "awesome"}],
      ]
    end
    
    it "checks checkboxes" do
      script.run
      script.session.current_path.should eq "/form"
      extract_results(script.session)['name'].should == "Piggus Maloy"
      extract_results(script.session)['pets'].should =~ %w(cat hamster dog)
    end
  end
  
  describe Capybara::Script::Steps::Uncheck do
    let(:script) do
      new_script [
        [:visit,      {:url => "/form"}],
        [:uncheck,    {:selector => "Dog"}],
        [:click_on,   {:selector => "awesome"}],
      ]
    end
    
    it "unchecks checkboxes" do
      script.run
      script.session.current_path.should eq "/form"
      extract_results(script.session)['pets'].should =~ %w(hamster)
    end
  end
  
  describe Capybara::Script::Steps::Choose do
    let(:script) do
      new_script [
        [:visit,      {:url => "/form"}],
        [:choose,     {:selector => "Both"}],
        [:click_on,   {:selector => "awesome"}],
      ]
    end
    
    it "chooses radio buttons" do
      script.run
      extract_results(script.session)['gender'].should == "both"
    end
  end
  
  describe Capybara::Script::Steps::Select do
    let(:script) do
      new_script [
        [:visit,      {:url => "/form"}],
        [:select,     {:selector => "Locale", :value => "Norwegian"}],
        [:select,     {:selector => "Languages", :value => "Ruby"}],
        [:select,     {:selector => "Languages", :value => "SQL"}],
        [:click_on,   {:selector => "awesome"}],
      ]
    end
    
    it "selects menu items" do
      script.run
      extract_results(script.session)['locale'].should == "no"
      extract_results(script.session)['languages'].should =~ %w(Ruby SQL)
    end
  end
  
  describe Capybara::Script::Steps::Unselect do
    let(:script) do
      new_script [
        [:visit,      {:url => "/form"}],
        [:unselect,     {:selector => "Underwear", :value => "Briefs"}],
        [:unselect,     {:selector => "Underwear", :value => "Commando"}],
        [:unselect,     {:selector => "Underwear", :value => "Frenchman's Pantalons"}],
        [:click_on,   {:selector => "awesome"}],
      ]
    end
    
    it "unselects menu items" do
      script.run
      extract_results(script.session)['underwear'].should =~ ["Boxer Briefs", "thermal"]
    end
  end
end