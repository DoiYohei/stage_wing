require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validation" do
    context ":format" do
      it { is_expected.to validate_presence_of :format }
    end
    context ":description" do
      it { is_expected.to validate_length_of(:description).is_at_most(500) }
    end
    context ":media_pass" do
      it { is_expected.to allow_value(nil).for(:media_pass) }
      it { is_expected.to allow_value("Test1").for(:media_pass) }
      it { is_expected.not_to allow_value("test-1", "テスト").for(:media_pass) }
    end
  end
end
