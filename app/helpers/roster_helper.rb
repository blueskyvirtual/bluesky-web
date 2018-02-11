# frozen_string_literal: true

module RosterHelper
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
  # rubocop:disable Metrics/AbcSize
  def roster_user_networks(user)
    networks = []

    user.user_networks.joins(:network) \
        .order('networks.name') \
        .pluck(:name, :username, :stats_url) \
        .each do |network|

      url = if network[2].present?
              link_to(network[1], network[2] + network[1])
            else
              network[1]
            end

      networks.push(
        name: network[0], username: url
      )
    end

    networks
  end
  # rubocop:enable Metrics/AbcSize

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
