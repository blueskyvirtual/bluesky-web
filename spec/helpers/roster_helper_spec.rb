# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the RosterHelper. For example:
#
# describe RosterHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe RosterHelper, type: :helper do
  describe '#roster_sort_columns' do
    before :each do
      @sortable_columns = {
        col1: 'column1',
        col2: 'column2',
        col3: 'column3'
      }
    end

    it 'returns options_for_select containing allowed sortable columns' do
      expected_response =
        '<option value="col1">column1</option>' + "\n" \
        '<option value="col2">column2</option>' + "\n" \
        '<option value="col3">column3</option>'

      allow(helper).to receive(:sortable_columns) { @sortable_columns }
      expect(helper.roster_sort_options).to eq expected_response
    end
  end

  describe '#sort_column' do
    it 'returns nil (normally overridden by controller)' do
      expect(helper.sort_column).to be_nil
    end
  end

  describe '#sortable_columns' do
    it 'returns an empty hash (normally overridden by controller)' do
      expect(helper.sortable_columns).to eq({})
    end
  end
end
