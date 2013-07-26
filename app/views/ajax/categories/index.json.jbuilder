json.array!(@categories) do |json, category|
  json.partial! 'category', category: category
end