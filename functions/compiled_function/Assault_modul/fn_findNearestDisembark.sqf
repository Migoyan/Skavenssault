/**Return the nearest marker
 *
 * Parameters :
 * @params _markers list of markers. Default value : empty array, expected : array.
 * @params _param_to_lucy list of the parameters of GDC_fnc_lucySpawnVehicle function (use the same order). Default value : empty array, expected : array.
 *
 * @returns the marker
 *
 * author : Migoyan
 *
 */
params [
	"_mkr_disembark",
	"_object"
];

private _marker = _mkr_disembark#0;
private "_distance";
private _distance_min = _object distance2D getMarkerPos _marker;

{
	_distance = _object distance2D getMarkerPos _x;
	if (_distance < _distance_min) then {
		_distance_min = _distance;
		_marker = _x;
	};
} forEach _mkr_disembark;
_marker