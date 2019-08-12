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
shape = gpd.read_file(DIR_ORIGINAL_SHP)

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


acronyms = [
    {"old": " dr. ", "new": " doutor "},
    {"old": " dr ", "new": " doutor "},
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
        

for index, row in shape.iterrows():
    # if there is some None attribute, then add an empty string instead
    if row['name'] is None or row['type'] is None:
        if row['name'] is None:
            shape.at[index, 'name'] = ""
        if row['type'] is None:
            shape.at[index, 'type'] = ""
        continue

    # if name does not start with its type, then add it as prefix
    if not row['name'].startswith(row['type']):
        shape.at[index, 'name'] = row['type'] + " " + row['name']
    
    # fix possible acronyms
    shape.at[index, 'name'] = fix_acronyms(row['name'])

    # print(row['type'], row['name'])


# print("shape.head(15): \n", shape.head(15))

# remove unnecessary attributes
if 'id_type' in shape:
    del shape['id_type']

if 'type' in shape:
    del shape['type']

if 'perimeter' in shape:
    del shape['perimeter']


# verify it the folder exists, if it does not exist, then make it
if not exists(FOLDER_TO_SAVE_SHP):
    makedirs(FOLDER_TO_SAVE_SHP)

# save result in a file
shape.to_file(FOLDER_TO_SAVE_SHP + "/" + FILE_TO_SAVE_SHP)
