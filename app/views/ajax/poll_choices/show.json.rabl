object @poll_choice
attributes :id, :name
node(:total_votes) do |poll_choice|
  poll_choice.total_votes
end