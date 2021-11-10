/**
 * @name patrolMarker
 * Function that create a patrol in an marker area using fn_positionInMarker.
 * 
 * @param _group, group that will do the patrol.
 * @param _marker, Default value : empty string, expected : string.
 * @param _nb_waypoint, number of waypoints, Default : 4, expected : number.
 * @param _waiting_time, waiting time at each waypoint, Default : [0,0,0], expected : [min number, mid number, max number].
 * @param _behaviour, behaviour of the patrol group, Default : "SAFE", expected : string ("CARELESS", "SAFE", "AWARE", "COMBAT", "STEALTH")
 *
 * @returns true when function is completed.
 *
 * author : Migoyan
 */
params [
	"_group",
	["_marker", "", [""]],
	["_nb_waypoint", 4, [0]],
	["_waiting_time", [0,0,0], [[0,0,0]]],
	["_behaviour", "SAFE", [""]]
];

if (!local this) exitWith {};

private "_position";
private "_waypoint";

// init

_group setBehaviour _behaviour;

for [{private _i = 0}, {_i < (_nb_waypoint - 1)}, {_i = _i + 1}] do {
	_position = [_marker] call skst_fnc_positionInMarker;
	_waypoint = _group addWaypoint [_position, 0];
	_waypoint setWaypointTimeout _waiting_time;
};

_position = [_marker] call skst_fnc_positionInMarker;
_waypoint = _group addWaypoint [_position, 0];
_waypoint setWaypointTimeout _waiting_time;
_waypoint setWaypointType "CYCLE";

true