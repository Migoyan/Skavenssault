/**
 * @name barrageArtillery
 * Function that do a rolled barrage on a rectangular marker or a simple bombardment on an icon marker.
 * 
 * @param {string} [_marker = ""] - rectangular to be used
 * @param {array} [_artillery = []] - array of artillery pieces
 * @param {string} [_round = ""] - classnames of the round to fire
 * @param {number} [_shoot_number = 0] -_shoot_number, number of shot by îece of artillery, Default value : 0, expected : number
 * @returns true when complete (Doesn't mean that function was successful)
 *
 * @author : Migoyan
 * Note : Shots can land outside of the marker area, this is due to the precision skill of the AI and with ACE, many other factors.
 * Important note : This function is designed to work with a decent amount of shots per vehicles relative to the size of the area, if you have too few shots you will have
 *		interesting results. Puts ```this addEventHandler ["Fired",{(_this select 0) setVehicleAmmo 1}];``` in the vehicle unit to have infinite ammo.
 */
params [
    ["_marker", "", [""]],
    ["_artillery", [], [[]]],
    ["_round", "", [""]],
    ["_shoot_number", 0, [0]]
];

if(_shoot_number == 0) exitwith {diag_log ("fn_barrageArtillery, 0 shot to fire"); true};

private["_marker_pos", "_marker_size", "_marker_dir"];
_marker_pos = getMarkerPos _marker;
_marker_size = MarkerSize _marker;
_marker_dir = -(markerDir _marker);    // Trigonometric direction rotate anticlockwise

// Initialising attached variable to each artillery piece
{
    // Current result is saved in variable _x
    _x setVariable ["round_fired", false];
    _x addEventHandler["Fired", {_this#0 setVariable ["round_fired", true];}];
} forEach _artillery;

switch (markerShape _marker) do {
    case "ICON": {
        for "_i" from 1 to _shoot_number do {
            {
                // Current result is saved in variable _x
                _x doArtilleryFire [_marker_pos, _round, _shoot_number];
            } forEach _artillery;
        };
    };
    case "RECTANGLE": {
        private _alphas_coeff = [];
        for [{private _i = 0}, {_i < _shoot_number}, {_i = _i + 1}] do {
            private _number = (_i)*2 / (_shoot_number - 1);
            _alphas_coeff pushBack _number;
        };
        
        {
            private _y = _x;
            private _slavo_not_completed = true;
            // ordering each artillery piece to shot
            {
                // Current result is saved in variable _x
                private _alpha = (_y - 1) * _marker_size#0;
                private _beta = (random 2 - 1) * _marker_size#1;
                private _x_pos = _marker_pos#0 + _alpha*cos(_marker_dir) - _beta*sin(_marker_dir);
                private _y_pos = _marker_pos#1 + _alpha*sin(_marker_dir) + _beta*cos(_marker_dir);
                private _pos = [_x_pos, _y_pos, 0];
                _x doArtilleryFire [_pos, _round, 1];
            } forEach _artillery;

            sleep 3;
            // Wait until all artillery have completed their shot
            while {_slavo_not_completed} do {
                _slavo_not_completed = false;
                sleep 0.5;
                {
                    // Current result is saved in variable _x
                    if (!(_x getVariable "round_fired")) exitWith {
                        _slavo_not_completed = true;
                    };
                } forEach _artillery;
            };

            // Reinitialising variable for next salvo
            {
                // Current result is saved in variable _x
                _x setVariable ["round_fired", false];
            } forEach _artillery;
        } forEach _alphas_coeff;
    };
    case "ELLIPSE": {
        if(true) exitwith {diag_log ("fn_barrageArtillery, not intended to work with ellipse/hexagon"); true}
    };
    default "ERROR": {
        if(true) exitwith {diag_log ("fn_barrageArtillery, " + str(_marker) + " : marker not existing"); true}
    };
};

true