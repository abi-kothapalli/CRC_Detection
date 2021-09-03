import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats import spearmanr
import numpy as np

df = pd.read_csv("top_features.csv")

print(df.head())

corrs = df.corr(method="spearman")


coefs = []

for i in range(20):
    coef, _ = spearmanr(df.iloc[:, i], df.iloc[:, 20])
    coefs.append(coef)

corrs["class"] = coefs

coefs = []

for i in range(21):
    coef, _ = spearmanr(df.iloc[:, 20], df.iloc[:, i])
    coefs.append(coef)

corrs.loc[20] = coefs

lab = [i+1 for i in range(20)]
lab.append("Class")

sns.heatmap(corrs, xticklabels=lab, yticklabels=lab, annot=True, fmt='.2f', linewidths=0.2, linecolor='white')
plt.show()


temp = pd.read_csv("importances.csv", header = None)
importances = temp[0].to_numpy()
indices = np.argsort(importances)

plt.title('Feature Importances')
plt.barh(range(20), importances[indices], color='#015bbb', align='center')
plt.yticks(range(20), indices+1)
plt.xlabel('Relative Importance')
plt.show()

