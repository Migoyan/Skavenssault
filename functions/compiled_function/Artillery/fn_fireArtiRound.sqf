/**
 * @name fireArtyRound
 *
 * @description Spawn a round and make it drop on position given, designed to be used with atillery rounds.
 *
 * @param {array<number> = [0, 0]} - position x, y of the splash
 * @param {string = ""} - Type of round used
 *
 * @returns true, when function complete
 *
 * @author Migoyan
 */
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

_shell