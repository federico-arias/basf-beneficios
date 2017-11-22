import pandas as pd

df = pd.read_csv('colaboradores.csv')

#https://stackoverflow.com/questions/13148429/how-to-change-the-order-of-dataframe-columns
def order(frame,var):  
    varlist = [w for w in frame.columns if w not in var]        
    return frame[var + varlist]

# Delete
del_cols = ["ID SUCURSAL", "CENTRO TRABAJO", 'ANTIGUEDAD MESES', 'FECHA DE BAJA', 'CLAS INE', 'COD CARGO', 'EMPRESA', 'GRUPO FAMILIAR']
df = df.drop(del_cols, 1)

# Rename
names = ['sucursal', 'centro_costo', 'codigo_sap', 'run', 'colaborador', 'genero', 'estado_civil', 'nacionalidad', 'nacimiento_en', 'edad', 'direccion', 'comuna', 'ciudad', 'region', 'mail', 'telefono', 'ingreso_en', 'contrato', 'sindicalizado', 'cargo', 'supervisor']
df.columns = names

# New cols
df = df.assign(esta_casado = lambda d: d.estado_civil  == "Casado")
df = df.assign(es_hombre = lambda d: d.genero  == "M")
df = df.assign(es_indefinido = lambda d: d.contrato == "PLAZO INDEFINIDO") 
df = df.assign(esta_sindicalizado = lambda d: d.sindicalizado != "SIN SINDICATO") 

# Delete old cols
df = df.drop(['estado_civil', 'genero', 'contrato', 'sindicalizado', 'edad'], 1)

df.to_csv('/home/federico/cols.csv', index = False, header = False)

