% Adriel

function D = get_best_result()
    %plt = false;
    %dir_path = "logs/results/"+dataset+"/multiple/";
    %file_name = "results_layer_2_single_1_fator_1_multiple_1_fator_1.mat";
    %
    %res = load(file_name)
    teste  = [0.5 0.5 0.7 0.8; 0 0.1 0.4 0.5];
    teste2 = [0.5 0.7 1 0.8; 0 0.1 0.4 0.5];
    teste3 = [0.5 1 0.7 0.8; 0 0.1 0.4 0.5];

    testes = {teste teste2 teste3};

    max_res = get_max_result(testes);

    


end

function max_res = get_max_result(testes)
    last_max = 0;
    last_max_idx = 0;

    for i = 1:length(testes)
        teste = cell2mat(testes(i));
        [max_value,max_idx] = max(teste(1,:));
        max_idxs = find(teste(1,:) == teste(1,max_idx));
        
        if(max_value > last_max)
            last_max = max_value;
            last_max_idx = max_idxs(end);
            max_res = i;
        elseif(max_idxs(end) > last_max_idx && max_value == last_max)
            last_max_idx = max_idxs(end);
            max_res = i;
        end
    end
end

