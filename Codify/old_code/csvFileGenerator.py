import csv
import random
import os

# Define the items and their prices
items = ['Apple', 'Banana', 'Orange', 'Mango', 'Pineapple', 'Grapes', 'Watermelon', 'Peach', 'Pear', 'Kiwi']
prices = [0.99, 1.49, 1.99, 2.49, 2.99, 3.49, 3.99, 4.49, 4.99, 5.49]

# Generate the data and write it to a CSV file
if not os.path.exists('Data'):
    os.makedirs('Data')
with open('Data/Shopping_data.csv', mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Item Name', 'Price'])
    for i in range(200):
        item = random.choice(items)
        price = random.choice(prices)
        writer.writerow([item, price])
