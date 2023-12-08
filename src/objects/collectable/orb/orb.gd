extends Node2D

func _on_collect(body : Node2D):
	GlobalInfo.increase_score(100);
	
func _on_entered(body):
	queue_free();
