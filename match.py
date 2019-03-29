# Match universities names from two lists
# 

from sas7bdat import SAS7BDAT
import csv
import re
from company_name_similarity import CompanyNameSimilarity
from progressbar import progressbar

FILE_1 = 'qs2019.sas7bdat'
FILE_2 = 'arwu2018.sas7bdat'
col1 = 2
col2 = 1
id1 = -1
id2 = -1
outfile = 'qs_arwu.csv'


# get two name lists

data1, data2 = [], []

with SAS7BDAT(FILE_1) as f:
	data1 = [row for row in f][1:]

with SAS7BDAT(FILE_2) as f:
	data2 = [row for row in f][1:]


def preprocess(name1, name2):
	name1 = re.sub(r'\(.*?\)', '', name1)
	name2 = re.sub(r'\(.*?\)', '', name2)
	return name1, name2


# match tow lists
# fn is the matching mathod
# base is to generalize the similarity
def match_by(fn, preprocess=None, base=1):
	# rows = []
	with open(outfile, 'w', newline='') as csvfile:
		writer = csv.writer(csvfile)
		writer.writerow(['name1', 'id1', 'name2', 'id2', 'similarity'])
		for obs1 in progressbar(data1):
			name1 = obs1[col1]
			score = 0
			# print(name1, name2, score)
			for obs2 in data2:
				name2 = obs2[col2]
				if preprocess:
					name1, name2 = preprocess(name1, name2)
				new_score = fn(name1, name2)
				if new_score > score:
					score = new_score
					match_name = name2
					match_id = obs2[id2]
			row = [name1, obs1[id1], match_name, match_id, score/base]
			# print(row)
			# rows.append(row)
			writer.writerow(row)
			# break


if __name__ == "__main__":
	cm = CompanyNameSimilarity()
	match_by(cm.match_score, preprocess)
