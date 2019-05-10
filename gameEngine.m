classdef gameEngine < handle
    
    % properties of poker game engine
    properties
        % All players
        player_0
        player_1
        player_2
        % Total card Num = 54
        cardNum = 54;
        % winner=-1 -> have not determined winner
        winner = -1;
        % determine whether to end the game
        isEnd = false;
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
        % determine which player is winner
        function determineWinner(eg)
            if (eg.player_0.cardNum == 0)
                eg.winner = 0;
                eg.isEnd = true;
            end
            if (eg.player_1.cardNum == 0)
                eg.winner = 1;
                eg.isEnd = true;
            end
            if (eg.player_2.cardNum == 0)
                eg.winner = 2;
                eg.isEnd = true;
            end
        end
        %
    end
end