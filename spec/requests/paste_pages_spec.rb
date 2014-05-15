require 'spec_helper'
include PastesHelper

describe "PastePages" do
    
  subject { page }


  describe "Main page" do
    it "should" do
      visit '/'

      expect(page).to have_title("Pastestack")
    end
  end

  describe "paste creation" do
      before do 
          visit root_path
      end
       
      let(:submit) { "push()" }

      describe "with no content" do
        it "should not create a paste" do
            expect { click_button submit }.not_to change(Paste, :count)
        end
      end


      PastesHelper.available_languages.each do |lang|
          describe "with language #{lang}" do
              before do
                  fill_in "paste_title", with: "title_#{lang}"
                  fill_in "paste_content", with: "myspecialpaste"
                  select(lang, :from => 'paste_language')
              end

              it "should create a paste" do
                  expect { click_button submit }.to change(Paste, :count)
              end

              describe "after creation" do
                  before { click_button submit }
                  let(:paste) { Paste.find_by(:title => "title_#{lang}") }
                  it { should have_content(paste.title) }
                  it { should have_content(paste.content) }
              end
          end
      end

      describe "with valid content" do

          before do
               
              fill_in "paste_title", with: "myspecialpaste"
              fill_in "paste_content", with: "my content\n\nyes"
              
          end
         

          it "should create a paste" do
              
              expect { click_button submit}.to change(Paste, :count)
          end

          describe "after creation" do
               
              before { click_button submit }

              let(:paste) { Paste.find_by(:title => "myspecialpaste" ) }

              it { should have_content(paste.title) }
              it { should have_content(paste.content) }
          end

      end
  end

  describe "signing in and out" do
      before { visit root_path }

      let(:sign_in) { "Log in" }

      describe "with invalid credentials" do
          before { click_button sign_in }

          it { should have_content("Log in") }
      end

      describe "with valid credentials" do
          let(:user) { FactoryGirl.create(:user) }

          before do
              fill_in "session_email", with: user.email
              fill_in "session_password", with: user.password
              click_button "Log in"
          end

          it { should have_content("Welcome, #{user.name}!") }
          it { should have_link("Sign out") }

          describe "signing out" do
              before { click_link("Sign out") }
              it { should have_content("Log in") }
              it { should have_content("Sign up now!") }
          end
      end
  end

  describe "registering" do
    before { visit signup_path }
   
    let(:register) { "Submit" }

    describe "with no information" do
        it "should not create an user" do
            expect { click_button register }.not_to change(User, :count)
        end
    end

    describe "with mismatching passwords" do
        before do
            fill_in "user_name", with: "mismatcher"
            fill_in "user_email", with: "mis@match.com"
            fill_in "user_password", with: "password0"
            fill_in "user_password_confirmation", with: "nothinghere"
        end

        it "should not create an user" do
            expect { click_button register }.not_to change(User, :count)
        end
    end

    describe "with correct information" do
        before do
            fill_in "user_name", with: "newlycreatedperson"
            fill_in "user_email", with: "email@email.com"
            fill_in "user_password", with: "securepassword"
            fill_in "user_password_confirmation", with: "securepassword"
        end

        it "should create an user" do
            expect { click_button register }.to change(User, :count).by(1)
        end

        describe "after registering" do
            before { click_button register}
            let(:user) { User.find_by(email: 'email@email.com') }

            it { should have_content("Welcome, #{user.name}!") }
        end
    end

  end

  describe "paste searching" do

    before { visit root_path }

    let(:search) { "Find" }

    describe "with results" do
        let(:pastes) { (0..3).map{|n| FactoryGirl.create(:paste) } }

        before do
            fill_in "search_field", with: "SILLYCONTENT"
            click_button search 
        end

        Paste.all.each { |p|
             it { should have_content(p.title) }
        }
    end

  end

  describe "Pastes page" do
    it "should have content Public pastes" do
        visit '/pastes'

        expect(page).to have_content("Public pastes")
    end

  end
end
