require 'spec_helper'

describe User do
  
    before do
     @user = User.new(email: "test@testuser.com",
        password: "testpw",
        password_confirmation: "testpw")
    end

    subject { @user }

    it { should respond_to(:email) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:authenticate) }

    it { should be_valid }

    describe "when email is not present" do
        before { @user.email = " " }
        it { should_not be_valid }
    end

    describe "when user with email already registered" do
        before do
            duplicate_user = @user.dup
            duplicate_user.email = @user.email.upcase
            duplicate_user.save
        end

        it { should_not be_valid }
    end

    describe "when password is not present" do
        before do
            @user = User.new(email: "testuser@testurl.com", password: "  ", password_confirmation: "  ")
        end

        it { should_not be_valid }
    end

    describe "when password does not match confirmation" do
        before { @user.password_confirmation = "WRONG" }
        it { should_not be_valid }
    end

    describe "when the password is too short" do
        before { @user.password = @user.password_confirmation = "ccc" }
        it { should be_invalid }
    end

    describe "authentication result" do
        before { @user.save }
        let(:existing_user) { User.find_by(email: @user.email) }

        describe "with valid password" do
            it { should eq existing_user.authenticate(@user.password) }
        end

        describe "with invalid password" do
            let(:user_for_invalid_pw) { existing_user.authenticate("WONTHAPPEN") }
            it { should_not eq user_for_invalid_pw }
            specify { expect(user_for_invalid_pw).to be_false }
        end
    end
end
