% Adriel

function max_res = get_best_result(dataset, plt)
    %plt = false;
    
    dir_path = "logs/results/"+dataset+"/multiple/pr/";
    files = dir(fullfile(dir_path, "pr_results_layer_*_single_*_fator_*_multiple_*_fator_*.mat"));
    
    file_names = string(1:length(files));

    for i = 1:length(files)
        file_name = string(files(i).name);
        file_names(i) = file_name;
    end

    
    pr = cell(1,length(file_names));

    for i = 1:length(files)
        f = load(dir_path+file_names(i));
        pr(i) = {f.points};
    end


    max_res = get_max_result(pr);

    if(plt)
        cols = [200 45 43; 37 64 180; 0 176 80; 0 0 0]/255;
        figure,hold on;
        plot(pr{max_res}(1,:), pr{max_res}(2,:), '-o', 'color', cols(1,:), 'linewidth', 2);
        axis([0 1 0 1]);
        xlabel('TPR (recall)'); ylabel('PPV (precision)'); title('PR curves');
        set(gca, 'box', 'on');
    end


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

