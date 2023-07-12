import csv
import numpy
import random
#require 'rubystats'

def squash(sample,scale_factor,mean):
    if sample<mean:
        return mean-((sample-mean)*scale_factor)
    else:
        return sample
    

# We get these from JIRA's control chart for the desired state transitions
story_mean_duration=2.9
story_duration_sd=6.2

#Generate a bunch of random story durations based on JIRA's distribution
story_duration_dataset = numpy.random.normal(story_mean_duration, story_duration_sd, 20000)
scale_factor=story_mean_duration/(min(story_duration_dataset)-story_mean_duration)

#We get negative story durations, so we squash the left hand side of the curve. Good enough.
story_duration_dataset=[squash(sample,scale_factor,story_mean_duration) for sample in story_duration_dataset]

#You could also bring the story data in from a file. I previously used the excel file - 'story duration distribution generator.xlsx' for this
#story_duration_dataset=CSV.read('story distributions.csv',encoding: "UTF-8").collect { | i |i[0].to_f}

# Define how many stories we need to deliver (ie. Current backlog to ship)
stories_to_simulate=100
confidences=[50,75,99]
simulations=[]  
for sim in range(10000):
  duration=0
  for t in range(stories_to_simulate):
    duration+=random.choice(story_duration_dataset)
  simulations.append(duration)

simulations.sort()

print(f"Simulation results for delivery of #{stories_to_simulate} stories")
print("Shortest simulated duration: "+str(round(simulations[0],1))+" days")
for confidence in confidences:
  print(f"#{confidence} percent duration: "+ str(round(simulations[int(len(simulations)*(confidence/100))],1))+" days")

print("Longest simulated duration: "+ str(round(simulations[-1],1))+" days")

# Excel file "story duration distribution generator.xlsx" generates a set of normally-distributed values based on median, standard deviation, grabbed from JIRA control chart
# Save the "Squashed LHS" column data to "story distributions.csv"
# As story duration data is fake (ie. a normal distribution produced from two Jira data points), the left hand side of the 
#  normal curve is squashed to eliminate negative values.
# 
# Generate median, sd from control chart in JIRA for desired transitions (eg. in-dev to done)
