require 'rails_helper'

RSpec.describe Band, type: :model do
  describe "validation" do
    let(:band) { build(:band) }
    subject { band } 
    describe ":name" do
      context "when present" do
        before { band.name = "test" }
        it { is_expected.to be_valid }
      end
      context "when not present" do
        before { band.name = nil }
        it { is_expected.to be_invalid }
      end
    end
    describe ":email" do
      context "when correct format" do
        before { band.email = "test1@example.com" }
        it { is_expected.to be_valid }
        before { band.email = "T.e_s-t@example.com" }
        it { is_expected.to be_valid }
        before { band.email = "test@example.ne.jp" }
        it { is_expected.to be_valid }
      end
      context "when incorrect format" do
        before { band.email = ".test@example.com" }
        it { is_expected.to be_invalid }
        before { band.email = "test-@example.com" }
        it { is_expected.to be_invalid }
        before { band.email = "test.com" }
        it { is_expected.to be_invalid }
      end
    end
    describe ":website" do
      context "when correct format" do
        before { band.website = "http://example.com" }
        it { is_expected.to be_valid }
      end
      context "when incorrect format" do
        before { band.website = "javascript:alert('XSS');//http://example.com" }
        it { is_expected.to be_invalid }
        before { band.website = "http://example.com/?<script>alert(document.domain);</script>" }
        it { is_expected.to be_invalid }
        before { band.website = "http://example.com/\"onmouseover=\"alert(1)\"" }
        it { is_expected.to be_invalid }
      end
    end
    describe ":twitter" do
      context "when correct format" do
        before { band.twitter = "http://example.com" }
        it { is_expected.to be_valid }
      end
      context "when incorrect format" do
        before { band.twitter = "javascript:alert('XSS');//http://example.com" }
        it { is_expected.to be_invalid }
        before { band.twitter = "http://example.com/?<script>alert(document.domain);</script>" }
        it { is_expected.to be_invalid }
        before { band.twitter = "http://example.com/\"onmouseover=\"alert(1)\"" }
        it { is_expected.to be_invalid }
      end
    end
  end
end
