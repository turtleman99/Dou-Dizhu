classdef player < handle
    
    % properties of poker game engine
    properties (Access = public)
        avatar = 'icon_default.png';
        role = -1;      % -1-defult, 0-landlord, 1-peasant;
        cards = {};     % store the distributed info from *.json
        cardNum = 0;
        selectNum = 0;  % remember to reset
        isActive = false;
        myTurn = false;
        shotOnce = false;
        currUI;         % its own UI
        
        % row 1 stores the components of cards;
        % row 2 stores whether the card has selected;
        % row 3 stores whether the cards has shotted;
        % row 4 stores the str# of cards;
        % row 5 stores the lable 
        % row 6 stores the # of cards
        cards_img = {}; 
    end
    
    % methods that game engine has:
    methods
        % Kinda empty an stage 0; easy for iteration
    end
end