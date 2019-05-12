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
    end

    
    properties (Access = private)
        % Three players
         currPlayer 
         player_1
         player_2
         gameEngine
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: ReadyButton
        function ReadyButtonValueChanged(app, event)
            value = app.ReadyButton.Value;
            app.currPlayer.isActive = true;
            app.ReadyButton.Visible = false;
            app.CardNum_currplayer.Text = 'Ready';
            % Display players' avatars
            app.avatar_currplayer.ImageSource = app.currPlayer.avatar;
            app.avatar_player_1.ImageSource = app.player_1.avatar;
            app.avatar_player_2.ImageSource = app.player_2.avatar;
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
            app.ShotButton.Icon = 'shot.png';
            app.ShotButton.IconAlignment = 'center';
            app.ShotButton.FontSize = 1;
            app.ShotButton.Position = [591 349 120 50];
            app.ShotButton.Text = 'Shot';

            % Create PassButton
            app.PassButton = uibutton(app.UIFigure, 'push');
            app.PassButton.Icon = 'pass.png';
            app.PassButton.IconAlignment = 'center';
            app.PassButton.FontSize = 1;
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