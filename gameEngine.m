classdef gameEngine < handle
    
    % properties of poker game engine
    properties
        player_0
        player_1
        player_2
    end
    
    % methods that game engine has:
    methods
        % In 0 stage, random assign Role; -1-defult, 0-landlord, 1-peasant;
        function assignRole(eg)
            indx = randi(2);
            switch indx
                case 0
                    eg.player_0.role = 0;
                    eg.player_1.role = 1;
                    eg.player_2.role = 1;
                case 1
                    eg.player_0.role = 1;
                    eg.player_1.role = 0;
                    eg.player_2.role = 1;
                case 2
                    eg.player_0.role = 1;
                    eg.player_1.role = 1;
                    eg.player_2.role = 0;
            end
        end
        %
    end
end