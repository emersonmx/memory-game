extends Node2D

func shuffle_array(list):
	var shuffled_list = []
	var index_list = range(list.size())
	for i in range(list.size()):
		var x = randi() % index_list.size()
		shuffled_list.append(list[index_list[x]])
		index_list.remove(x)
	return shuffled_list