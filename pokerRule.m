classdef pokerRule < handle
    % properties of poker game rule
    properties
        % 'rocket', 'bomb',
        cardType = ["single", "pair", "trio", "trio_pair", "trio_single","seq_single5", "seq_single6", "seq_single7", "seq_single8", "seq_single9", "seq_single10", "seq_single11","seq_single12","seq_pair3", "seq_pair4", "seq_pair5", "seq_pair6", "seq_pair7", "seq_pair8", "seq_pair9", "seq_pair10","seq_trio2", "seq_trio3", "seq_trio4", "seq_trio5", "seq_trio6","seq_trio_pair2", "seq_trio_pair3", "seq_trio_pair4", "seq_trio_pair5","seq_trio_single2", "seq_trio_single3", "seq_trio_single4", "seq_trio_single5", 'bomb_pair', "bomb_single"];
        cardRule = jsondecode(fileread('rule.json'));
        compare_result % -3 -> found; -2 -> not found; -1 -> unkown type; 0 -> not bigger; >0 -> bigger
        gameEngine
    end
    
    % methods of poker game rule
    methods
        % return indx which represents magnitude
        function index_of(pkRule, typeName, ele)
            array = getfield(pkRule.cardRule, typeName);
            if (~(length(array{1}) == length(ele)))
                pkRule.compare_result = -2; % not found
                return;
            end

            len = length(array);
            for indx = 1:len
                if (strcmp(array{indx}, ele))
                    pkRule.gameEngine.cards_value_selected = indx;
                    pkRule.gameEngine.cards_type_selected = typeName;
                    pkRule.compare_result = -3; % found
                    return;
                end
            end
            % not found
            pkRule.compare_result = -2;
        end   
        % determine the cards type
        function card_type(pkRule, cards)
            len = length(pkRule.cardType);
            for i = 1 :len
                pkRule.index_of(pkRule.cardType{i}, cards);
                % if found
                if (pkRule.compare_result == -3)
                    return;
                end
            end
            if (pkRule.compare_result == -2)
                pkRule.compare_result = -1;
                pkRule.gameEngine.update;
                if (pkRule.gameEngine.player_0.currUI.currPlayer.myTurn == true)
                    pkRule.gameEngine.player_0.currUI.UnknownTypeLabel.Text = 'Unknown Type!';
                    pkRule.gameEngine.player_0.currUI.UnknownTypeLabel.Visible = true;
                elseif (pkRule.gameEngine.player_1.currUI.currPlayer.myTurn == true)
                    pkRule.gameEngine.player_1.currUI.UnknownTypeLabel.Text = 'Unknown Type!';
                    pkRule.gameEngine.player_1.currUI.UnknownTypeLabel.Visible = true;
                elseif (pkRule.gameEngine.player_2.currUI.currPlayer.myTurn == true)
                    pkRule.gameEngine.player_2.currUI.UnknownTypeLabel.Text = 'Unknown Type!';
                    pkRule.gameEngine.player_2.currUI.UnknownTypeLabel.Visible = true;
                end
                error('Unknown Card Type: %s', cards);
            end
        end
        % determine cards value: return cards type and value
        function cards_value(pkRule, cards)
            % check if rocket
            if (strcmp(cards, 'wW'))
                pkRule.gameEngine.cards_type_selected = 'rocket';
                pkRule.gameEngine.cards_value_selected = 2000;
                return;
            end
            % check if bomb
            pkRule.index_of('bomb', cards); 
            if (pkRule.compare_result == -3)    % found
                pkRule.gameEngine.cards_type_selected = 'bomb';
                pkRule.gameEngine.cards_value_selected = 1000 + pkRule.gameEngine.cards_value_selected;
                return;
            end
            % normal types
            pkRule.card_type(cards);
        end
        % compare the poker hands and set compare value
        function compare_poker(pkRule, preCards, selectedCards)
            
            % Before compareing, reset pkRule.compare_result;
            pkRule.compare_result = 0;
            
            % if one of turns is empty
            % TD: if pass two turns   -> done
            [rn, cardsNum] = size(selectedCards);
            selectedCards_str = [];
            for i = 1 : cardsNum
                selectedCards_str = [selectedCards_str, selectedCards{1, i}];
            end
            %######################### debugging #######################
            selectedCards_str
            %######################### debugging #######################
            
            pkRule.cards_value(selectedCards_str);
            
            if (or(isempty(preCards), isempty(selectedCards)))
                if isequal(preCards, selectedCards)
                    % c = 'c'
                    pkRule.compare_result = 0; % not bigger
                    return;
                end
                if (isempty(preCards))
                    pkRule.compare_result = 1; % bigger
                    return;
                end
                if (isempty(selectedCards))
                   pkRule.compare_result = 0;  % not bigger
                   return;
                end
            end        
            
            if (strcmp(pkRule.gameEngine.cards_type_selected, pkRule.gameEngine.cards_type_0))
                % care about the definition
                pkRule.compare_result = pkRule.gameEngine.cards_value_selected - pkRule.gameEngine.cards_value_0; 
                return;
            end
            if (pkRule.gameEngine.cards_value_selected >= 1000)
                if (pkRule.gameEngine.cards_value_0 < pkRule.gameEngine.cards_value_selected)
                    pkRule.compare_result = 1;
                end
                return;
            else
                pkRule.compare_result = 0;
                if (pkRule.gameEngine.player_0.currUI.currPlayer.myTurn == true)
                    pkRule.gameEngine.player_0.currUI.UnknownTypeLabel.Text = 'Not Bigger!';
                    pkRule.gameEngine.player_0.currUI.UnknownTypeLabel.Visible = true;
                elseif (pkRule.gameEngine.player_1.currUI.currPlayer.myTurn == true)
                    pkRule.gameEngine.player_1.currUI.UnknownTypeLabel.Text = 'Not Bigger!';
                    pkRule.gameEngine.player_1.currUI.UnknownTypeLabel.Visible = true;
                elseif (pkRule.gameEngine.player_2.currUI.currPlayer.myTurn == true)
                    pkRule.gameEngine.player_2.currUI.UnknownTypeLabel.Text = 'Not Bigger!';
                    pkRule.gameEngine.player_2.currUI.UnknownTypeLabel.Visible = true;
                end
                error('Not Bigger!');
                return;
            end
        end
    end
end