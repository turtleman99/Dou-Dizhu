classdef pokerRule < handle
    % properties of poker game rule
    properties
        % 'rocket', 'bomb',
        cardType = ["single", "pair", "trio", "trio_pair", "trio_single","seq_single5", "seq_single6", "seq_single7", "seq_single8", "seq_single9", "seq_single10", "seq_single11","seq_single12","seq_pair3", "seq_pair4", "seq_pair5", "seq_pair6", "seq_pair7", "seq_pair8", "seq_pair9", "seq_pair10","seq_trio2", "seq_trio3", "seq_trio4", "seq_trio5", "seq_trio6","seq_trio_pair2", "seq_trio_pair3", "seq_trio_pair4", "seq_trio_pair5","seq_trio_single2", "seq_trio_single3", "seq_trio_single4", "seq_trio_single5","bomb_pair", "bomb_single"];
        cardRule = jsondecode(fileread('rule.json'));
        compare_result
        gameEngine
    end
    
    % methods of poker game rule
    methods
        % return indx which represents magnitude
        function index_of(pkRule, typeName, ele)
            array = getfield(pkRule.cardRule, typeName);
            if (~(length(array) == length(ele)))
                pkRule.gameEngine.cards_value_1 = -1;
                return;
            end
            len = length(array);
            for indx = 1:len
                if (array{indx} == ele)
                    pkRule.gameEngine.cards_value_1 = indx;
                    pkRule.gameEngine.cards_type_1 = typeName;
                    return;
                end
            end
            pkRule.gameEngine.cards_value_1 = -1;
        end
        
        % determine the cards type
        function card_type(pkRule, cards)
            len = length(pkRuleule.cardType);
            for i = 1 :len
                pkRule.index_of(pkRule.cardType{i}, cards);
                if (pkRule.gameEngine.cards_value_1 < 0)
                    error('Unknown Card Type: %s', cards);
                end
            end
        end
        % determine cards value: return cards type and value
        function cards_value(pkRule, cards)
            [rn, cardsNum] = size(cards);
            cards_str = [];
            for i = 1 : cardsNum
                cards_str = [cards_str, cards{1, i}];
            end
            % check if rocket
            if (cards_str == 'wW')
                pkRule.gameEngine.cards_type_1 = 'rocket';
                pkRule.gameEngine.cards_value_1 = 2000;
                return;
            end
            % check if bomb
            pkRule.index_of('bomb', cards_str); 
            if (cardsValue >= 0)
                pkRule.gameEngine.cards_type_1 = 'bomb';
                pkRule.gameEngine.cards_value_1 = 1000 + pkRule.gameEngine.cards_value_1;
                return;
            end
            % normal types
            pkRule.card_type(cards);
        end
        % compare the poker hands and set compare value
        function compare_poker(pkRule, preCards, currCards)
            % if one of turn is empty
            % TD: if pass two turns
            if (isempty(preCards) || isempty(currCards))
                if isequal(preCards, currCards)
                    pkRule.compare_result = 0;
                end
                if (~isempty(preCards))
                    pkRule.compare_result = 1;
                end
                if (~isempty(currCards))
                    pkRule.compare_result = 1;
                end
            end
            pkRule.cards_value(currCards);
            if (pkRule.gameEngine.cards_type_1 == pkRule.gameEngine.cards_type_0)
                % care about the definition
                pkRule.compare_result = pkRule.gameEngine.cards_value_1 - pkRule.gameEngine.cards_value_0; 
                return;
            end
            if (pkRule.gameEngine.cards_type_1 >= 1000)
                pkRule.compare_result = 1;
            else
                pkRule.compare_result = 0;
            end
        end
    end
end