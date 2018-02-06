# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the HomeHelper. For example:
#
# describe HomeHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe HomeHelper, type: :helper do
  describe '#randomized_background_image' do
    it 'returns a random image asset_path for background images' do
      expect(helper.randomized_background_image.class).to eq String
    end
  end
end
