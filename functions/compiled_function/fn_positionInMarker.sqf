/**
	* @name positionInMarker
	* Function that returns a position in a marker area
	* 
	* @param _marker Default value : empty string, expected : string.
	*
	* @returns array with position ASL
	*
	* author : Migoyan
	* Note : Parameterized radius ellipse equation in polar coordinates (r, theta) r^2(theta) = b² / (1 - e² cos²(theta)) 
	* with exentricity e² = 1 - (b/a)².
	* with a semi-major axis and b semi-minor axis 
*/

params [["_marker", [""], [""]]];

private["_marker_pos", "_marker_size", "_marker_dir","_position_returned", "_x_pos", "_y_pos"];

_marker_pos = getMarkerPos _marker;
_marker_size = MarkerSize _marker;
_marker_dir = -(markerDir _marker);    // Trigonometric direction rotate anticlockwise

switch (markerShape _marker) do {
	case "ICON": {
		_position_returned = _marker_pos;
	};
	case "RECTANGLE": {
		private _alpha = (random 2 - 1) * _marker_size#0;
		private _beta = (random 2 - 1) * _marker_size#1;
		_x_pos = _marker_pos#0 + _alpha*cos(_marker_dir) - _beta*sin(_marker_dir);
		_y_pos = _marker_pos#1 + _alpha*sin(_marker_dir) + _beta*cos(_marker_dir);
		_position_returned = [_x_pos, _y_pos, getTerrainHeightASL[_x_pos, _y_pos]];
	};
	case "ELLIPSE": {
		private "_radius";
		private "_e_square";
		private _alpha = sqrt(random 1);
		private _beta = random 360;
		_e_square = 1 - (_marker_size#1 / _marker_size#0)^2;
		_radius = sqrt((_marker_size#1)^2 / (1 - _e_square * (cos (_beta))^2));
		
		_position_returned = _marker_pos getPos [_radius * _alpha, -(_beta + _marker_dir - 90)]
	};
	default "ERROR": {
		if(true) exitwith {diag_log (str(_marker) + " : marker not existing")}
	};
};

_position_returned