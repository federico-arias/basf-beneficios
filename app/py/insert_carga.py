import pandas as pd
import numpy as np

carga_df = pd.read_csv("/home/federico/carga.csv")
nonna = carga_df[pd.notnull(carga_df["Nombre Hijo"])]
nonna.to_csv('/home/federico/cols.csv', index = False, header = False)


