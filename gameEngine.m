classdef gameEngine < handle
    properties
        % All players and thier apps
        player_0
        player_0_UI
        player_1
        player_1_UI
        player_2
        player_2_UI
        
        rule            % the instance of poker game rule
        landlord = -1   % -1 -> defalut        
        whoseTurn = -1; % -1 -> defalut
        passNum = 0;    % passNum should not more than 2
        cardNum = 54;   % Total card Num = 54       
        winner = -1;    % winner=-1 -> have not determined winner
        isEnd = false;  % determine whether to end the game
        isStart = false; % determine whether to start the game
        isBGM = true;   % determine if play BGM
        
        % In order to sychronize, Distribute cards as soon as one player
        % push 'Ready'. Then create cards compoents and invisible them
        % until game started.
        isDistribute = false; 
        
        % import cards data
        cardsData = transpose(struct2cell(jsondecode(fileread('cards.json'))));
        
        % store the cards that has shotted: 0 -> last turn
        % row 1: str num % row 2: lable
        % row 3: img source % row 4 num
        cards_shotted_0 = {};
        cards_selected = {};
        % used to compare selected cards with last turn's 
        cards_type_0;
        cards_value_0;
        cards_type_selected;
        cards_value_selected;
        
        % for bgm
        bg_room = load('./resourse/audio_mat/bg_room.mat');
        bg_game = load('./resourse/audio_mat/bg_game.mat');
        deal = load('./resourse/audio_mat/deal.mat');
        end_win = load('./resourse/audio_mat/end_win.mat');
        player;        % used to play bgm  
    end
    
    % methods that game engine has:
    methods
        % In 0 stage, random assign Role; -1-defult, 0-landlord, 1-peasant;
        function assignRole(eg)
            % eg.player_0.currUI.currPlayer.myTurn
            eg.landlord = randi(3)-1;
            switch eg.landlord
                case 0
                    eg.player_0.role = 0;
                    eg.player_0.currUI.currPlayer.myTurn = true;
                    eg.player_0.avatar = 'icon_landlord.png';
                    
                    eg.player_1.role = 1;
                    eg.player_1.currUI.currPlayer.myTurn = false;
                    eg.player_1.avatar = 'icon_farmer.png';
                    
                    eg.player_2.role = 1;
                    eg.player_2.currUI.currPlayer.myTurn = false;
                    eg.player_2.avatar = 'icon_farmer.png';
                case 1
                    eg.player_0.role = 1;
                    eg.player_0.currUI.currPlayer.myTurn = false;
                    eg.player_0.avatar = 'icon_farmer.png';
                    
                    eg.player_1.role = 0;
                    eg.player_1.currUI.currPlayer.myTurn = true;
                    eg.player_1.avatar = 'icon_landlord.png';
                    
                    eg.player_2.role = 1;
                    eg.player_2.currUI.currPlayer.myTurn = false;
                    eg.player_2.avatar = 'icon_farmer.png';
                case 2
                    eg.player_0.role = 1;
                    eg.player_0.currUI.currPlayer.myTurn = false;
                    eg.player_0.avatar = 'icon_farmer.png';
                    
                    eg.player_1.role = 1;
                    eg.player_1.currUI.currPlayer.myTurn = false;
                    eg.player_1.avatar = 'icon_farmer.png';
                    
                    eg.player_2.role = 0;
                    eg.player_2.currUI.currPlayer.myTurn = true;
                    eg.player_2.avatar = 'icon_landlord.png';
            end
        end
        % determine which player is winner
        function determineWinner(eg)
            if (eg.player_0.cardNum == 0)
                eg.winner = eg.player_0.role;
                eg.isEnd = true;
                eg.endGame;
            elseif (eg.player_1.cardNum == 0)
                eg.winner = eg.player_1.role;
                eg.isEnd = true;
                eg.endGame;
            elseif (eg.player_2.cardNum == 0)
                eg.winner = eg.player_2.role;
                eg.isEnd = true;
                eg.endGame;
            end
        end
        % Sort hand cards of players, bubble sort implemented.
        function sortCard(eg, player)
            len = player.cardNum;
            for i = 1 : len
                for j = 1 : len-i
                    if (player.cards{4, j} > player.cards{4, j+1})
                        temp_1 = player.cards{1, j+1};
                        temp_2 = player.cards{2, j+1};
                        temp_3 = player.cards{3, j+1};
                        temp_4 = player.cards{4, j+1};
                        
                        player.cards{1, j+1} = player.cards{1, j};
                        player.cards{2, j+1} = player.cards{2, j};
                        player.cards{3, j+1} = player.cards{3, j};
                        player.cards{4, j+1} = player.cards{4, j};
                        
                        player.cards{1, j} = temp_1;
                        player.cards{2, j} = temp_2;
                        player.cards{3, j} = temp_3;
                        player.cards{4, j} = temp_4;
                    end
                end
            end
        end
        % Shuffle and distribute cards
        function distributeCards(eg)
            if (eg.isDistribute == false)
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
                indx_1 = order(52);
                indx_2 = order(53);
                indx_3 = order(54);
                if (eg.landlord == 0)
                    eg.player_0.cards = [eg.player_0.cards, eg.cardsData{indx_1}, eg.cardsData{indx_2}, eg.cardsData{indx_3}];
                    eg.player_0.cardNum = eg.player_0.cardNum + 3;
                elseif (eg.landlord == 1)
                    eg.player_1.cards = [eg.player_1.cards, eg.cardsData{indx_1}, eg.cardsData{indx_2}, eg.cardsData{indx_3}];
                    eg.player_1.cardNum = eg.player_1.cardNum + 3;
                elseif (eg.landlord == 2)
                    eg.player_2.cards = [eg.player_2.cards, eg.cardsData{indx_1}, eg.cardsData{indx_2}, eg.cardsData{indx_3}];
                    eg.player_2.cardNum = eg.player_2.cardNum + 3;
                end
                % sort the hand cards of players
                eg.sortCard(eg.player_0);
                eg.sortCard(eg.player_1);
                eg.sortCard(eg.player_2);
            end
        end
        % update related variables in three players and their apps: lable,
        % display cards
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
                eg.player_0.currUI.CardNum_currplayer.FontSize = 20;
                eg.player_0.currUI.avatar_currplayer.ImageSource = eg.player_0.currUI.currPlayer.avatar;
                eg.player_0.currUI.CardNum_player_1.Text = num2str(eg.player_0.currUI.player_1.cardNum);
                eg.player_0.currUI.CardNum_player_1.FontSize = 20;
                eg.player_0.currUI.avatar_player_1.ImageSource = eg.player_0.currUI.player_1.avatar;
                eg.player_0.currUI.CardNum_player_2.Text = num2str(eg.player_0.currUI.player_2.cardNum);
                eg.player_0.currUI.CardNum_player_2.FontSize = 20;
                eg.player_0.currUI.avatar_player_2.ImageSource = eg.player_0.currUI.player_2.avatar;
                drawnow;
                eg.player_1.currUI.CardNum_currplayer.Text = num2str(eg.player_1.currUI.currPlayer.cardNum);
                eg.player_1.currUI.CardNum_currplayer.FontSize = 20;
                eg.player_1.currUI.avatar_currplayer.ImageSource = eg.player_1.currUI.currPlayer.avatar;
                eg.player_1.currUI.CardNum_player_1.Text = num2str(eg.player_1.currUI.player_1.cardNum);
                eg.player_1.currUI.CardNum_player_1.FontSize = 20;
                eg.player_1.currUI.avatar_player_1.ImageSource = eg.player_1.currUI.player_1.avatar;
                eg.player_1.currUI.CardNum_player_2.Text = num2str(eg.player_1.currUI.player_2.cardNum);
                eg.player_1.currUI.CardNum_player_2.FontSize = 20;
                eg.player_1.currUI.avatar_player_2.ImageSource = eg.player_1.currUI.player_2.avatar;
                drawnow;
                eg.player_2.currUI.CardNum_currplayer.Text = num2str(eg.player_2.currUI.currPlayer.cardNum);
                eg.player_2.currUI.CardNum_currplayer.FontSize = 20;
                eg.player_2.currUI.avatar_currplayer.ImageSource = eg.player_2.currUI.currPlayer.avatar;
                eg.player_2.currUI.CardNum_player_1.Text = num2str(eg.player_2.currUI.player_1.cardNum);
                eg.player_2.currUI.CardNum_player_1.FontSize = 20;
                eg.player_2.currUI.avatar_player_1.ImageSource = eg.player_2.currUI.player_1.avatar;
                eg.player_2.currUI.CardNum_player_2.Text = num2str(eg.player_2.currUI.player_2.cardNum);
                eg.player_2.currUI.CardNum_player_2.FontSize = 20;
                eg.player_2.currUI.avatar_player_2.ImageSource = eg.player_2.currUI.player_2.avatar;
                drawnow;
                % display card
                eg.displayCard;
                eg.bgm;
            end
            % TODO: 
            % 1. chenck if cardNum and avatar are matched -> done
            % 2. update card display -> done
        end
        % display handcards in three UIs
        function displayCard(eg)
            % player_0 UI
            if (eg.landlord == 0)
                up = 20;
            else
                up = 17;
            end 
            mid = (eg.player_0.currUI.currPlayer.cardNum + 1)/2;
            temp_index = 1;
            for i = 1 : up
                if (eg.player_0.currUI.currPlayer.cards_img{3, i} == false)
                    x = 565 + (temp_index - mid) * 32;
%                     if (eg.player_0.currUI.currPlayer.cards_img{1, i}.Position(2) == 22)
                    eg.player_0.currUI.currPlayer.cards_img{1, i}.Position = [x, 22, 173, 256];
%                     elseif (eg.player_0.currUI.currPlayer.cards_img{1, i}.Position(2) == 52)
%                         eg.player_0.currUI.currPlayer.cards_img{1, i}.Position = [x, 52, 173, 256];
%                     end
                    eg.player_0.currUI.currPlayer.cards_img{1, i}.Visible = true;
                    eg.player_0.currUI.currPlayer.cards_img{2, i} = false; % not selected
                    eg.player_0.currUI.currPlayer.selectNum = 0;           % init select Num
                    temp_index = temp_index + 1;
                end
            end
            % player_1 UI
            if (eg.landlord == 1)
                up = 20;
            else
                up = 17;
            end 
            mid = (eg.player_1.currUI.currPlayer.cardNum + 1)/2;
            temp_index = 1;
            for i = 1 : up
                if (eg.player_1.currUI.currPlayer.cards_img{3, i} == false)
                    x = 565 + (temp_index - mid) * 32;
%                     if (eg.player_1.currUI.currPlayer.cards_img{1, i}.Position(2) == 22)
                    eg.player_1.currUI.currPlayer.cards_img{1, i}.Position = [x, 22, 173, 256];
%                     elseif (eg.player_1.currUI.currPlayer.cards_img{1, i}.Position(2) == 52)
%                         eg.player_1.currUI.currPlayer.cards_img{1, i}.Position = [x, 52, 173, 256];
%                     end
                    eg.player_1.currUI.currPlayer.cards_img{1, i}.Visible = true;
                    eg.player_1.currUI.currPlayer.cards_img{2, i} = false; % not selected
                    eg.player_1.currUI.currPlayer.selectNum = 0;           % init select Num
                    temp_index = temp_index + 1;
                end
            end
            % player_2 UI
            if (eg.landlord == 2)
                up = 20;
            else
                up = 17;
            end 
            mid = (eg.player_2.currUI.currPlayer.cardNum + 1)/2;
            temp_index = 1;
            for i = 1 : up
                if (eg.player_2.currUI.currPlayer.cards_img{3, i} == false)
                    x = 565 + (temp_index - mid) * 32;
%                     if (eg.player_2.currUI.currPlayer.cards_img{1, i}.Position(2) == 22)
                    eg.player_2.currUI.currPlayer.cards_img{1, i}.Position = [x, 22, 173, 256];
%                     elseif (eg.player_2.currUI.currPlayer.cards_img{1, i}.Position(2) == 52)
%                         eg.player_2.currUI.currPlayer.cards_img{1, i}.Position = [x, 52, 173, 256];
%                     end
                    eg.player_2.currUI.currPlayer.cards_img{1, i}.Visible = true;
                    eg.player_2.currUI.currPlayer.cards_img{2, i} = false; % not selected
                    eg.player_2.currUI.currPlayer.selectNum = 0;           % init select Num
                    temp_index = temp_index + 1;
                end
            end
        end
        % Display the shotted cards in other players' UIs
        function dispShotCards(eg)
            [nr, shotNum] = size(eg.cards_shotted_0);
            mid = (shotNum + 1)/2;
            % invisble last turn card
            for i = 1 : 20
                eg.player_0.currUI.currDispCards{1, i}.Visible = false;
                eg.player_1.currUI.currDispCards{1, i}.Visible = false;
                eg.player_2.currUI.currDispCards{1, i}.Visible = false;
            end
            % Then display shotted cards in three UIs
            for i = 1 : shotNum
                eg.player_0.currUI.currDispCards{1, fix(10.5-(i-mid))}.ImageSource = eg.cards_shotted_0{3, shotNum - i + 1};
                eg.player_0.currUI.currDispCards{1, fix(10.5-(i-mid))}.Visible = true;
                eg.player_1.currUI.currDispCards{1, fix(10.5-(i-mid))}.ImageSource = eg.cards_shotted_0{3, shotNum - i + 1};
                eg.player_1.currUI.currDispCards{1, fix(10.5-(i-mid))}.Visible = true;
                eg.player_2.currUI.currDispCards{1, fix(10.5-(i-mid))}.ImageSource = eg.cards_shotted_0{3, shotNum - i + 1};
                eg.player_2.currUI.currDispCards{1, fix(10.5-(i-mid))}.Visible = true;
            end
        end
        % decide whose turn to shot cards
        function nextTurn(eg)
            if (eg.isEnd == false)
                if (eg.player_0.currUI.currPlayer.myTurn == true)
                    eg.player_1.currUI.currPlayer.myTurn = true;
                    eg.player_1.currUI.ShotButton.Visible = true; 
                    eg.player_1.currUI.PassButton.Visible = true;

                    eg.player_2.currUI.currPlayer.myTurn = false;
                    eg.player_2.currUI.ShotButton.Visible = false; 
                    eg.player_2.currUI.PassButton.Visible = false;

                    eg.player_0.currUI.currPlayer.myTurn = false;
                    eg.player_0.currUI.ShotButton.Visible = false; 
                    eg.player_0.currUI.PassButton.Visible = false;

                    eg.cards_selected = {};
                    eg.cards_type_selected = '';
                    eg.cards_value_selected = -2;
                elseif (eg.player_1.currUI.currPlayer.myTurn == true)
                    eg.player_2.currUI.currPlayer.myTurn = true;
                    eg.player_2.currUI.ShotButton.Visible = true; 
                    eg.player_2.currUI.PassButton.Visible = true;

                    eg.player_0.currUI.currPlayer.myTurn = false;
                    eg.player_0.currUI.ShotButton.Visible = false; 
                    eg.player_0.currUI.PassButton.Visible = false;

                    eg.player_1.currUI.currPlayer.myTurn = false;
                    eg.player_1.currUI.ShotButton.Visible = false; 
                    eg.player_1.currUI.PassButton.Visible = false;

                    eg.cards_selected = {};
                    eg.cards_type_selected = '';
                    eg.cards_value_selected = -2;
                elseif (eg.player_2.currUI.currPlayer.myTurn == true)
                    eg.player_0.currUI.currPlayer.myTurn = true;
                    eg.player_0.currUI.ShotButton.Visible = true; 
                    eg.player_0.currUI.PassButton.Visible = true;

                    eg.player_1.currUI.currPlayer.myTurn = false;
                    eg.player_1.currUI.ShotButton.Visible = false; 
                    eg.player_1.currUI.PassButton.Visible = false;

                    eg.player_2.currUI.currPlayer.myTurn = false;
                    eg.player_2.currUI.ShotButton.Visible = false; 
                    eg.player_2.currUI.PassButton.Visible = false;

                    eg.cards_selected = {};
                    eg.cards_type_selected = '';
                    eg.cards_value_selected = -2;
                end
            end
        end
        % start game with following process
        function startGame(eg)
            % Start: Enable the Shot and Pass button
            eg.player_0.currUI.ShotButton.Enable = true;   
            eg.player_0.currUI.PassButton.Enable = true;
            eg.player_1.currUI.ShotButton.Enable = true;   
            eg.player_1.currUI.PassButton.Enable = true;
            eg.player_2.currUI.ShotButton.Enable = true;   
            eg.player_2.currUI.PassButton.Enable = true;
            % Start: control the 'visible' of Shot and Pass button
            if (eg.landlord == 0)
                eg.player_0.currUI.ShotButton.Visible = true; 
                eg.player_0.currUI.PassButton.Visible = true;
                eg.player_0.currUI.PassButton.Enable = false;
                eg.player_1.currUI.ShotButton.Visible = false; 
                eg.player_1.currUI.PassButton.Visible = false;
                eg.player_2.currUI.ShotButton.Visible = false; 
                eg.player_2.currUI.PassButton.Visible = false;
            elseif (eg.landlord == 1)
                eg.player_1.currUI.ShotButton.Visible = true; 
                eg.player_1.currUI.PassButton.Visible = true;
                eg.player_1.currUI.PassButton.Enable = false;
                eg.player_0.currUI.ShotButton.Visible = false; 
                eg.player_0.currUI.PassButton.Visible = false;
                eg.player_2.currUI.ShotButton.Visible = false; 
                eg.player_2.currUI.PassButton.Visible = false;
            elseif (eg.landlord == 2)
                eg.player_2.currUI.ShotButton.Visible = true; 
                eg.player_2.currUI.PassButton.Visible = true;
                eg.player_2.currUI.PassButton.Enable = false;
                eg.player_1.currUI.ShotButton.Visible = false; 
                eg.player_1.currUI.PassButton.Visible = false;
                eg.player_0.currUI.ShotButton.Visible = false; 
                eg.player_0.currUI.PassButton.Visible = false;
            end
            
            eg.player = audioplayer(eg.deal.deal, eg.deal.deal_Fs);
            eg.player.Tag = 'deal';
            if (isplaying(eg.player) == false && (eg.isBGM == true))
                play(eg.player); 
            end
            
            eg.displayCard;
            eg.update;
            eg.bgm;
        end
        % End game with following process
        function endGame(eg)
            % unable all buttons
            if (eg.isEnd)
                % invisible all shotted cards
                for i = 1 : 20
                    eg.player_0.currUI.currDispCards{1, i}.Visible = false;
                    eg.player_1.currUI.currDispCards{1, i}.Visible = false;
                    eg.player_2.currUI.currDispCards{1, i}.Visible = false;
                end
                % unable all buttons
                eg.player_0.currUI.ReadyButton.Visible = false;
                eg.player_0.currUI.ShotButton.Visible = false;
                eg.player_0.currUI.PassButton.Visible = false;
                eg.player_0.currUI.Image.Visible = false;
                eg.player_1.currUI.ReadyButton.Visible = false;
                eg.player_1.currUI.ShotButton.Visible = false;
                eg.player_1.currUI.PassButton.Visible = false;
                eg.player_1.currUI.Image.Visible = false;
                eg.player_2.currUI.ReadyButton.Visible = false;
                eg.player_2.currUI.ShotButton.Visible = false;
                eg.player_2.currUI.PassButton.Visible = false;
                eg.player_2.currUI.Image.Visible = false;
                if (eg.winner == 1)
                    msg = 'Peasants Win!';
                elseif (eg.winner == 0)
                    msg = 'Landlord Win!';
                end
                % Show winner info
                eg.player_0.currUI.winLabel.Text = msg;
                eg.player_0.currUI.winLabel.Visible = true;
                eg.player_1.currUI.winLabel.Text = msg;
                eg.player_1.currUI.winLabel.Visible = true;
                eg.player_2.currUI.winLabel.Text = msg;
                eg.player_2.currUI.winLabel.Visible = true;
                
                % BGM
                eg.player = audioplayer(eg.end_win.end_win, eg.end_win.end_win_Fs);
                eg.player.Tag = 'end_win';
                if (isplaying(eg.player) == false)
                    play(eg.player); 
                end
            end
        end
        % control the BGM
        function bgm(eg)
            if (eg.isStart == false)
                if (isempty(eg.player) == true)
                    eg.player = audioplayer(eg.bg_room.bg_room, eg.bg_room.bg_room_Fs);
                    eg.player.Tag = 'room';
                    if (isplaying(eg.player) == false && (eg.isBGM == true))
                        play(eg.player); 
                    end
                elseif (strcmp(eg.player.Tag ,'deal'))
                    eg.player = audioplayer(eg.bg_room.bg_room, eg.bg_room.bg_room_Fs);
                    eg.player.Tag = 'room';
                    if (isplaying(eg.player) == false && (eg.isBGM == true))
                        play(eg.player); 
                    end
                elseif (strcmp(eg.player.Tag, 'room'))
                    if (isplaying(eg.player) == false && (eg.isBGM == true))
                        play(eg.player); 
                    end
                end
            elseif (eg.isStart == true)
                if (or(strcmp(eg.player.Tag,'room'), strcmp(eg.player.Tag,'deal')))
                    eg.player = audioplayer(eg.bg_game.bg_game, eg.bg_game.bg_game_Fs);
                    eg.player.Tag = 'play';
                end
                if (isplaying(eg.player) == false && (eg.isBGM == true))   
                    play(eg.player); 
                end
            end            
        end
    end
end