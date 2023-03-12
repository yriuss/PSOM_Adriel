% Adriel

function D = gen_PR(dataset)

    dir_path = "logs/results/"+dataset+"/multiple/";
    files = dir(fullfile(dir_path, "results_layer_*_single_*_fator_*_multiple_*_fator_*.mat"));
    
    file_names = string(1:length(files));


    for i = 1:length(files)
        file_name = string(files(i).name);
        file_names(i) = dir_path+file_name;
    end


    for i = 1:length(file_names)
        res = load(file_names(i));
        [~,best_idx] = max(res.Model.test.layer{2}.scoreTest);
        var = res.Model.test.layer{2}.dataTest{best_idx};
        
        parts = strsplit(dataset, '_');
        last_part = parts{end};
        new_string = strrep(dataset, "_"+last_part, '');
        %get labels
        labels = readtable("database/"+new_string+"/"+upper(last_part)+"_sequence2.csv");
        labels = labels(:,size(labels,2));
        Array = table2cell(labels);
        Cat = categorical(Array);
        labels = double(Cat);

        % get max for each image
        [best,best_idx] = max(var,[],2);

        best_class = fix(best_idx./4) + 1;
        best_class(best_class == 16) = 15;

        for i = 1:size(var,1)
            var(i, best_class(i)*4 - 3:best_class(i)*4) = NaN;
        end

        [sec_best,secbest_idx] = max(var,[],2);

        scores = sec_best./best;
        n = length(scores);

        [dvs_sorted,idx] = sort(scores,'descend');

        predicted_sorted = best_class(idx);
        targs_sorted = labels(idx);

        % Inititalize accumulators
        TPR = repmat(NaN,1,n+1);
        FPR = repmat(NaN,1,n+1);
        PPV = repmat(NaN,1,n+1);

        % Now slide the threshold along the decision values (the threshold
        % always lies in between two values; here, the threshold represents the
        % decision value immediately to the right of it)
        fn = zeros(size(predicted_sorted));
        for thr = 1:length(dvs_sorted)+1
            % values greater than thr are positive and smaller than thr are NaN
            TP = sum(abs(targs_sorted(thr:end)-predicted_sorted(thr:end))<2);%you have to match whether  trgs(i) == dvs(i)
            FN = sum(~isnan(targs_sorted(1:thr-1)));
            TN = sum(isnan(targs_sorted(1:thr-1)));
            FP = sum(abs(targs_sorted(thr:end)-predicted_sorted(thr:end))>=2);

            TPR(thr) = TP/(TP+FN);%recall
            FPR(thr) = FP/(FP+TN);
            PPV(thr) = TP/(TP+FP);%precision
        end

        cols = [200 45 43; 37 64 180; 0 176 80; 0 0 0]/255;
        figure,hold on;
        plot(TPR, PPV, '-o', 'color', cols(1,:), 'linewidth', 2);
        axis([0 1 0 1]);
        xlabel('TPR (recall)'); ylabel('PPV (precision)'); title('PR curves');
        set(gca, 'box', 'on');

        points = [TPR;PPV];
        save("logs/results/"+dataset+"/multiple/"+file_names+"_pr"+".mat",'points')

        error("djklsa")
    end
end