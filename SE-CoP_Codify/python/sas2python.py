import csv

# 1. read the shopping_data.csv file from Data folder
with open('Data/shopping_data.csv', 'r') as file:
    reader = csv.reader(file)
    header = next(reader)
    data = [row for row in reader]

# 2. create a new csv file using the fields in shopping_data.csv file with the same data structure of 1000
with open('Data/NewFile.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(header)
    for i in range(1000):
        writer.writerow(data[i % len(data)])

