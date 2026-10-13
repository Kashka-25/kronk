# frozen_string_literal: true

require 'rails_helper'

# docs/spaces/booth.md, Live sets.
RSpec.describe 'API V1 Booth Lives' do
  let(:user)    { Fabricate(:user) }
  let(:token)   { Fabricate(:accessible_access_token, resource_owner_id: user.id, scopes: 'read:statuses write:statuses') }
  let(:headers) { { 'Authorization' => "Bearer #{token.token}" } }

  describe 'GET /api/v1/booth_lives' do
    let!(:live)       { Fabricate(:booth_live, title: 'On now', started_at: 10.minutes.ago) }
    let!(:soon)       { Fabricate(:booth_live, title: 'Soon', starts_at: 2.hours.from_now) }
    let!(:sooner)     { Fabricate(:booth_live, title: 'Sooner', starts_at: 30.minutes.from_now) }

    before do
      Fabricate(:booth_live, title: 'Over', started_at: 2.hours.ago, ended_at: 1.hour.ago)
      Fabricate(:booth_live, title: 'Forgotten', started_at: 13.hours.ago)
      Fabricate(:booth_live, title: 'Missed', starts_at: 7.hours.ago)
    end

    it 'lists what is live, then what is coming soonest first, and nothing over', :aggregate_failures do
      get '/api/v1/booth_lives', headers: headers

      expect(response).to have_http_status(200)
      expect(response.parsed_body.pluck('id')).to eq [live, sooner, soon].map { |l| l.id.to_s }
      expect(response.parsed_body.pluck('state')).to eq %w(live scheduled scheduled)
      expect(response.parsed_body.first['room_key']).to start_with('booth-')
    end

    it 'is for members only' do
      get '/api/v1/booth_lives'

      expect(response).to have_http_status(401)
    end
  end

  describe 'hosting' do
    it 'schedules, goes live and ends, owner only', :aggregate_failures do
      post '/api/v1/booth_lives', headers: headers, params: { title: 'Sunday session', genres: %w(house), starts_at: 1.day.from_now.iso8601 }
      id = response.parsed_body['id']

      expect(response.parsed_body).to include('state' => 'scheduled', 'is_owner' => true, 'genres' => %w(house))

      other = Fabricate(:user)
      other_token = Fabricate(:accessible_access_token, resource_owner_id: other.id, scopes: 'read:statuses write:statuses')
      post "/api/v1/booth_lives/#{id}/start", headers: { 'Authorization' => "Bearer #{other_token.token}" }
      expect(response).to have_http_status(403)

      post "/api/v1/booth_lives/#{id}/start", headers: headers
      expect(response.parsed_body['state']).to eq 'live'

      delete "/api/v1/booth_lives/#{id}", headers: headers
      expect(response).to have_http_status(403)

      post "/api/v1/booth_lives/#{id}/finish", headers: headers
      expect(response.parsed_body['state']).to eq 'ended'

      post "/api/v1/booth_lives/#{id}/start", headers: headers
      expect(response).to have_http_status(403)
    end

    it 'starts now when no time is given' do
      post '/api/v1/booth_lives', headers: headers, params: { title: 'Right now' }

      expect(Time.zone.parse(response.parsed_body['starts_at'])).to be_within(1.minute).of(Time.current)
    end

    it 'tells the feed at the reach the host picks, never a retired one', :aggregate_failures do
      booth_live = Fabricate(:booth_live, account: user.account, started_at: 1.minute.ago)

      post "/api/v1/booth_lives/#{booth_live.id}/share", headers: headers, params: { visibility: 'mates' }
      status = Status.find(response.parsed_body['id'])
      expect(status.visibility).to eq 'mates'
      expect(status.text).to include('Live now in the Booth', "/hub/booth/live/#{booth_live.id}")
      expect(booth_live.reload.status_id).to eq status.id

      post "/api/v1/booth_lives/#{booth_live.id}/share", headers: headers, params: { visibility: 'unlisted' }
      expect(Status.find(response.parsed_body['id']).visibility).to eq 'public'
    end
  end
end
