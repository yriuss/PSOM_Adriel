function [variance] = plotVariance(variance, variancePipeline, varianceBinary, y, dim, dimX)


    subplot(3,1,1)
    plot(1:dim, variance{1}, 'color', 'blue')
    hold on
    plot(1:dim, variancePipeline{1}, 'color', 'red')
    plot(1:dim, varianceBinary{1}, 'color', 'yellow')
    plot(1:dim, repmat(mean(variance{1}), 1, dim), 'color', 'blue', 'LineStyle', '--')
    plot(1:dim, repmat(mean(variancePipeline{1}), 1, dim), 'color', 'red', 'LineStyle', '--')
    plot(1:dim, repmat(mean(varianceBinary{1}), 1, dim), 'color', 'yellow', 'LineStyle', '--')
    hold off
    xlabel('Attibutes')
    ylabel('Variance')
    axis([0 dimX 0 y])
    legend('Inter','Var Pipeline','Var Pipeline Binária', 'Média Inter','Média Var Pipeline','Média Var Pipeline Binária')
    title([ 'Categoria 1 - Media Inter: ' num2str(mean(variance{1})) ' Média Var Pipeline: ' num2str(mean(variancePipeline{1})) ' Média Var Pipeline Binária: ' num2str(mean(varianceBinary{1}))  ] )  
    subplot(3,1,2)
    plot(1:dim, variance{2}, 'color', 'blue')
    hold on
    plot(1:dim, variancePipeline{2}, 'color', 'red')
    plot(1:dim, varianceBinary{2}, 'color', 'yellow')
    plot(1:dim, repmat(mean(variance{2}), 1, dim), 'color', 'blue', 'LineStyle', '--')
    plot(1:dim, repmat(mean(variancePipeline{2}), 1, dim), 'color', 'red', 'LineStyle', '--')
    plot(1:dim, repmat(mean(varianceBinary{2}), 1, dim), 'color', 'yellow', 'LineStyle', '--')
    hold off
    xlabel('Attibutes')
    ylabel('Variance')
    axis([0 dimX 0 y])
    legend('Inter','Var Pipeline','Var Pipeline Binária', 'Média Inter','Média Var Pipeline','Média Var Pipeline Binária')
    title([ 'Categoria 2 - Media Inter: ' num2str(mean(variance{2})) ' Média Var Pipeline: ' num2str(mean(variancePipeline{2})) ' Média Var Pipeline Binária: ' num2str(mean(varianceBinary{2}))  ] )  
    subplot(3,1,3)
    plot(1:dim, variance{3}, 'color', 'blue')
    hold on
    plot(1:dim, variancePipeline{3}, 'color', 'red')
    plot(1:dim, varianceBinary{3}, 'color', 'yellow')
    plot(1:dim, repmat(mean(variance{3}), 1, dim), 'color', 'blue', 'LineStyle', '--')
    plot(1:dim, repmat(mean(variancePipeline{3}), 1, dim), 'color', 'red', 'LineStyle', '--')
    plot(1:dim, repmat(mean(varianceBinary{3}), 1, dim), 'color', 'yellow', 'LineStyle', '--')
    hold off
    xlabel('Attibutes')
    ylabel('Variance')
    axis([0 dimX 0 y])
    legend('Inter','Var Pipeline','Var Pipeline Binária', 'Média Inter','Média Var Pipeline','Média Var Pipeline Binária')
    title([ 'Categoria 3 - Media Inter: ' num2str(mean(variance{2})) ' Média Var Pipeline: ' num2str(mean(variancePipeline{3})) ' Média Var Pipeline Binária: ' num2str(mean(varianceBinary{3}))  ] )



end