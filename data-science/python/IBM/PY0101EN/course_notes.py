'''
Author: Alex Migit
Subject: Expressions and Variables
'''

total_min = 43 + 42

total_hr = total_min / 60

total_hr # Print total hours

'''
Subject: String Operations
'''

import re

s1 = "The Bodyguard is the best album."

# Define the pattern to search for
pattern = r"Body"

# Use search function to search for the pattern in the string
result = re.search(pattern, s1)

# Check if a match was found
if result:
    print("Match found!")
else:
    print("A match was not found...")

# A simple example of using the \d special sequence in 
# a regular expression pattern with Python code
pattern = r"\d\d\d\d\d\d\d\d\d\d"  # Matches any ten consecutive digits
text = "My Phone number is 1234567890"
match = re.search(pattern, text)

if match:
    print("Phone number found:", match.group())
else:
    print("No match")







