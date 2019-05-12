classdef player < handle
    
    % properties of poker game engine
    properties (Access = public)
        avatar = 'icon_default.png';
        role = -1;      % -1-defult, 0-landlord, 1-peasant;
        cards = {};     % store the distributed info from *.json
        cardNum = 0;
        selectNum = 0;  % remember to reset
        isActive = false;
        currUI;         % its own UI
        % row 1 store the components of cards; row 2 stores whether the
        % card has selected; row 3 stores whether the cards has shoted
        cards_img = {}; 
    end
    
    % methods that game engine has:
    methods
        
    end
end