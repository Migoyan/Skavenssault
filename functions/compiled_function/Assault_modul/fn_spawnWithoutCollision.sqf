/*
Function spawning AI vehicules with Lucy functions without collisions. Script cannot works without GDC_Lucy (You can replace with your own function of spawn).

Parameters :
 - "_markers", list of markers. Default value : empty array, expected : array.
 - "_param_to_lucy", list of the parameters of GDC_fnc_lucySpawnVehicle function (use the same order). Default value : empty array, expected : array.
 - "_safe_zone", radius of the safe zone around the spawn waypoint where the funciton check for other vehicle. Default value : 10, expected : number.

return :
 - array : 0 unit group, 1 vehicle. Empty if parameters are not defined

author : Migoyan

Note : GDC_fnc_lucySpawnVehicle eat [position, side, "classname", crew, orientation], reduce the array to [side, "classname", crew, orientation] for this fucntion to work.
	- i'm not using waitUntil method in case the spawn points is blocked forever.
*/

// Internal variables
private ["_veh", "_marker", "_occupied", "_params_correctly_defined"];

// Params
_params_correctly_defined = params[
	["_markers", [], [[]]],
	["_param_to_lucy", [], [[]]],
	['_safe_zone', 10, [0]]
];

// Default parameters are not accepted
if (!_params_correctly_defined) exitWith {diag_log "parameters non defined"};

// Choose a marker and test if there is already a vehicule within 10m of range of the marker position.
_occupied = true;
while {_occupied}
do{
	_marker = selectRandom _markers;
	if (nearestObjects [getMarkerPos _marker, ["AllVehicles"], _safe_zone] isEqualTo [])
	then{
		_occupied = false;
	};
};

_param_to_lucy = [getMarkerPos _marker] + _param_to_lucy;

_veh = _param_to_lucy call GDC_fnc_lucySpawnVehicle;

_veh