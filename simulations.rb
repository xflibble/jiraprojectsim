require 'csv'
require 'rubystats'

# We get these from JIRA's control chart for the desired state transitions
story_mean_duration=2.9
story_duration_sd=6.2

#Generate a bunch of random story durations based on JIRA's distribution
story_sample=Rubystats::NormalDistribution.new(story_mean_duration, story_duration_sd)
story_duration_dataset = 20000.times.map { story_sample.rng.round(1) }
scale_factor=story_mean_duration/(story_duration_dataset.min-story_mean_duration)

#We get negative story durations, so we squash the left hand side of the curve. Good enough.
story_duration_dataset.collect! do | sample | 
  if sample<story_mean_duration
    story_mean_duration-((sample-story_mean_duration)*scale_factor)
  else
    sample  
  end
end

#You could also bring the story data in from a file. I previously used the excel file - 'story duration distribution generator.xlsx' for this
#story_duration_dataset=CSV.read('story distributions.csv',encoding: "UTF-8").collect { | i |i[0].to_f}

# Define how many stories we need to deliver (ie. Current backlog to ship)
stories_to_simulate=100
confidences=[50,75,99]
simulations=[]  
10000.times do | sim |
  duration=0
  stories_to_simulate.times do |t|
    selection=rand(story_duration_dataset.size)
    duration+=story_duration_dataset[selection]
  end
  simulations.push duration
end

simulations.sort!

puts "Simulation results for delivery of #{stories_to_simulate} stories"
puts "Shortest simulated duration: "+simulations.first.round(1).to_s+" days"
confidences.each do | confidence |
  puts "#{confidence} percent duration: "+ simulations[(simulations.size*(confidence/100.to_f)).to_i].round(1).to_s+" days"
end
puts "Longest simulated duration: "+ simulations.last.round(1).to_s+" days"

# Excel file "story duration distribution generator.xlsx" generates a set of normally-distributed values based on median, standard deviation, grabbed from JIRA control chart
# Save the "Squashed LHS" column data to "story distributions.csv"
# As story duration data is fake (ie. a normal distribution produced from two Jira data points), the left hand side of the 
#  normal curve is squashed to eliminate negative values.
# 
# Generate median, sd from control chart in JIRA for desired transitions (eg. in-dev to done)