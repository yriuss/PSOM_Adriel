function [means,converiances] = intialization_step(intailization_strategy,x,k,i,SOMmeans)


sizeX = size(x,1);
if(intailization_strategy == 1)
    %randomnly select centroids from data
    centeroid_idx = datasample(1:sizeX,k,'Replace',false);
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %{
    m=1;
    n=0;
   if strcmp(file_used,file_Name1)
       inc=800;
   else
       inc = 500;
   end
   
    for i=1:k
       m=(i-1)*inc+1;
       n=i*inc;
    centeroid_idx(i) = datasample(m:n,1,'Replace',false);
    end
    %%%%%%%%%%%%%%%
    %}
    centeroid_idx = sort(centeroid_idx);
    means = x(centeroid_idx,:);
    overall_convariance = cov(x);
    for j = 1:k
        converiances{j} = overall_convariance/k;
    end
    
elseif(intailization_strategy == 2)
    
    centeroid_idx = datasample(1:sizeX,k,'Replace',false);
    centeroid_idx_keeper{i} = centeroid_idx;
    disp('final membership: ')
    centeroid_idx = sort(centeroid_idx);
    
    [finalmembership,finalcentroids,numOfIterations] = KMEANS_Part1(x,centeroid_idx,i);
    
    means = finalcentroids;
  
    
    for j = 1:k
        converiances{j} = cov(x(finalmembership==j,:));
    end
elseif(intailization_strategy == 3)
    means = SOMmeans;
    [~,dim] = size(SOMmeans);
    finalmembership = returnMemberShip(x,means);
    for j = 1:k
        if sum(finalmembership==j) ~= 0
            converiances{j} = cov(x(finalmembership==j,:));
        else
            converiances{j} = zeros(dim,dim);
        end;
    end
end
end
