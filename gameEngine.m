classdef gameEngine < handle
    
    % properties of poker game engine
    properties
        % All players
        player_0
        player_1
        player_2
        
        landlord
        whoseTurn = -1;
        % import cards data
        cardsData = transpose(struct2cell(jsondecode(fileread('cards.json'))));
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
            eg.landlord = randi(3)-1;
            switch eg.landlord
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
            elseif (eg.player_1.cardNum == 0)
                eg.winner = 1;
                eg.isEnd = true;
            elseif (eg.player_2.cardNum == 0)
                eg.winner = 2;
                eg.isEnd = true;
            end
        end
        % Shuffle and distribute cards
        function dsistributeCards(eg)
            % Shuffle
            order = randperm(54);
            % distribute to all players
            for i = 1:17
                indx = order(i);
                eg.player_0.cards = [eg.player_0.cards, eg.cardsData{indx}];
            end
            for i = 18:34
                indx = order(i);
                eg.player_1.cards = [eg.player_1.cards, eg.cardsData{indx}];
            end
            for i = 35:51
                indx = order(i);
                eg.player_2.cards = [eg.player_2.cards, eg.cardsData{indx}];
            end
            % distribute to landlord
            if (eg.landlord == 0)
                eg.player_0.cards = [eg.player_0.cards, eg.cardsData{52}, eg.cardsData{53}, eg.cardsData{54}];
            elseif (eg.landlord == 1)
                eg.player_1.cards = [eg.player_1.cards, eg.cardsData{52}, eg.cardsData{53}, eg.cardsData{54}];
            elseif (eg.landlord == 2)
                eg.player_2.cards = [eg.player_2.cards, eg.cardsData{52}, eg.cardsData{53}, eg.cardsData{54}];
            end
        end
        %
        
        % start game with following process
        function startGame(eg)
            
        end
        % End game with following process
        function endGame(eg)
            
        end
    end
end