module Admin::ArticlesHelper
  def available_goals_for(article, goal)
    options_for_select(Goal.all.collect { |goal| [goal.name, goal.id] }, goal.try(:id))
  end
end
