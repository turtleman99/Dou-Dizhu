classdef gameEngine < handle
    
    % properties of poker game engine
    properties
        % All players and thier apps
        player_0
        player_0_UI
        player_1
        player_1_UI
        player_2
        player_2_UI
        
        landlord = -1   % -1 -> defalut        
        whoseTurn = -1; % -1 -> defalut
        cardNum = 54;   % Total card Num = 54       
        winner = -1;    % winner=-1 -> have not determined winner
        isEnd = false;  % determine whether to end the game
        isStart = false; % determine whether start the game
        
        % import cards data
        cardsData = transpose(struct2cell(jsondecode(fileread('cards.json'))));        
        
        
    end
    
    % methods that game engine has:
    methods
        % In 0 stage, random assign Role; -1-defult, 0-landlord, 1-peasant;
        function assignRole(eg)
            eg.landlord = randi(3)-1;
            switch eg.landlord
                case 0
                    eg.player_0.role = 0;
                    eg.player_0.avatar = 'icon_landlord.png';
                    eg.player_1.role = 1;
                    eg.player_1.avatar = 'icon_farmer.png';
                    eg.player_2.role = 1;
                    eg.player_2.avatar = 'icon_farmer.png';
                case 1
                    eg.player_0.role = 1;
                    eg.player_0.avatar = 'icon_farmer.png';
                    eg.player_1.role = 0;
                    eg.player_1.avatar = 'icon_landlord.png';
                    eg.player_2.role = 1;
                    eg.player_2.avatar = 'icon_farmer.png';
                case 2
                    eg.player_0.role = 1;
                    eg.player_0.avatar = 'icon_farmer.png';
                    eg.player_1.role = 1;
                    eg.player_1.avatar = 'icon_farmer.png';
                    eg.player_2.role = 0;
                    eg.player_2.avatar = 'icon_landlord.png';
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
        function distributeCards(eg)
            % Shuffle
            order = randperm(54);
            % distribute to all players
            for i = 1:17
                indx = order(i);
                eg.player_0.cards = [eg.player_0.cards, eg.cardsData{indx}];
                eg.player_0.cardNum = eg.player_0.cardNum + 1;
            end
            for i = 18:34
                indx = order(i);
                eg.player_1.cards = [eg.player_1.cards, eg.cardsData{indx}];
                eg.player_1.cardNum = eg.player_1.cardNum + 1;
            end
            for i = 35:51
                indx = order(i);
                eg.player_2.cards = [eg.player_2.cards, eg.cardsData{indx}];
                eg.player_2.cardNum = eg.player_2.cardNum + 1;
            end
            % distribute to landlord
            if (eg.landlord == 0)
                eg.player_0.cards = [eg.player_0.cards, eg.cardsData{52}, eg.cardsData{53}, eg.cardsData{54}];
                eg.player_0.cardNum = eg.player_0.cardNum + 3;
            elseif (eg.landlord == 1)
                eg.player_1.cards = [eg.player_1.cards, eg.cardsData{52}, eg.cardsData{53}, eg.cardsData{54}];
                eg.player_1.cardNum = eg.player_1.cardNum + 3;
            elseif (eg.landlord == 2)
                eg.player_2.cards = [eg.player_2.cards, eg.cardsData{52}, eg.cardsData{53}, eg.cardsData{54}];
                eg.player_2.cardNum = eg.player_2.cardNum + 3;
            end
        end
        % update related variables in three players and their apps
        function update(eg)
            % display 'Ready' status
            if (eg.isStart == false)
                % player_0_UI
                if (eg.player_0.currUI.player_1.isActive == true)
                    eg.player_0.currUI.CardNum_player_1.Text = 'Ready';
                end
                if (eg.player_0.currUI.player_2.isActive == true)
                    eg.player_0.currUI.CardNum_player_2.Text = 'Ready';
                end
                % player_1_UI
                if (eg.player_1.currUI.player_1.isActive == true)
                    eg.player_1.currUI.CardNum_player_1.Text = 'Ready';
                end
                if (eg.player_1.currUI.player_2.isActive == true)
                    eg.player_1.currUI.CardNum_player_2.Text = 'Ready';
                end
                % player_2_UI
                if (eg.player_2.currUI.player_1.isActive == true)
                    eg.player_2.currUI.CardNum_player_1.Text = 'Ready';
                end
                if (eg.player_2.currUI.player_2.isActive == true)
                    eg.player_2.currUI.CardNum_player_2.Text = 'Ready';
                end
            end
            % Card num and Avatar 
            if (eg.isStart == true)                
                eg.player_0.currUI.CardNum_currplayer.Text = num2str(eg.player_0.currUI.currPlayer.cardNum);
                eg.player_0.currUI.avatar_currplayer.ImageSource = eg.player_0.currUI.currPlayer.avatar;
                eg.player_0.currUI.CardNum_player_1.Text = num2str(eg.player_0.currUI.player_1.cardNum);
                eg.player_0.currUI.avatar_player_1.ImageSource = eg.player_0.currUI.player_1.avatar;
                eg.player_0.currUI.CardNum_player_2.Text = num2str(eg.player_0.currUI.player_2.cardNum);
                eg.player_0.currUI.avatar_player_2.ImageSource = eg.player_0.currUI.player_2.avatar;
                drawnow;
                eg.player_1.currUI.CardNum_currplayer.Text = num2str(eg.player_1.currUI.currPlayer.cardNum);
                eg.player_1.currUI.avatar_currplayer.ImageSource = eg.player_1.currUI.currPlayer.avatar;
                eg.player_1.currUI.CardNum_player_1.Text = num2str(eg.player_1.currUI.player_1.cardNum);
                eg.player_1.currUI.avatar_player_1.ImageSource = eg.player_1.currUI.player_1.avatar;
                eg.player_1.currUI.CardNum_player_2.Text = num2str(eg.player_1.currUI.player_2.cardNum);
                eg.player_1.currUI.avatar_player_2.ImageSource = eg.player_1.currUI.player_2.avatar;
                drawnow;
                eg.player_2.currUI.CardNum_currplayer.Text = num2str(eg.player_2.currUI.currPlayer.cardNum);
                eg.player_2.currUI.avatar_currplayer.ImageSource = eg.player_2.currUI.currPlayer.avatar;
                eg.player_2.currUI.CardNum_player_1.Text = num2str(eg.player_2.currUI.player_1.cardNum);
                eg.player_2.currUI.avatar_player_1.ImageSource = eg.player_2.currUI.player_1.avatar;
                eg.player_2.currUI.CardNum_player_2.Text = num2str(eg.player_2.currUI.player_2.cardNum);
                eg.player_2.currUI.avatar_player_2.ImageSource = eg.player_2.currUI.player_2.avatar;
                drawnow;
            end
            % TODO: 
            % 1. chenck if cardNum and avatar are matched
            % 2. update card display
        end
        % display cards in three UIs(create components)
        function displayCard(eg)
            
        end
        %
        
        % start game with following process
        function startGame(eg)
            eg.assignRole;
            eg.distributeCards;
            eg.update;
        end
        % End game with following process
        function endGame(eg)
            if (eg.isEnd)
                
            end
        end
    end
end