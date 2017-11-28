import pandas as pd

bs = pd.read_csv('/home/federico/basf-dev/app/py/beneficios.csv')
df = pd.DataFrame()

for row, (k,v) in enumerate(bs.groupby(["Categoría"])):
    df = df.append(v.drop_duplicates("Subcategoría"))

cols_to_del = [x for x in df.columns if x != 'Categoría' and x != 'Subcategoría']
df = df.drop(cols_to_del, 1)

df.to_csv('/home/federico/subcat_gen.csv', index = False, header = False)

bs = pd.read_csv('/home/federico/basf-dev/app/py/beneficios.csv')

si_cols = [x for x in bs.columns if x in ["Tiene proceso de aprobación", "Es relevante medir uso", "Es relevante medir tiempo respuesta", "Incluye monto"]]

def si_a_true(df, cols):
    for col in cols:
        df[col] = df[col].apply(lambda x:x.strip() == "Sí")
    return df

bs = si_a_true(bs, si_cols)

bs['PLAZOS (tipo de contrato) PARA PERU ES TODOS "AMBOS"'] = bs['PLAZOS (tipo de contrato) PARA PERU ES TODOS "AMBOS"'].apply( lambda x: x.strip() == 'Indefinido')
bs["Modalidad de solicitud"] = bs["Modalidad de solicitud"].apply(lambda x: x.strip() == "Individual")
