classdef pokerGameUI_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        ReadyButton         matlab.ui.control.StateButton
        ShotButton          matlab.ui.control.Button
        PassButton          matlab.ui.control.Button
        CardNum_player_1    matlab.ui.control.Label
        backCard_player_1   matlab.ui.control.Image
        CardNum_player_2    matlab.ui.control.Label
        backCard_player_2   matlab.ui.control.Image
        avatar_player_2     matlab.ui.control.Image
        avatar_currplayer   matlab.ui.control.Image
        avatar_player_1     matlab.ui.control.Image
        CardNum_currplayer  matlab.ui.control.Label
        winLabel            matlab.ui.control.Label
    end

    
    properties (Access = public)
        % Three players
         currPlayer 
         player_1
         player_2
         gameEngine
         currDispCards = {}; % Only used to display other players' shoted cards
    end
    
    methods (Access = private)
        
        function selectCard(app, src, event, indx)
            if (app.currPlayer.cards_img{1, indx}.Position(1,2) == 22)
                app.currPlayer.cards_img{1, indx}.Position(1,2) = 62;
                app.currPlayer.cards_img{2, indx} = true;
                app.currPlayer.selectNum = app.currPlayer.selectNum + 1;
            elseif (app.currPlayer.cards_img{1, indx}.Position(1,2) == 62)
                app.currPlayer.cards_img{1, indx}.Position(1,2) = 22;
                app.currPlayer.cards_img{2, indx} = false;
                app.currPlayer.selectNum = app.currPlayer.selectNum - 1;
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Create Cards components to display the cards that
            % other players shotted: invisible by default.
            for i  = 1 : 20
                app.currDispCards{1, i} = uiimage(app.UIFigure);
                mid = (1+20)/2;
                x = 565 + (i - mid) * 32;
                app.currDispCards{1, i}.Position = [x, 446, 173, 256];
                app.currDispCards{1, i}.Visible = false;
            end
        end

        % Value changed function: ReadyButton
        function ReadyButtonValueChanged(app, event)
            value = app.ReadyButton.Value;
            app.currPlayer.isActive = true;
            app.ReadyButton.Visible = false;
            % update 'ready' in UIs
            app.CardNum_currplayer.Text = 'Ready';
            app.gameEngine.update;
            drawnow
            
            if (app.gameEngine.isDistribute == false)
                app.gameEngine.assignRole;
                app.gameEngine.distributeCards;
                app.gameEngine.isDistribute = true;
            end
            
            % Create curr player cards components and set them as invisible
            for i = 1:app.currPlayer.cardNum
                app.currPlayer.cards_img{1, i} = uiimage(app.UIFigure,'ImageSource', app.currPlayer.cards{3, i});
                app.currPlayer.cards_img{2, i} = false; % is seleted
                app.currPlayer.cards_img{3, i} = false; % is shotted
                app.currPlayer.cards_img{4, i} = app.currPlayer.cards{1, i}; % the str number 
                app.currPlayer.cards_img{5, i} = app.currPlayer.cards{2, i}; % the lable
                app.currPlayer.cards_img{6, i} = app.currPlayer.cards{4, i}; % the num
                app.currPlayer.cards_img{1, i}.ImageClickedFcn = {@app.selectCard, i};
                app.currPlayer.cards_img{1, i}.Visible = false;
            end
            
            if (app.player_1.isActive == true && app.player_2.isActive == true)
                app.gameEngine.isStart = true;
                app.gameEngine.startGame;
            end
            
            if (app.gameEngine.isStart == true)
                app.gameEngine.update;
            end
        end

        % Callback function
        function ButtonValueChanged(app, event)
            
        end

        % Button pushed function: ShotButton
        function ShotButtonPushed(app, event)
            % init gameEngine's cards_shotted
            if (app.currPlayer.shotOnce == false)
                app.gameEngine.cards_shotted_0 = app.gameEngine.cards_shotted_1;
                app.gameEngine.cards_type_0 = app.gameEngine.cards_type_1;
                app.gameEngine.cards_value_0 = app.gameEngine.cards_value_1;
                app.gameEngine.cards_shotted_1 = {};
                app.gameEngine.cards_type_1 = '';
                app.gameEngine.cards_value_1 = 0; % assume not found
                app.currPlayer.shotOnce = true;
            end
            % compare selected cards and last turn cards
            if (app.currPlayer.role == 0)
                up = 20;
            elseif (app.currPlayer.role == 1)
                up = 17;
            end
            indx_selected = 1;
            % init gameEngine's cards_selected
            app.gameEngine.cards_selected = {};
            for i = 1: up
                % if selected && not shotted
                if (app.currPlayer.cards_img{2, i} == true && app.currPlayer.cards_img{3, i} == false) 
                    app.gameEngine.cards_selected{1, indx_selected} = app.currPlayer.cards_img{4, i}; % str num
                    app.gameEngine.cards_selected{2, indx_selected} = app.currPlayer.cards_img{5, i}; % lable
                    app.gameEngine.cards_selected{3, indx_selected} = app.currPlayer.cards_img{1, i}.ImageSource; % img source
                    app.gameEngine.cards_selected{4, indx_selected} = app.currPlayer.cards_img{6, i}; % num
                    indx_selected = indx_selected + 1;
                end
            end
            
            % use rule to compare
            app.gameEngine.rule.compare_poker(app.gameEngine.cards_shotted_0, app.gameEngine.cards_selected);
            
            if (app.gameEngine.rule.compare_result > 0)
                % reset app.gameEngine.passNum
                app.gameEngine.player_0.currUI.PassButton.Enable = true;
                app.gameEngine.player_1.currUI.PassButton.Enable = true;
                app.gameEngine.player_2.currUI.PassButton.Enable = true;
                app.gameEngine.passNum = 0;
                
                if (app.currPlayer.role == 0)
                    up = 20;
                elseif (app.currPlayer.role == 1)
                    up = 17;
                end
                indx_selected = 1;
                for i = 1: up
                    % if selected && not shotted
                    if (app.currPlayer.cards_img{2, i} == true && app.currPlayer.cards_img{3, i} == false) 
                        app.currPlayer.cards_img{1, i}.Visible = false;
                        app.currPlayer.cards_img{3, i} = true;  % is shotted
                        % Store them to gameEngine's cards_shotted = {};
                        app.gameEngine.cards_shotted_1{1, indx_selected} = app.currPlayer.cards_img{4, i}; % str num
                        app.gameEngine.cards_shotted_1{2, indx_selected} = app.currPlayer.cards_img{5, i}; % lable
                        app.gameEngine.cards_shotted_1{3, indx_selected} = app.currPlayer.cards_img{1, i}.ImageSource; % img source
                        app.gameEngine.cards_shotted_1{4, indx_selected} = app.currPlayer.cards_img{6, i}; % num
                        indx_selected = indx_selected + 1;
                    end
                end
                % update cardNum
                app.currPlayer.cardNum = app.currPlayer.cardNum - app.currPlayer.selectNum;
                app.currPlayer.selectNum = 0;
                app.gameEngine.update;
                % show shotted cards in three UIs
                app.gameEngine.dispShotCards;
                app.gameEngine.determineWinner;
                app.currPlayer.shotOnce = false;
                app.gameEngine.cards_selected = {};
                % debugging
                z = 'Curr type: ' 
                app.gameEngine.cards_type_1
                x = 'prev type: '
                app.gameEngine.cards_type_0
                y = 'Curr value: '
                app.gameEngine.cards_value_1
                f = 'prev value: '
                app.gameEngine.cards_value_0
                g = 'Compare result: '
                app.gameEngine.rule.compare_result
                % debugging
                app.gameEngine.nextTurn;
            end
        end

        % Button pushed function: PassButton
        function PassButtonPushed(app, event)
            app.gameEngine.passNum = app.gameEngine.passNum + 1;
            app.gameEngine.nextTurn;
            if (app.gameEngine.passNum >= 2)
                app.gameEngine.cards_shotted_1 = {};
                app.gameEngine.cards_type_1 = '';
                app.gameEngine.cards_value_1 = -2; % assume not found at first
                if (app.gameEngine.player_0.currUI.currPlayer.myTurn == true)
                    app.gameEngine.player_0.currUI.PassButton.Enable = false; 
                elseif (app.gameEngine.player_1.currUI.currPlayer.myTurn == true)
                    app.gameEngine.player_1.currUI.PassButton.Enable = false; 
                elseif (app.gameEngine.player_2.currUI.currPlayer.myTurn == true)
                    app.gameEngine.player_2.currUI.PassButton.Enable = false; 
                end
            end
            % when pass, clean the selected
            app.gameEngine.cards_selected = {};
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1272 788];
            app.UIFigure.Name = 'UI Figure';

            % Create ReadyButton
            app.ReadyButton = uibutton(app.UIFigure, 'state');
            app.ReadyButton.ValueChangedFcn = createCallbackFcn(app, @ReadyButtonValueChanged, true);
            app.ReadyButton.Text = 'Ready';
            app.ReadyButton.Position = [401 349 110 50];

            % Create ShotButton
            app.ShotButton = uibutton(app.UIFigure, 'push');
            app.ShotButton.ButtonPushedFcn = createCallbackFcn(app, @ShotButtonPushed, true);
            app.ShotButton.Icon = 'shot.png';
            app.ShotButton.IconAlignment = 'center';
            app.ShotButton.FontSize = 1;
            app.ShotButton.Enable = 'off';
            app.ShotButton.Position = [591 349 120 50];
            app.ShotButton.Text = 'Shot';

            % Create PassButton
            app.PassButton = uibutton(app.UIFigure, 'push');
            app.PassButton.ButtonPushedFcn = createCallbackFcn(app, @PassButtonPushed, true);
            app.PassButton.Icon = 'pass.png';
            app.PassButton.IconAlignment = 'center';
            app.PassButton.FontSize = 1;
            app.PassButton.Enable = 'off';
            app.PassButton.Position = [781 349 110 50];
            app.PassButton.Text = 'Pass';

            % Create CardNum_player_1
            app.CardNum_player_1 = uilabel(app.UIFigure);
            app.CardNum_player_1.Position = [59 447 65 22];
            app.CardNum_player_1.Text = 'Not ready!';

            % Create backCard_player_1
            app.backCard_player_1 = uiimage(app.UIFigure);
            app.backCard_player_1.Position = [31 477 108 142];
            app.backCard_player_1.ImageSource = 'poker_back.jpg';

            % Create CardNum_player_2
            app.CardNum_player_2 = uilabel(app.UIFigure);
            app.CardNum_player_2.Position = [1166 447 65 22];
            app.CardNum_player_2.Text = 'Not ready!';

            % Create backCard_player_2
            app.backCard_player_2 = uiimage(app.UIFigure);
            app.backCard_player_2.Position = [1141 477 113 142];
            app.backCard_player_2.ImageSource = 'poker_back.jpg';

            % Create avatar_player_2
            app.avatar_player_2 = uiimage(app.UIFigure);
            app.avatar_player_2.Position = [1148 659 100 100];
            app.avatar_player_2.ImageSource = 'icon_default.png';

            % Create avatar_currplayer
            app.avatar_currplayer = uiimage(app.UIFigure);
            app.avatar_currplayer.Position = [31 179 100 100];
            app.avatar_currplayer.ImageSource = 'icon_default.png';

            % Create avatar_player_1
            app.avatar_player_1 = uiimage(app.UIFigure);
            app.avatar_player_1.Position = [35 659 100 100];
            app.avatar_player_1.ImageSource = 'icon_default.png';

            % Create CardNum_currplayer
            app.CardNum_currplayer = uilabel(app.UIFigure);
            app.CardNum_currplayer.Position = [53 138 65 22];
            app.CardNum_currplayer.Text = 'Not ready!';

            % Create winLabel
            app.winLabel = uilabel(app.UIFigure);
            app.winLabel.HorizontalAlignment = 'center';
            app.winLabel.FontSize = 50;
            app.winLabel.FontColor = [1 0 0];
            app.winLabel.Visible = 'off';
            app.winLabel.Position = [493 512 288 65];
            app.winLabel.Text = {'AAAAA win !'; ''};

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = pokerGameUI_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end