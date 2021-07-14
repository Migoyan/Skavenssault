/**
 * @name barrageArtillery
 * Function that do a rolled barrage on a rectangular marker or a simple bombardment on an icon marker.
 * 
 * @param {string} [_marker = ""] - rectangular to be used
 * @param {number} [_artillery = 0] - number of rounds fired per slavo
 * @param {string} [_round = ""] - classnames of the round to fire
 * @param {number} [_number_slavo = 0] - _number_slavo, number of shot by îece of artillery, Default value : 0, expected : number
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
    ["_number_slavo", 0, [0]]
];

// function skst_fnc_fireArtyRound
fireArtyRound = {
    params[
        ["_pos", [0, 0], [[0]], [2, 3]],
        ["_round", "", [""]]
    ];

    private "_spawn_pos";
    private "_shell";
    if (count _pos > 2) then {
        _spawn_pos = +_pos;
        _spawn_pos set [2, 1000];
    } else {
        _spawn_pos = +_pos pushBack 1000;
    };

    _shell = _round createVehicle _spawn_pos;

    _shell setVectorDirandUp [[0,0,-1],[0.1,0.1,1]];
    _shell setVelocity [0,0,-100];

    true
};


if(_number_slavo == 0) exitwith {diag_log ("fn_barrageArtilleryVeh, 0 slavo to fire"); true};

private["_marker_pos", "_marker_size", "_marker_dir"];
_marker_pos = getMarkerPos _marker;
_marker_size = MarkerSize _marker;
_marker_dir = -(markerDir _marker);    // Trigonometric direction rotate anticlockwise

switch (markerShape _marker) do {
    case "ICON": {
        for "_i" from 1 to _number_slavo do {
            [_marker_pos, _round] spawn fireArtyRound;
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
                private _alpha = (_x - 1) * _marker_size#0 + (random 50 - 25);
                private _beta = (random 2 - 1) * _marker_size#1;
                private _x_pos = _marker_pos#0 + _alpha*cos(_marker_dir) - _beta*sin(_marker_dir);
                private _y_pos = _marker_pos#1 + _alpha*sin(_marker_dir) + _beta*cos(_marker_dir);
                private _pos = [_x_pos, _y_pos, 0];
                [_pos, _round] spawn fireArtyRound;
                sleep 0.2;
            };
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