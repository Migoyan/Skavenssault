/**
 *Function initialize global variable for Skavenssault
 *Parameters :
 *@params "_markers", list of markers. Default value : empty array, expected : array.
 *@params "_param_to_lucy", list of the parameters of GDC_fnc_lucySpawnVehicle function (use the same order). Default value : empty array, expected : array.
 *
 *return :
 * - array : 0 unit group, 1 vehicle. Empty if parameters are not defined
 *
 *author : Migoyan
 *
 *Note : GDC_fnc_lucySpawnVehicle eat [position, side, "classname", crew, orientation], put what you want in the argument position but put something, the function will replace it.
 *	- i'm not using waitUntil method in case the spawn points is blocked forever.
 */
params [
	[ "_side", EAST, [EAST] ],
	[ "_mkr_assault ", ["", 0], [["", 0]] ],
	[ "_mkr_spawn", [], [[[""]]]],
	[ "_mkr_disembark", [], [[""]] ],
	[ "_template_troops", [[], [], [], []], [[[]]] ],
	[ "_list_veh", [[], [], [], []], [[[]]] ]
];

skst_side = _side;
skst_assault_zone = _mkr_assault;
skst_mkr_disembark = _mkr_disembark;

skst_mkr_spawn = createHashMapFromArray [
	["footed_spawn", _mkr_spawn#0],
	["vehicle_spawn", _mkr_spawn#1],
	["heli_spawn", _mkr_spawn#2],
	["plane_spawn", _mkr_spawn#3]
];

skst_templates = createHashMapFromArray [
	["infantry", _template_troops#0],
	["crew", _template_troops#1],
	["helicrew", _template_troops#2],
	["aircrew", _template_troops#3]
];

skst_list_vehicule = createHashMapFromArray [
	["veh_transport", _list_veh#0],
	["veh_armor", _list_veh#1],
	["veh_heli", _list_veh#2],
	["veh_air", _list_veh#3]
];


diag_log "Skavenssault initialisated";

true