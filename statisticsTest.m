%Statistics Test

clear all;
classes = 8;

if classes == 4
    load logs\results\resume\resultsFilterLabelMe4
    results1 = [MeanArray MeanArray MeanArray MeanArray(1)];

    load logs\results\resume\resultsDeepPbSOMLabelMe4
    results2 = MeanArray;

    load logs\results\resume\resultsDeepTSOMLabelMe4
    results3 = MeanArray;
elseif classes == 8
    load logs\results\resume\resultsSOMTSOMLabelMe8
    results1 = MeanArray;

    load logs\results\resume\resultsDeepPbSOMLabelMe8
    results2 = MeanArray;

    load logs\results\resume\resultsDeepTSOMLabelMe8
    results3 = MeanArray;
    
elseif classes == 62
    load logs\results\resume\resultsSOMTSOMRIS
    results1 = MeanArray;

    load logs\results\resume\resultsDeepPbSOMRIS
    results2 = MeanArray;
    
end;

% [rho(1),pval(1)] = corr(results1',results2','Type','Spearman')
% [rho(2),pval(2)] = corr(results1',results3','Type','Spearman')
% [rho(3),pval(3)] = corr(results2',results3','Type','Spearman')
% 
% 
% [rhop(1),pvalp(1)] = corr(results1',results2','Type','Kendall')
% [rhop(2),pvalp(2)] = corr(results1',results3','Type','Kendall')
% [rhop(3),pvalp(3)] = corr(results2',results3','Type','Kendall')

if classes == 4 | classes == 8
    pFriedman(1) = friedman([results1',results2']);
    pFriedman(2) = friedman([results1',results3']);
    pFriedman(3) = friedman([results2',results3']);

    pWilcoxon(1) = ranksum(results1',results2');
    pWilcoxon(2) = ranksum(results1',results3');
    pWilcoxon(3) = ranksum(results2',results3');
elseif classes == 62
    pFriedman(1) = friedman([results1',results2']);
    pWilcoxon(1) = ranksum(results1',results2');
end;

%a = [1 1 1 1];
%b = [1 1.1 1.1 1.1];

%p(1) = kruskalwallis([a',b']);

%[rho(1),pval(1)] = corr(a',b','Type','Kendall')
%[rho(2),pval(2)] = corr(a',b','Type','Spearman')
%[rho(3),pval(3)] = corr(a',b','Type','Pearson')
%p(1) = friedman([a',b']);
