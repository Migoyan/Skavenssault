/** Function that hide markers based on a keyword
 *@params _keyword : key word searched in the marker name to hide
 */
params ["_keyword", "mkr", [""]];

{
    if (_keyword in _x)
    then{_x setMarkerAlpha 0};
} forEach allMapMarkers;