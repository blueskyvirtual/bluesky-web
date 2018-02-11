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
  # describe '#roster_sort_columns'

  describe '#roster_user_history' do
    it 'returns an entry when a rank is assigned' do
      user     = create(:user)
      audit    = user.audits.descending.first
      expected = {
        date:         audit.created_at,
        description:  ["Assigned rank #{user.rank}"],
        type:         audit.action.titleize,
        updated_by:   nil
      }
      expect(helper.roster_user_history(user).first).to eq expected
    end

    it 'returns an entry when a promotion has occurred' do
      user      = create(:user)
      user.rank = User::Rank.find_by(name: 'Captain')
      user.save

      audit     = user.audits.descending.first
      expected  = {
        date:         audit.created_at,
        description:  ["Promoted to #{user.rank}"],
        type:         audit.action.titleize,
        updated_by:   nil
      }
      expect(helper.roster_user_history(user).first).to eq expected
    end

    it 'returns assigned rank entry if demoted' do
      user = create(:user)
      user.update! rank: User::Rank.find_by(name: 'Captain')
      user.update! rank: User::Rank.find_by(name: 'First Officer')

      audit     = user.audits.descending.first
      expected  = {
        date:         audit.created_at,
        description:  ["Assigned rank #{user.rank}"],
        type:         audit.action.titleize,
        updated_by:   nil
      }
      expect(helper.roster_user_history(user).first).to eq expected
    end
  end
  # describe '#roster_user_history'

  describe '#roster_user_networks' do
    before :each do
      network      = create(:network, stats_url: 'test://stats?cid=')
      user_network = create(:user_network, network: network)
      @user     = user_network.user
      @network  = user_network.network
      @username = user_network.username
    end

    it 'returns an Array of Hashes with :network and :user stats links' do
      expected = [{ name: @network.name, username: "<a href=\"test://stats?cid=#{@username}\">1</a>" }]
      expect(helper.roster_user_networks(@user)).to eq expected
    end

    it 'returns an Array of Hashes with :network and :username if no stats' do
      @network.stats_url = nil
      @network.save
      expected = [{ name: @network.name, username: @username }]
      expect(helper.roster_user_networks(@user)).to eq expected
    end
  end
  # describe '#roster_user_networks'

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
