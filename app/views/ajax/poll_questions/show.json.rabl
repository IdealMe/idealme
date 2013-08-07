object @poll_question
attributes :id, :name
child :poll_choices do
  extends 'ajax/poll_choices/index'
end
node(:total_votes) do |poll_question|
  poll_question.total_votes
end