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
        Image               matlab.ui.control.Image
        Label               matlab.ui.control.Label
        Switch              matlab.ui.control.Switch
    end

    
    properties (Access = public)
        % Three players
         currPlayer 
         player_1
         player_2
         gameEngine
         currDispCards = {}; % Only used to display shot cards
    end
    
    methods (Access = private)
        
        function selectCard(app, src, event, indx)
            if ((app.currPlayer.cards_img{1, indx}.Position(1,2) == 22) && (app.currPlayer.myTurn == true))
                app.currPlayer.cards_img{1, indx}.Position(1,2) = 52;
                app.currPlayer.cards_img{2, indx} = true;                   % is select
                app.currPlayer.selectNum = app.currPlayer.selectNum + 1;    % selected #++
            elseif (app.currPlayer.cards_img{1, indx}.Position(1,2) == 22)
                app.currPlayer.cards_img{1, indx}.Position(1,2) = 52;
                app.currPlayer.selectNum = app.currPlayer.selectNum + 1;    % selected #++
            elseif ((app.currPlayer.cards_img{1, indx}.Position(1,2) == 52) && (app.currPlayer.myTurn == true))
                app.currPlayer.cards_img{1, indx}.Position(1,2) = 22;
                app.currPlayer.cards_img{2, indx} = false;                   % not select
                app.currPlayer.selectNum = app.currPlayer.selectNum - 1;     % selected #--
            elseif (app.currPlayer.cards_img{1, indx}.Position(1,2) == 52)
                app.currPlayer.cards_img{1, indx}.Position(1,2) = 22;
                app.currPlayer.selectNum = app.currPlayer.selectNum - 1;     % selected #--
            end
            app.gameEngine.bgm;
        end 
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Create Cards components to display the cards that
            % other players shot: invisible by default.
            for i  = 1 : 20
                app.currDispCards{1, i} = uiimage(app.UIFigure);
                mid = (1+20)/2;
                x = 565 + (i - mid) * 32;
                app.currDispCards{1, i}.Position = [x, 446, 173, 256];
                app.currDispCards{1, i}.Visible = false;
            end
        end

        % Value changed function: ReadyButton
        function ReadyButtonValueChanged2(app, event)
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
            app.gameEngine.bgm;
        end

        % Callback function
        function ButtonValueChanged(app, event)
            
        end

        % Button pushed function: ShotButton
        function ShotButtonPushed(app, event)
            
            % init gameEngine's cards_selected
            app.gameEngine.cards_selected = {};
            app.gameEngine.cards_type_selected = '';
            app.gameEngine.cards_value_selected = -2;
        
            % compare selected cards and last turn cards
            if (app.currPlayer.role == 0)
                up = 20;
            elseif (app.currPlayer.role == 1)
                up = 17;
            end
            indx_selected = 1;
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
            
            % Compare
            app.gameEngine.rule.compare_poker(app.gameEngine.cards_shotted_0, app.gameEngine.cards_selected);
            
            % bigger
            if (app.gameEngine.rule.compare_result > 0)
                
                %######################### debugging #######################
                x = 'prev type: '
                app.gameEngine.cards_type_0
                p = 'selected type'
                app.gameEngine.cards_type_selected
                y = 'prev value: '
                app.gameEngine.cards_value_0
                q = 'selected value: '
                app.gameEngine.cards_value_selected
                g = 'Compare result: '
                app.gameEngine.rule.compare_result
                %######################### debugging #######################
                
                % reset app.gameEngine.passNum
                app.gameEngine.player_0.currUI.PassButton.Enable = true;
                app.gameEngine.player_1.currUI.PassButton.Enable = true;
                app.gameEngine.player_2.currUI.PassButton.Enable = true;
                app.gameEngine.passNum = 0;
                
                % update hand cards
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
                        app.currPlayer.cards_img{3, i} = true;  % is shot
                        indx_selected = indx_selected + 1;
                    end
                end
                % update cardNum
                app.currPlayer.cardNum = app.currPlayer.cardNum - app.currPlayer.selectNum;
                app.currPlayer.selectNum = 0;
                app.gameEngine.update;
                % show shot cards in three UIs
                app.gameEngine.cards_shotted_0 = app.gameEngine.cards_selected;
                app.gameEngine.cards_type_0 = app.gameEngine.cards_type_selected;
                app.gameEngine.cards_value_0 = app.gameEngine.cards_value_selected;
                app.gameEngine.dispShotCards;
                app.gameEngine.determineWinner;
                app.gameEngine.cards_selected = {};
                app.gameEngine.cards_type_selected = '';
                app.gameEngine.cards_value_selected = -2;
                app.gameEngine.nextTurn;
            end
            app.gameEngine.update;
            app.gameEngine.bgm;
        end

        % Button pushed function: PassButton
        function PassButtonPushed(app, event)
            app.gameEngine.passNum = app.gameEngine.passNum + 1;
            app.gameEngine.nextTurn;
            if (app.gameEngine.passNum >= 2)
                app.gameEngine.cards_shotted_0 = {};
                app.gameEngine.cards_type_0 = '';
                app.gameEngine.cards_value_0 = -2; % assume not found at first
                if (app.gameEngine.player_0.currUI.currPlayer.myTurn == true)
                    app.gameEngine.player_0.currUI.PassButton.Enable = false; 
                elseif (app.gameEngine.player_1.currUI.currPlayer.myTurn == true)
                    app.gameEngine.player_1.currUI.PassButton.Enable = false; 
                elseif (app.gameEngine.player_2.currUI.currPlayer.myTurn == true)
                    app.gameEngine.player_2.currUI.PassButton.Enable = false; 
                end
            end
            
            % reset selected cards
            if (app.currPlayer.role == 0)
                up = 20;
            elseif (app.currPlayer.role == 1)
                up = 17;
            end
            indx_selected = 1;
            for i = 1: up
                % if selected && not shotted
                if (app.currPlayer.cards_img{2, i} == true && app.currPlayer.cards_img{3, i} == false) 
                    app.currPlayer.cards_img{2, i} = false;
                    indx_selected = indx_selected + 1;
                end
            end
            
            % when pass, clean the selected
            app.gameEngine.cards_selected = {};
            app.currPlayer.selectNum = 0;
            app.gameEngine.update;
            app.gameEngine.bgm;
        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
                % TODO
%             value = app.Switch.Value;
%             if (value == 'On')
%                 if (isplaying(app.gameEngine.player) == false)
%                     resume(app.gameEngine.player);
%                 end
%             elseif (value == 'Off')
%                 pause(app.gameEngine.player);
%             end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.1098 0.1765 0.2275];
            app.UIFigure.Colormap = [0.2431 0.149 0.6588;0.251 0.1647 0.7059;0.2588 0.1804 0.7529;0.2627 0.1961 0.7961;0.2706 0.2157 0.8353;0.2745 0.2353 0.8706;0.2784 0.2549 0.898;0.2784 0.2784 0.9216;0.2824 0.302 0.9412;0.2824 0.3216 0.9569;0.2784 0.3451 0.9725;0.2745 0.3686 0.9843;0.2706 0.3882 0.9922;0.2588 0.4118 0.9961;0.2431 0.4353 1;0.2196 0.4588 0.9961;0.1961 0.4863 0.9882;0.1843 0.5059 0.9804;0.1804 0.5294 0.9686;0.1765 0.549 0.9529;0.1686 0.5686 0.9373;0.1529 0.5922 0.9216;0.1451 0.6078 0.9098;0.1373 0.6275 0.898;0.1255 0.6471 0.8902;0.1098 0.6627 0.8745;0.0941 0.6784 0.8588;0.0706 0.6941 0.8392;0.0314 0.7098 0.8157;0.0039 0.7216 0.7922;0.0078 0.7294 0.7647;0.0431 0.7412 0.7412;0.098 0.749 0.7137;0.1412 0.7569 0.6824;0.1725 0.7686 0.6549;0.1922 0.7765 0.6235;0.2157 0.7843 0.5922;0.2471 0.7922 0.5569;0.2902 0.7961 0.5176;0.3412 0.8 0.4784;0.3922 0.8039 0.4353;0.4471 0.8039 0.3922;0.5059 0.8 0.349;0.5608 0.7961 0.3059;0.6157 0.7882 0.2627;0.6706 0.7804 0.2235;0.7255 0.7686 0.1922;0.7725 0.7608 0.1647;0.8196 0.749 0.1529;0.8627 0.7412 0.1608;0.902 0.7333 0.1765;0.9412 0.7294 0.2118;0.9725 0.7294 0.2392;0.9961 0.7451 0.2353;0.9961 0.7647 0.2196;0.9961 0.7882 0.2039;0.9882 0.8118 0.1882;0.9804 0.8392 0.1765;0.9686 0.8627 0.1647;0.9608 0.8902 0.1529;0.9608 0.9137 0.1412;0.9647 0.9373 0.1255;0.9686 0.9608 0.1059];
            app.UIFigure.Position = [100 100 1272 788];
            app.UIFigure.Name = 'UI Figure';

            % Create ReadyButton
            app.ReadyButton = uibutton(app.UIFigure, 'state');
            app.ReadyButton.ValueChangedFcn = createCallbackFcn(app, @ReadyButtonValueChanged2, true);
            app.ReadyButton.Icon = 'ready.png';
            app.ReadyButton.IconAlignment = 'center';
            app.ReadyButton.Text = 'Ready';
            app.ReadyButton.FontSize = 1;
            app.ReadyButton.Position = [400 320 110 50];

            % Create ShotButton
            app.ShotButton = uibutton(app.UIFigure, 'push');
            app.ShotButton.ButtonPushedFcn = createCallbackFcn(app, @ShotButtonPushed, true);
            app.ShotButton.Icon = 'shot.png';
            app.ShotButton.IconAlignment = 'center';
            app.ShotButton.FontSize = 1;
            app.ShotButton.Enable = 'off';
            app.ShotButton.Position = [590 320 120 50];
            app.ShotButton.Text = 'Shot';

            % Create PassButton
            app.PassButton = uibutton(app.UIFigure, 'push');
            app.PassButton.ButtonPushedFcn = createCallbackFcn(app, @PassButtonPushed, true);
            app.PassButton.Icon = 'pass.png';
            app.PassButton.IconAlignment = 'center';
            app.PassButton.FontSize = 1;
            app.PassButton.Enable = 'off';
            app.PassButton.Position = [780 320 110 50];
            app.PassButton.Text = 'Pass';

            % Create CardNum_player_1
            app.CardNum_player_1 = uilabel(app.UIFigure);
            app.CardNum_player_1.HorizontalAlignment = 'center';
            app.CardNum_player_1.FontSize = 14;
            app.CardNum_player_1.FontWeight = 'bold';
            app.CardNum_player_1.FontColor = [0.9412 0.9412 0.9412];
            app.CardNum_player_1.Position = [48.5 428 74 40];
            app.CardNum_player_1.Text = 'Not ready!';

            % Create backCard_player_1
            app.backCard_player_1 = uiimage(app.UIFigure);
            app.backCard_player_1.Position = [31 477 108 142];
            app.backCard_player_1.ImageSource = 'poker_back.jpg';

            % Create CardNum_player_2
            app.CardNum_player_2 = uilabel(app.UIFigure);
            app.CardNum_player_2.HorizontalAlignment = 'center';
            app.CardNum_player_2.FontWeight = 'bold';
            app.CardNum_player_2.FontColor = [1 1 1];
            app.CardNum_player_2.Position = [1165 427 65 40];
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
            app.CardNum_currplayer.HorizontalAlignment = 'center';
            app.CardNum_currplayer.FontSize = 14;
            app.CardNum_currplayer.FontWeight = 'bold';
            app.CardNum_currplayer.FontColor = [1 1 1];
            app.CardNum_currplayer.Position = [48.5 127 74 40];
            app.CardNum_currplayer.Text = 'Not ready!';

            % Create winLabel
            app.winLabel = uilabel(app.UIFigure);
            app.winLabel.HorizontalAlignment = 'center';
            app.winLabel.FontSize = 50;
            app.winLabel.FontColor = [1 0 0];
            app.winLabel.Visible = 'off';
            app.winLabel.Position = [474 516 352 65];
            app.winLabel.Text = {'AAAAA win !'; ''};

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [379 436 515 225];
            app.Image.ImageSource = 'doudizhu.png';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'center';
            app.Label.FontColor = [1 1 1];
            app.Label.Position = [1197 28 29 22];
            app.Label.Text = 'ÿÿ';

            % Create Switch
            app.Switch = uiswitch(app.UIFigure, 'slider');
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.FontColor = [1 1 1];
            app.Switch.Position = [1188 65 45 20];
            app.Switch.Value = 'On';

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