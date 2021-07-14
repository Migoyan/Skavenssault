/**
 * Function which lauch a series of waves
 *
 * @param _waves : 
 * @returns Nothing
 *
 * author : Migoyan
 */
params [
	["_waves", [], [[]]]
];

{
	_x spawn skst_fnc_spawnUnitWave;
} forEach _waves;