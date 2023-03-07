% Marcondes Ricarte

function [means] = plotDistributionCategoryPipeline(label, Model, DeepSOM, Layer, numClass, dataView1, dataView2, dataView3, dataView4)

   means = [];
   if strcmp(Model.flagPlotDistributions,'yes') 
       dirLayer = [];
       len = length(DeepSOM);
       if len == 8
           sizeI = 4;
           sizeJ = 2;
       elseif len == 15
           sizeI = 4;
           sizeJ = 4;
       end;
       for i=1:numClass 
           indexs = getOtherIndexs(i, DeepSOM);
           for j = 1:Layer
                means = [];
                dirLayer = GetLayerDir(Model,j);
                if j == 1
                    for k = 1:numClass
                        means = [means; mean(dataView1(DeepSOM{k}.indexsTrain,:))];
                    end;                
                elseif j == 2
                    for k = 1:numClass
                        means = [means; mean(dataView2(DeepSOM{k}.indexsTrain,:))];
                    end;
                elseif j == 3
                    for k = 1:numClass
                        means = [means; mean(dataView3(DeepSOM{k}.indexsTrain,:))];
                    end;
                elseif j == 4
                    for k = 1:numClass
                        means = [means; mean(dataView4(DeepSOM{k}.indexsTrain,:))];
                    end;                
                end;


                if i == 1 
                    for k = 1:sizeI
                        for m = 1:sizeJ
                            if 4*(k-1)+m <= len
                                subplot(sizeI,sizeJ,sizeJ*(k-1)+m)
                                %if 4*(k-1)+m == i
                                %    stem(means(4*(k-1)+m,:),'MarkerSize',1,'Color','red')
                                %else
                                stem(means(4*(k-1)+m,:),'MarkerSize',1)
                                hold on
                                stem(((4*(k-1)+m-1)*Model.numMap(j)+1:((4*(k-1)+m)*Model.numMap(j))),means(4*(k-1)+m,((4*(k-1)+m-1)*Model.numMap(j)+1:((4*(k-1)+m)*Model.numMap(j)))),'MarkerSize',1,'Color','red')
                                hold off
                                %end;
                                xlabel('nodos')
                                ylabel('ativação')
                                title(['Categoria ' num2str(4*(k-1)+m)])
                                axis([0 (Model.numMap(j)*len) 0 1]);                 % TODO   
                            end;
                        end;
                    end;
                    saveas( gcf, [dirLayer Model.dir.categories label '_concat_category' num2str(i) '.png']);
                end;

                for k = 1:sizeI
                    for m = 1:sizeJ
                        if 4*(k-1)+m <= len
                            subplot(sizeI,sizeJ,4*(k-1)+m)
                            if 4*(k-1)+m == i
                                stem(means(4*(k-1)+m,((i-1)*Model.numMap(j)+1):(i*Model.numMap(j))),'MarkerSize',1,'Color','red')
                            else
                                stem(means(4*(k-1)+m,((i-1)*Model.numMap(j)+1):(i*Model.numMap(j))),'MarkerSize',1)
                            end;
                            xlabel('nodos')
                            ylabel('ativação')
                            title(['Categoria ' num2str(4*(k-1)+m)])
                            axis([0 (Model.numMap(j)+1) 0 1]);                 % TODO   
                        end;
                    end;
                end;
                saveas( gcf, [dirLayer Model.dir.categories label '_category' num2str(i) '.png']);

            end;
       end;
   end;


end