% Adriel

function D = get_best_result(dataset)
    %plt = false;
    
    dir_path = "logs/results/"+dataset+"/multiple/pr/";
    files = dir(fullfile(dir_path, "pr_results_layer_*_single_*_fator_*_multiple_*_fator_*.mat"));
    
    file_names = string(1:length(files));

    for i = 1:length(files)
        file_name = string(files(i).name);
        file_names(i) = file_name;
    end

    
    pr = {};

    for i = 1:length(files)
        f = load(dir_path+file_names(i));
        pr = {pr f.points};
    end

    size(pr)
    error("paraar aqui")

    max_res = get_max_result(pr);

    D = max_res;


end

function max_res = get_max_result(pr)
    last_max = 0;
    last_max_idx = 0;

    for i = 1:length(pr)
        teste = cell2mat(pr(i));
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

