# frozen_string_literal: true

json.extract! crag_route,
              :id,
              :name,
              :height,
              :open_year,
              :opener,
              :climbing_type,
              :sections_count,
              :max_bolt
json.grade_gap do
  json.extract! crag_route,
                :max_grade_value,
                :min_grade_value,
                :max_grade_text,
                :min_grade_text
end
json.sections crag_route.sections
json.crag do
  json.id crag_route.crag.id
  json.name crag_route.crag.name
end
json.sector do
  json.id crag_route.crag_sector&.id
  json.name crag_route.crag_sector&.name
end

json.comment_count crag.comments.count
json.link_count crag.links.count
json.follow_count crag.follows.count

json.creator do
  json.id crag_route.user_id
  json.name crag_route.user&.full_name
end
json.history do
  json.extract! crag_route, :created_at, :updated_at
end
