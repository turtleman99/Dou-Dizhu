classdef player < handle
    
    % properties of poker game engine
    properties (Access = public)
        avatar = 'icon_default.png';
        role = -1;      % -1-defult, 0-landlord, 1-peasant;
        cards = {};     % store the distributed info from *.json
        cards_img = {}; % store the UI components of cards
        cardNum = 0;
        selectNum = 0;  % remember to reset
        isActive = false;
        currUI;         % its own UI
        % dispCards = false;
    end
    
    % methods that game engine has:
    methods
        
    end
end