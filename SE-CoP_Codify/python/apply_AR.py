import csv
from mlxtend.preprocessing import TransactionEncoder
from mlxtend.frequent_patterns import apriori
import pandas as pd

def read_csv_file():
    data = []
    with open('Data/Shopping_data.csv', 'r') as file:
        reader = csv.reader(file)
        for row in reader:
            data.append(row)
    return data

def apply_association_rules():
    data = read_csv_file()
    te = TransactionEncoder()
    te_ary = te.fit(data).transform(data)
    df = pd.DataFrame(te_ary, columns=te.columns_)
    frequent_itemsets = apriori(df, min_support=0.01, use_colnames=True)
    print(frequent_itemsets)

apply_association_rules()
