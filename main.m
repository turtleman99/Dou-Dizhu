close all;
clear all;
rule = struct2cell(jsondecode(fileread('rule.json')));

% Create instances of 'player'
player_0 = player;
player_1 = player;
player_2 = player;

% Create instances of 'pokerGameUI'
% TODO: UI background
player_0_UI = pokerGameUI;
player_0.currUI = player_0_UI;
player_0.currUI.currPlayer = player_0;

player_1_UI = pokerGameUI;
player_1.currUI = player_1_UI;
player_1.currUI.currPlayer = player_1;

player_2_UI = pokerGameUI;
player_2.currUI = player_2_UI;
player_2.currUI.currPlayer = player_2;

% player_0.currUI.currPlayer = player_0;
player_0.currUI.player_1 = player_1;
player_0.currUI.player_2 = player_2;

% player_1.currUI.currPlayer = player_1;
player_1.currUI.player_1 = player_0;
player_1.currUI.player_2 = player_2;

% player_2.currUI.currPlayer = player_2;
player_2.currUI.player_1 = player_0;
player_2.currUI.player_2 = player_1;


% Create instance of 'gameEngine'
ge = gameEngine;
ge.player_0 = player_0;
ge.player_1 = player_1;
ge.player_2 = player_2;

% set gameEngine to different UIs
player_0.currUI.gameEngine = ge;
player_1.currUI.gameEngine = ge;
player_2.currUI.gameEngine = ge;





