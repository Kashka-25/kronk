# frozen_string_literal: true

# "Remind me" on a scheduled live set: the member gets a Nudge when the
# host goes live (`booth.live.started`, BoothLive#start!).
class BoothLiveReminder < ApplicationRecord
  belongs_to :account
  belongs_to :booth_live, inverse_of: :reminders

  validates :booth_live_id, uniqueness: { scope: :account_id }
end
