extends AudioStreamPlayer

var sfx_volume   : float  = -10.0;
var music_volume : float  = -10.0;
var position     : float  =   0.0;

func _ready() -> void:
	volume_db = music_volume;

func set_music(audio : AudioStream):
	position = 0;
	stream = audio;

func set_volume(vol : float):
	music_volume = vol;
	if music_volume == -40.0:
		volume_db = -80;

func play_music():
	volume_db = music_volume;
	play();

func pause_music():
	if playing:
		position = get_playback_position();
		play();

func fade_out(fadeTime : float, dec : float = -20.0):
	var tw = create_tween();
	tw.tween_property(self, "volume_db", music_volume + dec, fadeTime);
	
	await tw.finished;
	tw.kill();

func fade_in(fadeTime : float):
	var tw = create_tween();
	tw.tween_property(self, "volume_db", music_volume, fadeTime);
	
	await tw.finished;
	tw.kill();

func fade_out_and_in(fadeOut : float, hold : float, fadeIn : float, dec = -20.0):
	var tw = create_tween();
	
	tw.tween_property(self, "volume_db", music_volume + dec, fadeOut);
	tw.tween_interval(hold)
	tw.tween_property(self, "volume_db", music_volume, fadeIn);
	
	await tw.finished;
	tw.kill();
