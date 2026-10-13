# frozen_string_literal: true

class REST::BoothLiveSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :genres, :state, :room_key,
             :starts_at, :started_at, :ended_at, :is_owner

  belongs_to :account, serializer: REST::AccountSerializer

  def id
    object.id.to_s
  end

  # rubocop:disable Naming/PredicatePrefix -- `is_owner` is the JSON API key, as on REST::BoothSetSerializer
  def is_owner
    current_user&.account_id == object.account_id
  end
  # rubocop:enable Naming/PredicatePrefix
end
