# frozen_string_literal: true

json.extract! word,
              :id,
              :name,
              :definition
json.creator do
  json.id word.user_id
  json.name word.user&.full_name
end
json.history do
  json.extract! word, :created_at, :updated_at
end
