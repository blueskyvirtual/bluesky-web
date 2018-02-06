# frozen_string_literal: true

require 'rails_helper'

describe Airline::FlightPolicy do
  subject { described_class.new(user, flight) }

  let(:flight) { create(:airline_flight) }

  context 'unauthenticated user' do
    let(:user) { nil }

    it { is_expected.to permit_actions(%i[index show]) }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end
end
