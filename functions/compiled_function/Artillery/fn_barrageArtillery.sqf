/**
 * @name barrageArtillery
 * Function that do a rolled barrage on a rectangular marker or a simple bombardment on an icon marker.
 * 
 * @param {string} [_marker = ""] - rectangular to be used
 * @param {number} [_artillery = 0] - number of rounds fired per slavo
 * @param {string} [_round = ""] - classnames of the round to fire
 * @param {number} [_number_slavo = 0] - number of shot by piece of artillery
 * @param {number[]} [_dispersion = [50, 0]] - Dispersion on x and y axis in the marker referencial
 * @param {number} [_time_slavo = 5] - time between each slavo
 * @param {number} [_time_shot = 0.3] - time between each shot
 * @returns true when complete (Doesn't mean that function was successful)
 *
 * @author : Migoyan
 * Note : Shots can land outside of the marker area, this is due to the precision skill of the AI and with ACE, many other factors.
 * Important note : This function is designed to work with a decent amount of shots per vehicles relative to the size of the area, if you have too few shots you will have
 *		interesting results. Puts ```this addEventHandler ["Fired",{(_this select 0) setVehicleAmmo 1}];``` in the vehicle unit to have infinite ammo.
 */
params [
    ["_marker", "", [""]],
    ["_nb_rouds", 0, [0]],
    ["_round", "", [""]],
    ["_number_slavo", 0, [0]],
    ["_dispersion", [50, 0], [[0, 0]]],
    ["_side", east, [east]],
    ["_time_slavo", 5, [5]],
    ["_time_shot", 0.3, [0]]
];

if(_number_slavo == 0) exitwith {diag_log ("fn_barrageArtilleryVeh, 0 slavo to fire"); true};

private["_marker_pos", "_marker_size", "_marker_dir", "_dispersion_x", "_dispersion_y", "_veh", "_group", "_unit"];
_marker_pos = getMarkerPos _marker;
_marker_size = MarkerSize _marker;
_marker_dir = -(markerDir _marker);    // Trigonometric direction rotate anticlockwise
_dispersion_x = _dispersion#0;
_dispersion_y = _dispersion#1;

switch (_side) do {
    case west: { _veh = "B_MBT_01_arty_F" createVehicle [0,0,0]; };
    case east: { _veh = "O_MBT_02_arty_F" createVehicle [0,0,0]; };
    case independent: { _veh = "I_Truck_02_MRL_F" createVehicle [0,0,0]; };
    default { _veh = "O_MBT_02_arty_F" createVehicle [0,0,0]; };
};
_group = createVehicleCrew _veh;
_unit = gunner _veh;
hideObjectGlobal _veh;
_veh enableSimulationGlobal false;
{
    // Current result is saved in variable _x
    hideObjectGlobal _x;
    _x enableSimulationGlobal false;
} forEach crew _veh;

switch (markerShape _marker) do {
    case "ICON": {
        for "_i" from 1 to _number_slavo do {
            [_marker_pos, _round] spawn skst_fnc_fireArtiRound;
        };
    };
    case "RECTANGLE": {
        private _alphas_coeff = [];
        for [{private _i = 0}, {_i < _number_slavo}, {_i = _i + 1}] do {
            private _number = (_i)*2 / (_number_slavo - 1);
            _alphas_coeff pushBack _number;
        };
        
        {
            for [{private _i = 0}, {_i < _nb_rouds}, {_i = _i + 1}] do {
                private _alpha = (_x - 1) * _marker_size#0 + (random _dispersion_x - _dispersion_x / 2);
                private _beta = (random 2 - 1) * _marker_size#1 + (random _dispersion_y - _dispersion_y / 2);
                private _x_pos = _marker_pos#0 + _alpha*cos(_marker_dir) - _beta*sin(_marker_dir);
                private _y_pos = _marker_pos#1 + _alpha*sin(_marker_dir) + _beta*cos(_marker_dir);
                private _pos = [_x_pos, _y_pos, 0];
                private _shell = [_pos, _round] call skst_fnc_fireArtiRound;
                _shell setShotParents [_veh, _unit];
                sleep _time_shot;
            };
            sleep _time_slavo;
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