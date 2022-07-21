require 'rails_helper'

RSpec.describe Audience, type: :model do
  describe 'validation' do
    context ':name' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_length_of(:name).is_at_most(20) }
    end
  end
end
