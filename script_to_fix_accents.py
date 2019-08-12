#!/usr/bin/env python
# coding: utf-8

from os import makedirs
from os.path import exists

import pandas as pd
import geopandas as gpd


DIR_ORIGINAL_SHP = "streets_pilot_area/streets_pilot_area.shp"

FOLDER_TO_SAVE_SHP = "streets_pilot_area_new"
FILE_TO_SAVE_SHP = "streets_pilot_area.shp"


# read file
shapefile = gpd.read_file(DIR_ORIGINAL_SHP)

# shapefile['name'] = shapefile['name'].astype(str)
# shapefile['type'] = shapefile['type'].astype(str)

shapefile.loc[shapefile['name'].isnull(), 'name'] = ""
shapefile.loc[shapefile['type'].isnull(), 'type'] = ""
# print(shapefile.name.apply(lambda x: len(x)).min())

print(shapefile[shapefile.fid==142].name)
shapefile['new_name'] = shapefile['name']

# print(shapefile[shapefile['name'].str.startswith(shapefile['type'])].shape)

lista = []

for k, linha in shapefile.iterrows():
    if not linha['name'].startswith(linha['type']):
        lista.append(linha['fid'])

shapefile.loc[shapefile['fid'].isin(lista), 'new_name'] = shapefile['type'] + ' '+shapefile['name']
shapefile['name'] = shapefile['new_name']
del shapefile['new_name']
print(shapefile[shapefile.fid==142].name)



acronyms = [
    {"old": " dr. ", "new": " doutor "},
    {"old": "dr ", "new": "doutor "},
    {"old": " d. ", "new": " dom "},
    {"old": " cap. ", "new": " capitão "},
    {"old": " av. ", "new": " avenida "},
    {"old": "vila villa ", "new": "villa "}
]

def fix_acronyms(cell):
    # remove acronyms and add the long word instead

    for acronym in acronyms:
        cell = cell.replace(acronym["old"], acronym["new"])

    return cell
        


shapefile['name'] = shapefile.name.apply(fix_acronyms)
# print(shapefile.loc[shapefile['name'].str.startswith("shapefile['type']"), 'name'].shape)
# = shapefile['type'] + ' ' + shapefile['name']

#shapefile['name'] = shapefile['type'] + ' ' + shapefile['name']
saida = FOLDER_TO_SAVE_SHP + "/" + FILE_TO_SAVE_SHP
print(saida)
shapefile.to_file(saida)
exit('teste')


# print("shape.shape: ", shape.shape)

# shape.plot()

# print("shape.crs: ", shape.crs)


# print("shape.head(15): \n", shape.head(15))


# this function is not needed anymore, because when I save the Shapefile using geopandas, the accents are fixed
# def fix_accents(attribute):
#     if attribute is None:
#         return ""

#     return attribute.encode('latin-1').decode('raw_unicode_escape').encode('latin-1').decode('utf-8')

# shape['name'] = shape.name.apply(fix_accents)



# shape_copy = shape.copy()

for index, row in shapefile.iterrows():
    # if there is some None attribute, then add an empty string instead
    if row['name'] is None or row['type'] is None:
        if row['name'] is None:
            shapefile.at[index, 'name'] = ""
        if row['type'] is None:
            shapefile.at[index, 'type'] = ""
        continue

    # if "seguro porto" in row['name']:
    #     print("\nrow['type']: ", row['type'])
    #     print("row['name']: ", row['name'])

    # if name does not start with its type, then add it as prefix
    if not row['name'].startswith(row['type']):
        new_name = row['type'] + " " + row['name']
        # shapefile.at[index, 'name'] = new_name

        shapefile.set_value(index, 'name', new_name)

        # if "seguro porto" in row['name']:
        #     print("row['type']: ", row['type'])
        #     print("row['name']: ", row['name'])
        #     print("new_name: ", new_name)
    
    # fix possible acronyms
    shapefile.at[index, 'name'] = fix_acronyms(row['name'])

    # print(row['type'], row['name'])












# print("shape.head(15): \n", shape.head(15))

# remove unnecessary attributes
if 'id_type' in shapefile:
    del shapefile['id_type']

# if 'type' in shape:
#     del shape['type']

if 'perimeter' in shapefile:
    del shapefile['perimeter']


# verify it the folder exists, if it does not exist, then make it
if not exists(FOLDER_TO_SAVE_SHP):
    makedirs(FOLDER_TO_SAVE_SHP)

# save result in a file
shapefile.to_file(FOLDER_TO_SAVE_SHP + "/" + FILE_TO_SAVE_SHP)
