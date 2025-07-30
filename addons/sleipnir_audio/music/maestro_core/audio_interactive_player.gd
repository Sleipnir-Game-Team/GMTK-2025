@tool
extends AudioStreamPlayer
class_name AudioInteractivePlayer

static var current_section  : String          ## em que sessão estamos?

var _section_dict : Dictionary[StringName,int]        # sessões da música mapeadas para int
var _transition_type : int                # qual transição vai rolar
var _corrected_transitions : Array              # as transições corrigidas do modo BAR de transição

func _init(song_data:SongData,change_to_default_first:bool) -> void:
	_section_dict.clear()
	_section_dict =  song_data.get_sections()\
	 if _section_dict != song_data.get_sections() else _section_dict
	
	Logger.info("Sections are: "+str(_section_dict))
	if change_to_default_first == true:
		current_section = song_data.get_first_section()          # pega qual a sessão default da música
	
	self.set_stream(song_data.get_main_clips())           # seta a stream pro _current_song_node
	
	if song_data.MainClips.get_clip_name(song_data.MainClips.initial_clip) != current_section:
		self.set("parameters/switch_to_clip",current_section)  # seta a sessão pra ela
	else:
		pass # do nothing
	self.name = song_data.resource_path.get_file().get_basename()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.volume_db = -3                 # volume pra 1
	self.pitch_scale = 1               # pitch pra 1
	self.bus = &"music"

## Muda de sessão para a música toda [br]
## [codeblock]SleipnirMaestro.switch_song_section("combat")[/codeblock]
func switch_song_section(section_name:String,offset:int=0) ->Error:
	if self.stream is not AudioStreamInteractive:
		if SleipnirMaestro.log_level<=3:
			Logger.warn("stream invalid: "+str(self.stream)+
					" Can only use this method if Main Stream is of type AudioStreamInteractive")
		return ERR_INVALID_PARAMETER

	# se quiser mudar pra sessão atual, retorna
	if current_section == section_name:
		Logger.warn("can't switch to the same section")
		return ERR_ALREADY_IN_USE
	
	# se estiver pausado ou parado, retorna
	if (self.is_playing() == false) and (self.get_stream_paused() == false):
		Logger.warn("can't switch to section when stopped or paused!")
		return ERR_UNAVAILABLE
	
	self._switch_section(section_name)
	return OK

func _switch_section(section_name : String):
	var playback : AudioStreamPlaybackInteractive = self.get_stream_playback()
	playback.switch_to_clip_by_name(section_name) # usa o default
	current_section = section_name
	
	if SleipnirMaestro.log_level <=2: 
		Logger.info(current_section+" ["+str(SleipnirMaestro._get_elapsed_time())+" s] [Bar "+
		str(SleipnirMaestro.elapsed_measures)+"| Beat "+str(SleipnirMaestro.elapsed_beats)+"] ")	
