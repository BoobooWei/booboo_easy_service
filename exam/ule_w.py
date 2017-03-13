```python
#!/usr/lib/python
# -*- coding: utf-8 -*-


names=locals()
		 
a_list=[]
with open('00','r') as f:
	for i in f.readlines()[:50]:
		a_list.append(i.strip())

file_list=[2,3,4,5,6,7,9,10,11,13,16,17,18,19,20,24,25,26,27,28,31,35,43,45,46,55,56,58]

for f_num in file_list:
	f_str='%d'%f_num
	names['b_list%s' % f_num]=[]
	with open(f_str,'r') as f:
        	for i in f.readlines()[:50]:
                	names['b_list%s' % f_num].append(i.strip())
	num = 50

	if len(names['b_list%s' % f_num]) != 50:
		print('{}没有成绩'.format(f_num))	
		continue
	for i in range(0,50):
		if names['b_list%s' % f_num][i]!=a_list[i]:
			num = num - 1
	print('{}的成绩为：{}'.format(f_str,num*2))