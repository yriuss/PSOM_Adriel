function   [new_means,new_converiances,new_P,log_p_self,liklihood] = GaussianMixtureLearningAll(x,means,converiances,liklihood,k,r)
keepLooping = true;
MaxIteration = 100;
logliklihoodThreshold = 10e-9;
logliklihoodThresNew = 0;
logliklihoodThresOld = 0;
count = 0;
log_p_self=[];

%%
    log_p= ComputeLogLiklihood(x,means,converiances,liklihood);
    logliklihoodThresNew = log_p;
    log_p_self=[log_p_self log_p];

%%
converiancess = converiances;
meanss = means;

logliklihoodThresOld = logliklihoodThresNew;

P = E_Step(x,liklihood,meanss,converiancess, 'yes');
    
new_means = meanss;
new_converiances = {converiances,converiancess};
new_P = P;
end