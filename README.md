# jiraprojectsim
Ruby script and spreadsheet to do Monte Carlo project simulations for delivery prediction

#Instructions
1) Look at your control chart in Jira, get the rolling average/mean and standard deviation for cycle team between the two states you're interested in (eg. In dev -> Done).
2) Open the Story duration distribution generator.xlsx file and input your values for Mean and standard deviation
3) Save the values in the 'squashed LHS' spreadsheet column to a file named 'story distributions.csv'
4) Run the ruby script with the desired confidence level and the number of stories in your backlog you want a prediction for

The script should output a duration with an associated probability. 
