classdef ruleTest < matlab.uitest.TestCase    
    methods (Test)
        function ruleTest1(testCase)
            import matlab.unittest.TestCase
            import matlab.unittest.constraints.Throws

            % Create instances of 'player'
            player_0 = player;
            player_1 = player;
            player_2 = player;

            % Create instances of 'pokerGameUI'
            % TODO: UI background
            player_0_UI = pokerGameUI;
            player_0.currUI = player_0_UI;
            player_0.currUI.currPlayer = player_0;

            player_1_UI = pokerGameUI;
            player_1.currUI = player_1_UI;
            player_1.currUI.currPlayer = player_1;

            player_2_UI = pokerGameUI;
            player_2.currUI = player_2_UI;
            player_2.currUI.currPlayer = player_2;

            % player_0.currUI.currPlayer = player_0;
            player_0.currUI.player_1 = player_1;
            player_0.currUI.player_2 = player_2;

            % player_1.currUI.currPlayer = player_1;
            player_1.currUI.player_1 = player_0;
            player_1.currUI.player_2 = player_2;

            % player_2.currUI.currPlayer = player_2;
            player_2.currUI.player_1 = player_0;
            player_2.currUI.player_2 = player_1;

            % Create the instance of pokerRule
            rule = pokerRule_fTest1;

            % Create instance of 'gameEngine'
            ge = gameEngine_fTest1;
            ge.bgm();
            ge.player_0 = player_0;
            ge.player_1 = player_1;
            ge.player_2 = player_2;
            ge.rule = rule;

            rule.gameEngine = ge;

            % set gameEngine to different UIs
            player_0.currUI.gameEngine = ge;
            player_1.currUI.gameEngine = ge;
            player_2.currUI.gameEngine = ge;
            
            % START TEST
            % ready
            testCase.press(player_0_UI.ReadyButton);
            testCase.press(player_1_UI.ReadyButton);
            testCase.press(player_2_UI.ReadyButton);   
            
            % round 1
            testCase.verifyEqual(player_1_UI.PassButton.Enable,'off'); %T1.7.1
            
            [x,y] = ge.calcPosition(1,player_1);
            
            testCase.press(player_1.currUI.UIFigure,[x,y]);
            testCase.verifyEqual(player_1_UI.currPlayer.cards_img{1,1}.Position(1,2),52); %Tcover1.6.1.1
            testCase.press(player_1.currUI.UIFigure,[x,y+30]);
            testCase.verifyEqual(player_1_UI.currPlayer.cards_img{1,1}.Position(1,2),22); %Tcover1.6.1.2
            
            testCase.press(player_1.currUI.UIFigure,[x,y]);
            
            [x,y] = ge.calcPosition(2,player_1);
            testCase.press(player_1.currUI.UIFigure,[x,y]);
            [x,y] = ge.calcPosition(3,player_1);
            testCase.press(player_1.currUI.UIFigure,[x,y]);
            [x,y] = ge.calcPosition(4,player_1);
            testCase.press(player_1.currUI.UIFigure,[x,y]);
            testCase.press(player_1_UI.ShotButton);
            
            [x,y] = ge.calcPosition(3,player_2);
            testCase.press(player_2.currUI.UIFigure,[x,y]);
            [x,y] = ge.calcPosition(6,player_2);
            testCase.press(player_2.currUI.UIFigure,[x,y]);
            [x,y] = ge.calcPosition(7,player_2);
            testCase.press(player_2.currUI.UIFigure,[x,y]);
            [x,y] = ge.calcPosition(8,player_2);
            testCase.press(player_2.currUI.UIFigure,[x,y]);
            testCase.press(player_2_UI.ShotButton);
            
            testCase.press(player_0_UI.PassButton); %T1.7.2
            testCase.press(player_1_UI.PassButton);

            % round 2
            testCase.verifyEqual(player_2_UI.PassButton.Enable,'off'); %T1.7.3
            
            n = [3,4,6,7,8,9,10,11];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_2);
                testCase.press(player_2.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_2_UI.ShotButton);
            
            testCase.verifyEqual(ge.whoseTurn,0); %Tcover1.5.1.3
            
            n = [9,10,11,12,13,14,15,16,17];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_0);
                testCase.press(player_0.currUI.UIFigure,[x,y]);
            end
            testCase.verifyThat(@()testCase.press(player_0_UI.ShotButton),Throws(''));
            
            testCase.verifyEqual(player_0_UI.UnknownTypeLabel.Text, 'Unknown Type!');
            testCase.verifyEqual(player_0_UI.UnknownTypeLabel.Visible, 'on'); %Tcover1.6.2.1
            
            n = [9];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_0);
                testCase.press(player_0.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_0_UI.ShotButton);
            testCase.verifyEqual(player_0_UI.UnknownTypeLabel.Text, 'Not Bigger!');
            testCase.verifyEqual(player_0_UI.UnknownTypeLabel.Visible, 'on'); %Tcover1.6.2.2
            
            n = [10,11,12,13,14,15,16,17];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_0);
                testCase.press(player_0.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_0_UI.ShotButton);
            
            testCase.verifyEqual(ge.whoseTurn,1); %Tcover1.5.1.1
            
            testCase.press(player_1_UI.PassButton);
            
            testCase.verifyEqual(ge.whoseTurn,2); %Tcover1.5.1.2
            
            testCase.press(player_2_UI.PassButton);
            
            % round 3
            n = [5,6,7,8,9];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_0);
                testCase.press(player_0.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_0_UI.ShotButton);
            
            n = [8,9,10,11,12,13];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_1);
                testCase.press(player_1.currUI.UIFigure,[x,y]);
            end
            testCase.verifyThat(@()testCase.press(player_1_UI.ShotButton),Throws(''));
            
            n = [8,9,10,11,12];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_1);
                testCase.press(player_1.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_1_UI.ShotButton);
            
            testCase.press(player_2_UI.PassButton);
            testCase.press(player_0_UI.PassButton);
            
            % round 4
            n = [1,2,3,4,5,6];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_1);
                testCase.press(player_1.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_1_UI.ShotButton);
            
            testCase.press(player_2_UI.PassButton);
            testCase.press(player_0_UI.PassButton);
            
            % round 5
            n = [1];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_1);
                testCase.press(player_1.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_1_UI.ShotButton);
            
            [nr, shotNum] = size(ge.cards_shotted_0);
            mid = (shotNum + 1)/2;
            for i = 1 : shotNum
                testCase.verifyEqual(player_0_UI.currDispCards{1, fix(10.5-(i-mid))}.ImageSource, ge.cards_shotted_0{3, shotNum - i + 1});
                testCase.verifyEqual(player_0_UI.currDispCards{1, fix(10.5-(i-mid))}.Visible, 'on');
                testCase.verifyEqual(player_1_UI.currDispCards{1, fix(10.5-(i-mid))}.ImageSource, ge.cards_shotted_0{3, shotNum - i + 1});
                testCase.verifyEqual(player_1_UI.currDispCards{1, fix(10.5-(i-mid))}.Visible, 'on');
                testCase.verifyEqual(player_2_UI.currDispCards{1, fix(10.5-(i-mid))}.ImageSource, ge.cards_shotted_0{3, shotNum - i + 1});
                testCase.verifyEqual(player_2_UI.currDispCards{1, fix(10.5-(i-mid))}.Visible, 'on');
            end
            testCase.verifyEqual(player_1_UI.CardNum_currplayer.Text,'4');
            testCase.verifyEqual(player_0_UI.CardNum_player_1.Text,'4');
            testCase.verifyEqual(player_2_UI.CardNum_player_2.Text,'4');
            %Tcover1.6.2.3
            
            n = [5];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_2);
                testCase.press(player_2.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_2_UI.ShotButton);
            
            testCase.press(player_0_UI.PassButton);
            testCase.press(player_1_UI.PassButton);
            
            % round 6
            n = [1,2];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_2);
                testCase.press(player_2.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_2_UI.ShotButton);
            
            testCase.press(player_0_UI.PassButton);
            
            n = [1,2];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_1);
                testCase.press(player_1.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_1_UI.ShotButton);
            
            testCase.press(player_2_UI.PassButton);
            testCase.press(player_0_UI.PassButton);
            
            % round 7
            n = [1,2];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_1);
                testCase.press(player_1.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_1_UI.ShotButton);
            
            testCase.verifyEqual(ge.isEnd,true); %T1.8.1
            testCase.verifyEqual(ge.winner,0); %Tcover1.8.2.1
            
        end
        
        function ruleTest2(testCase)
            import matlab.unittest.TestCase
            import matlab.unittest.constraints.Throws

            % Create instances of 'player'
            player_0 = player;
            player_1 = player;
            player_2 = player;

            % Create instances of 'pokerGameUI'
            % TODO: UI background
            player_0_UI = pokerGameUI;
            player_0.currUI = player_0_UI;
            player_0.currUI.currPlayer = player_0;

            player_1_UI = pokerGameUI;
            player_1.currUI = player_1_UI;
            player_1.currUI.currPlayer = player_1;

            player_2_UI = pokerGameUI;
            player_2.currUI = player_2_UI;
            player_2.currUI.currPlayer = player_2;

            % player_0.currUI.currPlayer = player_0;
            player_0.currUI.player_1 = player_1;
            player_0.currUI.player_2 = player_2;

            % player_1.currUI.currPlayer = player_1;
            player_1.currUI.player_1 = player_0;
            player_1.currUI.player_2 = player_2;

            % player_2.currUI.currPlayer = player_2;
            player_2.currUI.player_1 = player_0;
            player_2.currUI.player_2 = player_1;

            % Create the instance of pokerRule
            rule = pokerRule_fTest1;

            % Create instance of 'gameEngine'
            ge = gameEngine_fTest2;
            ge.bgm();
            ge.player_0 = player_0;
            ge.player_1 = player_1;
            ge.player_2 = player_2;
            ge.rule = rule;

            rule.gameEngine = ge;

            % set gameEngine to different UIs
            player_0.currUI.gameEngine = ge;
            player_1.currUI.gameEngine = ge;
            player_2.currUI.gameEngine = ge;
            
            % START TEST
            % ready
            testCase.press(player_0_UI.ReadyButton);
            testCase.press(player_1_UI.ReadyButton);
            testCase.press(player_2_UI.ReadyButton);   
            
            % round 1
            n = [1,2];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_0);
                testCase.press(player_0.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_0_UI.ShotButton);
            
            testCase.press(player_1_UI.PassButton);
            
            n = [1,2];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_2);
                testCase.press(player_2.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_2_UI.ShotButton);
            
            testCase.press(player_0_UI.PassButton);
            testCase.press(player_1_UI.PassButton);
            
            % round 2
            n = [1,2,3,4,5,7,8];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_2);
                testCase.press(player_2.currUI.UIFigure,[x,y]);
            end
            testCase.verifyThat(@()testCase.press(player_2_UI.ShotButton),Throws(''));
            
            n = [1,2,3,4,5,6];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_2);
                testCase.press(player_2.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_2_UI.ShotButton);
            
            testCase.press(player_0_UI.PassButton);
            
            n = [3,4,5,6];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_1);
                testCase.press(player_1.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_1_UI.ShotButton);
            
            testCase.press(player_2_UI.PassButton);
            testCase.press(player_0_UI.PassButton);
            
            % round 3
            n = [3,4,5,6,7,8];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_1);
                testCase.press(player_1.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_1_UI.ShotButton);
            
            n = [1,2,3,4,5,6];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_2);
                testCase.press(player_2.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_2_UI.ShotButton);
            
            n = [9,10,11,12];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_0);
                testCase.press(player_0.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_0_UI.ShotButton);
            
            testCase.press(player_1_UI.PassButton);
            testCase.press(player_2_UI.PassButton);
            
            % round 4
            n = [1,2];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_0);
                testCase.press(player_0.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_0_UI.ShotButton);
            
            testCase.press(player_1_UI.PassButton);
            
            n = [2,3];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_2);
                testCase.press(player_2.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_2_UI.ShotButton);
            
            n = [13,14];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_0);
                testCase.press(player_0.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_0_UI.ShotButton);
            
            testCase.press(player_1_UI.PassButton);
            testCase.press(player_2_UI.PassButton);
            
            % round 5
            n = [2];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_0);
                testCase.press(player_0.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_0_UI.ShotButton);
            
            testCase.press(player_1_UI.PassButton);
            
            n = [1];
            for k = 1:length(n)
                [x,y] = ge.calcPosition(n(k),player_2);
                testCase.press(player_2.currUI.UIFigure,[x,y]);
            end
            testCase.press(player_2_UI.ShotButton);
            
            testCase.verifyEqual(ge.winner,1); %Tcover1.8.2.2
        end
    end
end

