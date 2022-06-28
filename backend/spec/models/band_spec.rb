require 'rails_helper'

RSpec.describe Band, type: :model do
  describe "validation" do
    describe ":email" do
      context "when correct format" do
        let(:band1) { build(:band, email: "test1@example.com") }
        let(:band2) { build(:band, email: "T.e_s-t@example.com") }
        let(:band3) { build(:band, email: "test@example.ne.jp") }
        it "is valid" do
          expect(band1).to be_valid
          expect(band2).to be_valid
          expect(band3).to be_valid
        end
      end
      context "when incorrect format" do
        let(:band1) { build(:band, email: "test@example") }
        let(:band2) { build(:band, email: "test@example.ne-jp") }
        let(:band3) { build(:band, email: "test.com") }
        it "is invalid" do
          expect(band1).to be_invalid
          expect(band2).to be_invalid
          expect(band3).to be_invalid
        end
      end
    end
    describe ":website" do
      context "when correct format" do
        let(:band1) { build(:band, website: "http://example1.com") }
        let(:band2) { build(:band, website: "http://www.example.com") }
        let(:band3) { build(:band, website: "http://example@#$&*()-_+~:;',?=test.com") }
        it "is valid" do
          expect(band1).to be_valid
          expect(band2).to be_valid
          expect(band3).to be_valid
        end
      end
      context "when incorrect format" do
        let(:band1) { build(:band, website: "javascript:alert('XSS');//http://example.com") }
        let(:band2) { build(:band, website: "http://example.com/?<script>alert(document.domain);</script>") }
        let(:band3) { build(:band, website: "http://example.com/\"onmouseover=\"alert(1)\"") }
        it "is invalid" do
          expect(band1).to be_invalid
          expect(band2).to be_invalid
          expect(band3).to be_invalid
        end
      end
    end
    describe ":twitter" do
      context "when correct format" do
        let(:band1) { build(:band, twitter: "http://example1.com") }
        let(:band2) { build(:band, twitter: "http://www.example.com") }
        let(:band3) { build(:band, twitter: "http://example@#$&*()-_+~:;',?=test.com") }
        it "is valid" do
          expect(band1).to be_valid
          expect(band2).to be_valid
          expect(band3).to be_valid
        end
      end
      context "when incorrect format" do
        let(:band1) { build(:band, twitter: "javascript:alert('XSS');//http://example.com") }
        let(:band2) { build(:band, twitter: "http://example.com/?<script>alert(document.domain);</script>") }
        let(:band3) { build(:band, twitter: "http://example.com/\"onmouseover=\"alert(1)\"") }
        it "is invalid" do
          expect(band1).to be_invalid
          expect(band2).to be_invalid
          expect(band3).to be_invalid
        end
      end
    end
  end
end
