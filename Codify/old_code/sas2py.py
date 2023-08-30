import pandas as pd
import numpy as np
import os


Name = ["Person " + str(i) for i in range(1, 20001)]
Age = np.random.randint(18, 66, 20000)
Education_Level = np.random.choice(["High School Diploma", "Bachelor's Degree", "Master's Degree", "PhD"], 20000)

population = pd.DataFrame({
    "Name": Name,
    "Age": Age,
    "Education_Level": Education_Level
})

population.to_csv(os.path.join("Data", "population.csv"), index=False)