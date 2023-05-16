require 'csv'

story_duration_dataset=CSV.read('story distributions.csv',encoding: "UTF-8").collect { | i |i[0].to_f}
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

puts "Shortest simulated duration: "+simulations.first.to_s
confidences.each do | confidence |
  puts "#{confidence} percent duration: "+ simulations[(simulations.size*(confidence/100.to_f)).to_i].to_s
end
puts "Longest simulated duration: "+ simulations.last.to_s

# Excel file "story duration distribution generator.xlsx" generates a set of normally-distributed values based on median, standard deviation, grabbed from JIRA control chart
# Save the "Squashed LHS" column data to "story distributions.csv"
# As story duration data is fake (ie. a normal distribution produced from two Jira data points), the left hand side of the 
#  normal curve is squashed to eliminate negative values.
# 
# Generate median, sd from control chart in JIRA for desired transitions (eg. in-dev to done)