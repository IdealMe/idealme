json.array!(@goals) do |json, goal|
  json.partial! 'goal', goal: goal
end