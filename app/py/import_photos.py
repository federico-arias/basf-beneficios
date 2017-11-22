import pandas as pd 
import os
from os import walk

root_folder = '/home/federico/BASF/FOTOS'
dest_folder = '/home/federico/fotillas'
col_df = pd.read_csv('/home/federico/basf-dev/app/py/colaboradores.csv')

def normalize_name(dirname):
    persona = dirname.split(" ")
    if len(persona) > 2:
        return persona[0] + persona[2]
    else:
        return dirname

def get_rut_from_name(dirname):
    name = normalize_name(dirname)
    #modify df column to match format
    col_df["nombre"] = col_df["NOMBRE COMPLETO TRABAJADOR"].apply( lambda x: x.split(" ")[2] + " " + x.split(" ")[0])
    #lookup rut in dataframe
    if len(col_df.loc[col_df.nombre == name]) != 0:
        return col_df.loc[col_df.nombre == name].RUT.to_string(index = False, header=False)

def get_photo_filename(dirname):
    fqfn = [os.path.join(dirname, f) for f in os.listdir(dirname)]
    for x in fqfn:
        if x.endswith(".jpg") or x.endswith(".JPG") and not os.path.basename(x).startswith("."):
            return x
        elif os.path.isdir(x):
            return get_photo_filename(x)

folders = [os.path.join(root_folder, f) for f in os.listdir(root_folder)]
for colaborador in folders:
    if os.path.isdir(colaborador):
        rut = get_rut_from_name(os.path.basename(colaborador))
        filename = get_photo_filename(colaborador)
        out = rut if rut is not None else filename if filename else colaborador
        print(out)
        if filename and rut is not None:
            fullpath = os.path.join(colaborador, filename)
            os.rename(fullpath, os.path.join(dest_folder, rut +  '.jpg'))


