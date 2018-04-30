# frozen_string_literal: true

module RosterHelper
  # Returns country options for select for a user's currently
  # selected location/country
  #
  def roster_country_select(user)
    selected_country = user.region.blank? ? nil : user.region.country.to_param

    options_for_select(
      Country.all.collect { |country| [country.name, country.to_param] },
      selected: selected_country
    )
  end

  # Returns region options for select for a user's currently
  # selected location/region
  #
  def roster_region_select(user)
    return [] if user.region.blank?
    regions = user.region.country.regions

    options_for_select(
      regions.collect { |region| [region.name, region.id] },
      selected: user.region.id
    )
  end

  # Returns options for select based on the allowed sortable_columns
  # and the currently select sort_column
  #
  def roster_sort_options
    options_for_select(
      sortable_columns.collect { |c| [c[1], c[0]] },
      selected: sort_column
    )
  end

  # Returns an array of hashes containing history events to be displayed
  # on the roster show page.
  #
  # TODO refactor roster_user_history method for displaying user history
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def roster_user_history(user)
    events = []

    user.audits.descending.each do |audit|
      event = {}
      event[:date]        = audit.created_at
      event[:description] = []
      event[:updated_by]  = audit.user
      event[:type]        = audit.action.titleize

      # Audited changes
      audit.audited_changes.each do |k, v|
        # Rank
        if k.include? 'rank_id'
          if v.is_a? Array
            old_rank = User::Rank.find(v.first)
            new_rank = User::Rank.find(v.last)
            change = if new_rank.order > old_rank.order
                       "Promoted to #{new_rank}"
                     else
                       "Assigned rank #{new_rank}"
                     end

            event[:description].push change
          else
            event[:description].push "Assigned rank #{User::Rank.find(v).name}"
          end
        end
      end
      # audit.audited_changes.each

      events.push event unless event[:description].empty?
    end
    # user.audits.descending.each

    events
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # Returns an array of hashes containing network membership information for
  # a user:
  #   { network: 'VATSIM', username: link_to obj or username if no stats url }
  #
  def roster_user_networks(user)
    networks = []

    user.user_networks.each do |reg|
      network = reg.network

      url = if network.stats_url.present?
              link_to reg.username, network.stats_url + reg.username
            else
              reg.username
            end

      networks.push name: network.name, username: url
    end

    networks
  end

  # Method included for RSpec tests to pass
  #
  # The real method should be defined in the controller and extended as:
  # helper_method :sortable_columns
  #
  def sortable_columns
    {}
  end

  # Method included for RSpec tests to pass
  #
  # The real method should be defined in the controller and extended as:
  # helper_method :sort_columns
  #
  def sort_column; end
end
