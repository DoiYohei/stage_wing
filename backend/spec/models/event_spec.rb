require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "validation" do
    context ":name" do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_length_of(:name).is_at_most(50) }
    end
    context ":place" do
      it { is_expected.to validate_presence_of :place }
      it { is_expected.to validate_length_of(:place).is_at_most(50) }
    end
    context ":content" do
      it { is_expected.to validate_length_of(:content).is_at_most(1000) }
    end
    context ":unregistered_performers" do
      it { is_expected.to validate_length_of(:unregistered_performers).is_at_most(1000) }
    end
    context ":open_at" do
      it { is_expected.to validate_presence_of :open_at }
    end
    context ":start_at" do
      it { is_expected.to validate_presence_of :start_at }
    end
    context ":reservation" do
      it { is_expected.to allow_value(true).for(:reservation) }
      it { is_expected.to allow_value(false).for(:reservation) }
      it { is_expected.not_to allow_value(nil).for(:reservation) }
    end
  end
end
