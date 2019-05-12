classdef player < handle
    
    % properties of poker game engine
    properties (Access = public)
        avatar = 'icon_default.png';
        role = -1;      % -1-defult, 0-landlord, 1-peasant;
        cards = {};
        cardNum = 0;
        selectNum = 0;  % remember to reset
        isActive = false;
        currUI;         % its own UI
    end
    
    % methods that game engine has:
    methods
        
    end
end