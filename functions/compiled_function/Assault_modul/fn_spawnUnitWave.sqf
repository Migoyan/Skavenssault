/**
 * Script a waves of units with Lucy functions without collisions. Script cannot works without GDC_Lucy (You can replace with your own function of spawn) and spawnWithoutCollision function.
 * Work only in skst environment.
 *
 * @param _wave : array of 5 differents value, 0 : number of footed infantery ; 1 : number of motorized infantery ; 2 : number of armored vehicule ; 3 : number of heli ; 4 : number of planes.
 * @param _proba_transport : probability for each vehicles to be selectionned
 * @param _proba_armor : probability for each armors to be selectionned
 * @param _proba_heli : probability for each helis to be selectionned
 * @param _proba_plane : probability for each planes to be selectionned
 * @param _waiting_time : waiting time before the wave start
 * @returns bool : true if script is executed to the end, doesn't guarentee complete success of execution.
 *
 * author : Migoyan
 */
params[
	["_wave", [0, 0, 0, 0, 0], [[0]], [5]],
	["_proba_transport", [1], [[0]]],
	["_proba_armor", [1], [[0]]],
	["_proba_heli", [1], [[0]]],
	["_proba_plane", [1], [[0]]],
	["_waiting_time", 0, [0]]
];

//  init
private ["_nb_inf", "_nb_mot", "_nb_armored", "_nb_heli", "_nb_plane"];

_nb_inf = _wave#0;
_nb_mot = _wave#1;
_nb_armored = _wave#2;
_nb_heli = _wave#3;
_nb_plane = _wave#4;

uiSleep _waiting_time;

// Spawn part
if (_nb_inf > 0)
then{
	private _markers = skst_mkr_spawn get "footed_spawn";
	private _templates = skst_templates get "infantry";

	for "_i" from 1 to _nb_inf
	do{
		private _group_inf = [getMarkerPos (selectRandom _markers)#0, skst_side, selectRandom _templates] call GDC_fnc_lucySpawnGroupInf;

		_group_inf setBehaviour "COMBAT";
		_group_inf addWaypoint [getMarkerPos(skst_assault_zone#0), skst_assault_zone#1];
	};
};

if (_nb_mot > 0)
then{
	private _markers = skst_mkr_spawn get "vehicle_spawn";
	private _templates = skst_templates get "infantry";
	private _vehicles = skst_list_vehicule get "veh_transport";

	for "_i" from 1 to _nb_mot
	do{
		private _vehicle = _vehicles selectRandomWeighted _proba_transport;
		private _group_mot = [
			_markers,
			[skst_side, _vehicle#0, selectRandom _templates, 0]
		] call skst_fnc_spawnWithoutCollision;

		if (_vehicle#1)
		then{
			private _disembark = [skst_mkr_disembark, leader(_group_mot#0)] call skst_fnc_findNearestDisembark;
			((_group_mot#0) addWaypoint [getMarkerPos _disembark, 30]) setWaypointType "GETOUT";
		};

		(_group_mot#0) setBehaviour "COMBAT";
		(_group_mot#0) addWaypoint [getMarkerPos(skst_assault_zone#0), skst_assault_zone#1];
	};
};

if (_nb_armored > 0)
then{
	private _markers = skst_mkr_spawn get "vehicle_spawn";
	private _template = skst_templates get "crew";
	private _armors = skst_list_vehicule get "veh_armor";
	for "_i" from 1 to _nb_armored
	do{
		private _armor = _armors selectRandomWeighted _proba_armor;
		private _group_armor = [
			_markers,
			[skst_side, _armor, _template, 0]
		] call skst_fnc_spawnWithoutCollision;

		(_group_armor#0) setBehaviour "COMBAT";
		(_group_armor#0) addWaypoint [getMarkerPos(skst_assault_zone#0), skst_assault_zone#1];
	};
};

if (_nb_heli > 0)
then{
	private _markers = skst_mkr_spawn get "heli_spawn";
	private _template = skst_templates get "helicrew";
	private _helis = skst_list_vehicule get "veh_heli";
	for "_i" from 1 to _nb_heli
	do{
		private _heli = _helis selectRandomWeighted _proba_heli;
		private _group_heli = [
			_markers,
			[skst_side, _heli, _template, 0]
		] call skst_fnc_spawnWithoutCollision;

		[_group_heli#0, skst_assault_zone#0, skst_assault_zone#1, false] call CBA_fnc_taskAttack;
	};
};

if (_nb_plane > 0)
then{
	private _markers = skst_mkr_spawn get "plane_spawn";
	private _template = skst_templates get "aircrew";
	private _planes = skst_list_vehicule get "veh_air";
	for "_i" from 1 to _nb_plane
	do{
		private _plane = _planes selectRandomWeighted _proba_plane;
		private _group_plane = [
			_markers,
			[skst_side, _plane, _template, 0]
		] call skst_fnc_spawnWithoutCollision;

		[_group_plane#0, skst_assault_zone#0, skst_assault_zone#1, false] call CBA_fnc_taskAttack;
	};
};

true