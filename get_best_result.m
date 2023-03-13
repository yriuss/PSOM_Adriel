% Adriel

function D = get_best_result(dataset)
    %plt = false;
    
    dir_path = "logs/results/"+dataset+"/multiple/";
    files = dir(fullfile(dir_path, "results_layer_*_single_*_fator_*_multiple_*_fator_*.mat"));
    
    file_names = string(1:length(files));

    for i = 1:length(files)
        file_name = string(files(i).name);
        file_names(i) = file_name;
    end

    file_names


    error("parar aqui")
    teste  = [0.5 0.5 0.7 0.8; 0 0.1 0.4 0.5];
    teste2 = [0.5 0.7 1 0.8; 0 0.1 0.4 0.5];
    teste3 = [0.5 1 0.7 0.8; 0 0.1 0.4 0.5];

    testes = {teste teste2 teste3};

    max_res = get_max_result(testes);

    D = max_res;


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
