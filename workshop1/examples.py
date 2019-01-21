
""" Variable Assignment """

# Here we set the variable named "a" to an integer value 5
a = 5

# Now let's change it to a string
a = "I'm a string now"

# And now a float value
a = 1.234

# And now a boolean value
a = True


# Here is a list of values
# They do not need to be the same types
list_of_things = [1, 2, "three", "four", 5.0]

# This will print the third element in the list ("three")
print(list_of_things[2])

# Here is a dict (a.k.a. a map)
dictionary = {
	"key_1" : 1,
	"key_2" : "value"
}

# Here is a tuple
my_tuple = (1, 2, "three")

""" Arithemetic """

a = 5
b = 10
c = a + b # Addition
c = a - b # Subtraction
c = a * b # Multiplication
c = a / b # Division
c = b % a # Modulo
c = c + 1 # Self modification


""" Arithemetic """

a = 5
b = 10
c = a + b # Addition
c = a - b # Subtraction
c = a * b # Multiplication
c = a / b # Division
c = b % a # Modulo
c = c + 1 # Self modification

things = [1, 2, 3]
other_things = [4, 5, 6]
all_the_things = things + other_things
# [1, 2, 3, 4, 5, 6]

foo = {
	"foo": "foo"
}
bar = {
	"bar": "bar"
}
foo_bar = {**foo, **bar} # Python 3.5+



""" Conditional Logic """

first_name = "Bill"
last_name = "Gates"
age = 62

# Here is the EQUALITY operator
if first_name == "Bill":
	# This will print
	print("My name is Bill")
else:
	print("My name is not Bill")


# Here is the NOT operator
# Can also be written as `last_name != "Gates"`
if not last_name == "Gates":
	print("My last name is not Gates")
else:
	# This will print
	print("My last name is Gates")


# This is the AND operator
if first_name == "Bill" and last_name == "Gates":
	# This will print
	print("My name is Bill Gates")
# This is the AND operator
if first_name == "Bill" and last_name == "Jobs":
	# This will not print
	print("My name is not Bill Gates")

# This is the OR operator
# This is a short circuit!
if first_name == "Bill" or first_name == "Jill":
	# This will print
	print("My name is either Bill or Jill")
# This is the OR operator
if first_name == "Steven ‘The Apple Man’" or last_name == "Jobs":
	# This will not print
	print("None of this is true")


# Here is less than and greater than
if age < 70 and age > 59:
	# This will print
	print("I am in my 60s")

# Here is less or equal to and greater than or equal to
if age <= 69 and age >= 60:
	# This will print
	print("Once again, I am in my 60s")



""" Loops """

my_number = -1

while True:
	my_number += 1

	if my_number % 2 == 0:
		print(my_number)

	if my_number > 99:
		break

# Here we print the digits 0-9 using a range
for i in range(0, 10):
	print(i)

# Here we iterate over a list and print each value
my_list = [1, 2, 3, 4, 5]
for value in my_list:
	print(value)

# Here we iterate over the keys in a dict and
# print the associated values
my_dict = {
	"key_1": 1,
	"key_2": 2
}
for key in my_dict:
	print(my_dict[key])



""" Functions """


"""
Mathy looking function:
	f(x) = x + 1
"""

# Python version
def f(x):
	return x + 1

def evens(lower_limit, upper_limit):
	# Create an empty list
	even_numbers = []

	# Iterate over the given range
	for x in range(lower_limit, upper_limit):
		if x % 2 == 0:
			# If the number is even, add it to the list
			even_numbers.append(x)

	# The return keyword indicates what the function should
	# send back to its caller
	return even_numbers

# Call the function
result = evens(0, 10)

# Prints [0, 2, 4, 6, 8]
print(result)



""" List Comprehension """

def evens(lower_limit, upper_limit):
	return [x for x in range(lower_limit, upper_limit) if x % 2 == 0]


result = evens(0, 10)
print(result)



""" Files """

# Text file
with open("./hello.txt") as fin:
	contents = fin.read()
	print(contents)


# JSON file
import json
with open("./hello.json") as fin:
    content = json.loads(fin.read())
    print(content["hello"])


# CSV file
import csv, json
with open("./hello.csv") as fin:
	reader = csv.reader(fin)
	data = []
	headers = reader.__next__()
	for row in reader:
		record = {}
		for i, header in enumerate(headers):
			record[header] = row[i]
		
		data.append(record)

	print(json.dumps(data))


# Pandas CSV

import pandas

data = pandas.read_csv("./hello.csv")

print(data)


""" The Internet """

import requests

response = requests.get("https://en.wikipedia.org/wiki/Python_(programming_language)")
response.raise_for_status()
print(response.text)



CSV_URL = "https://drive.google.com/uc?export=download&id=1fHySh9SSdM-WQgkqEQpKJWLlRRMeHf-3"

response = requests.get(CSV_URL)
response.raise_for_status()
print(response.text)