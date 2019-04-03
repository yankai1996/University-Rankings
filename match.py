# 
# Match university names from two lists
# 

from sas7bdat import SAS7BDAT
import csv
import re
from company_name_similarity import CompanyNameSimilarity
from progressbar import progressbar

FILE_1 = 'qs2019.sas7bdat'
FILE_2 = 'arwu2018.sas7bdat'
COL_1 = 2	# column of the university names
COL_2 = 1
ID_1 = -1	# column of the university ids
ID_2 = -1
FILE_OUT = 'qs_arwu.csv'		# output file name


# get two name lists

data1, data2 = [], []

with SAS7BDAT(FILE_1) as f:
	data1 = [row for row in f][1:]

with SAS7BDAT(FILE_2) as f:
	data2 = [row for row in f][1:]


# Drop the useless part in the names
def preprocess(name1, name2):
	name1 = re.sub(r'\(.*?\)', '', name1)
	name2 = re.sub(r'\(.*?\)', '', name2)
	return name1, name2


# Match tow lists
# fn: the matching mathod
# preprocess: preprocess function
# base: denominator to generalize the similarity
def match_by(fn, preprocess=None, base=1):
	# rows = []
	with open(FILE_OUT, 'w', newline='') as csvfile:
		writer = csv.writer(csvfile)
		writer.writerow(['name1', 'ID_1', 'name2', 'ID_2', 'similarity'])
		for obs1 in progressbar(data1):
			name1 = obs1[COL_1]
			score = 0
			# print(name1, name2, score)
			for obs2 in data2:
				name2 = obs2[COL_2]
				name1, name2 = preprocess(name1, name2) if preprocess else name1, name2
				new_score = fn(name1, name2)
				if new_score > score:
					score = new_score
					match_name = name2
					match_id = obs2[ID_2]
			row = [name1, obs1[ID_1], match_name, match_id, score/base]
			# print(row)
			# rows.append(row)
			writer.writerow(row)
			# break


if __name__ == "__main__":
	cm = CompanyNameSimilarity()
	match_by(cm.match_score, preprocess)
