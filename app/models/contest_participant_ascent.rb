# frozen_string_literal: true

class ContestParticipantAscent < ApplicationRecord
  belongs_to :contest_participant
  belongs_to :contest_route
  has_one :contest_category, through: :contest_participant
  has_one :contest, through: :contest_category

  before_validation :set_registered_at
  before_validation :normalize_attributes

  after_destroy :delete_caches
  after_update :delete_caches

  def summary_to_json
    {
      id: id,
      contest_participant_id: contest_participant_id,
      contest_route_id: contest_route_id,
      registered_at: registered_at,
      realised: realised,
      zone_1_attempt: zone_1_attempt,
      zone_2_attempt: zone_2_attempt,
      top_attempt: top_attempt,
      hold_number: hold_number,
      hold_number_plus: hold_number_plus
    }
  end

  def detail_to_json
    summary_to_json.merge(
      {
        history: {
          created_at: created_at,
          updated_at: updated_at
        }
      }
    )
  end

  private

  def delete_caches
    contest.delete_results_cache
  end

  def set_registered_at
    self.registered_at ||= DateTime.current
  end

  def normalize_attributes
    self.zone_1_attempt = nil if zone_1_attempt.blank?
    self.zone_2_attempt = nil if zone_2_attempt.blank?
    self.top_attempt = nil if top_attempt.blank?
    self.hold_number = nil if hold_number.blank?
    self.hold_number_plus = nil if hold_number_plus.blank?
  end
end
