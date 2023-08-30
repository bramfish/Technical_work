def test_search_algorithm_name():
    assert search_algorithm_name() == "sequential_patterns.py"
    assert search_algorithm_name() != "apriori.py"
    assert search_algorithm_name() != "fpgrowth.py"


    import pandas as pd
    from mlxtend.frequent_patterns import apriori
    from mlxtend.frequent_patterns import association_rules

    def read_shopping_data():
        df = pd.read_csv('Data/Shopping_data.csv')
        return df

    def apply_association_rules():
        df = read_shopping_data()
        frequent_itemsets = apriori(df, min_support=0.01, use_colnames=True)
        rules = association_rules(frequent_itemsets, metric="lift", min_threshold=1)
        return rules['antecedents']

