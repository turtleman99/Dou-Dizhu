classdef useCaseTest < matlab.uitest.TestCase
    properties
        player_0
        player_1
        player_2
        ge
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            import matlab.unittest.TestCase
            % Create instances of 'player'
            testCase.player_0 = player;
            testCase.player_1 = player;
            testCase.player_2 = player;

            % Create instances of 'pokerGameUI'
            % TODO: UI background
            player_0_UI = pokerGameUI;
            testCase.player_0.currUI = player_0_UI;
            testCase.player_0.currUI.currPlayer = testCase.player_0;

            player_1_UI = pokerGameUI;
            testCase.player_1.currUI = player_1_UI;
            testCase.player_1.currUI.currPlayer = testCase.player_1;

            player_2_UI = pokerGameUI;
            testCase.player_2.currUI = player_2_UI;
            testCase.player_2.currUI.currPlayer = testCase.player_2;

            % player_0.currUI.currPlayer = player_0;
            testCase.player_0.currUI.player_1 = testCase.player_1;
            testCase.player_0.currUI.player_2 = testCase.player_2;

            % player_1.currUI.currPlayer = player_1;
            testCase.player_1.currUI.player_1 = testCase.player_0;
            testCase.player_1.currUI.player_2 = testCase.player_2;

            % player_2.currUI.currPlayer = player_2;
            testCase.player_2.currUI.player_1 = testCase.player_0;
            testCase.player_2.currUI.player_2 = testCase.player_1;

            % Create the instance of pokerRule
            rule = pokerRule;

            % Create instance of 'gameEngine'
            testCase.ge = gameEngine;
            testCase.ge.bgm();
            testCase.ge.player_0 = testCase.player_0;
            testCase.ge.player_1 = testCase.player_1;
            testCase.ge.player_2 = testCase.player_2;
            testCase.ge.rule = rule;

            rule.gameEngine = testCase.ge;

            % set gameEngine to different UIs
            testCase.player_0.currUI.gameEngine = testCase.ge;
            testCase.player_1.currUI.gameEngine = testCase.ge;
            testCase.player_2.currUI.gameEngine = testCase.ge;
        end
    end
    
    methods (Test)
        function T1_1_1(testCase)
            %Tcover1.1.1.1
            testCase.press(testCase.player_0.currUI.ReadyButton);
            testCase.verifyEqual(testCase.ge.isStart, false);
            
            testCase.verifyEqual(testCase.player_0.currUI.CardNum_currplayer.Text, 'Ready');
            testCase.verifyEqual(testCase.player_1.currUI.CardNum_currplayer.Text, 'Ready');
            testCase.verifyEqual(testCase.player_2.currUI.CardNum_currplayer.Text, 'Ready');
            
            testCase.verifyEqual(testCase.player_0.currUI.ReadyButton.Visible, 'off');
        end
        
    end
end

