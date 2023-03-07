% Marcondes Ricarte

database = '15_Scenes'; % 'LabelMe_8', '15_Scenes'

[len,~] = size(data);
s = 50*ones(len,1); 

c = [];
if strcmp(database,'LabelMe_8')
    for i= 1:len
        if cell2mat(data(i,9)) > 0.0038 && cell2mat(data(i,9)) < 0.0040 ...
                && cell2mat(data(i,10)) > 0.0012 && cell2mat(data(i,10)) < 0.0014
            index = 1;
        elseif cell2mat(data(i,9)) > 0.0038 && cell2mat(data(i,9)) < 0.0040 ...
                && cell2mat(data(i,10)) > 0.0024 && cell2mat(data(i,10)) < 0.0026
            index = 2;
        elseif cell2mat(data(i,9)) > 0.0019 && cell2mat(data(i,9)) < 0.0021 ...
                && cell2mat(data(i,10)) > 0.0012 && cell2mat(data(i,10)) < 0.0014
            index = 3;
        end;
        c = [c; index];
    end;
elseif strcmp(database,'15_Scenes')
    for i= 1:len
        if cell2mat(data(i,9)) > 0.0090 && cell2mat(data(i,9)) < 0.0110 ...
                && cell2mat(data(i,10)) > 0.0038 && cell2mat(data(i,10)) < 0.0040
            index = 1;
        elseif cell2mat(data(i,9)) > 0.0090 && cell2mat(data(i,9)) < 0.0110 ...
                && cell2mat(data(i,10)) > 0.0077 && cell2mat(data(i,10)) < 0.0079
            index = 2;
        elseif cell2mat(data(i,9)) > 0.0040 && cell2mat(data(i,9)) < 0.0060 ...
                && cell2mat(data(i,10)) > 0.0038 && cell2mat(data(i,10)) < 0.0040
            index = 3;
        end;
        c = [c; index];
    end;
end;




hFig = figure();
axh = axes('Parent', hFig);
hold(axh, 'all');
h1 = scatter3(cell2mat(data(find(c == 1),8)),cell2mat(data(find(c == 1),11)),cell2mat(data(find(c == 1),17)),'MarkerEdgeColor','b')
h2 = scatter3(cell2mat(data(find(c == 2),8)),cell2mat(data(find(c == 2),11)),cell2mat(data(find(c == 2),17)),'MarkerEdgeColor','g')
h3 = scatter3(cell2mat(data(find(c == 3),8)),cell2mat(data(find(c == 3),11)),cell2mat(data(find(c == 3),17)),'MarkerEdgeColor','r')
view(axh, -33, 22);
grid(axh, 'on');
xlabel('epochs')
ylabel('neighborhood')
zlabel('accuracy')
title('acurracy (test)') 
legend(axh, [h1,h2,h3], {'(1/#samples)-(1/#dimension)','(1/#samples)-(2/#dimension)','(0.5/#samples)-(1/#dimension)'});
saveas(gcf,'parameters_accuracy_test.png');


hFig = figure();
axh = axes('Parent', hFig);
hold(axh, 'all');
h1 = scatter3(cell2mat(data(find(c == 1),8)),cell2mat(data(find(c == 1),11)),cell2mat(data(find(c == 1),19)),'MarkerEdgeColor','b')
h2 = scatter3(cell2mat(data(find(c == 2),8)),cell2mat(data(find(c == 2),11)),cell2mat(data(find(c == 2),19)),'MarkerEdgeColor','g')
h3 = scatter3(cell2mat(data(find(c == 3),8)),cell2mat(data(find(c == 3),11)),cell2mat(data(find(c == 3),19)),'MarkerEdgeColor','r')
view(axh, -33, 22);
grid(axh, 'on');
xlabel('epochs')
ylabel('neighborhood')
zlabel('accuracy')
title('acurracy (train)') 
legend(axh, [h1,h2,h3], {'(1/#samples)-(1/#dimension)','(1/#samples)-(2/#dimension)','(0.5/#samples)-(1/#dimension)'});
saveas(gcf,'parameters_accuracy_train.png');





hFig = figure();
axh = axes('Parent', hFig);
hold(axh, 'all');
h1 = scatter3(cell2mat(data(find(c == 1),8)),cell2mat(data(find(c == 1),11)),cell2mat(data(find(c == 1),15)),'MarkerEdgeColor','b')
h2 = scatter3(cell2mat(data(find(c == 2),8)),cell2mat(data(find(c == 2),11)),cell2mat(data(find(c == 2),15)),'MarkerEdgeColor','g')
h3 = scatter3(cell2mat(data(find(c == 3),8)),cell2mat(data(find(c == 3),11)),cell2mat(data(find(c == 3),15)),'MarkerEdgeColor','r')
view(axh, -33, 22);
grid(axh, 'on');
xlabel('epochs')
ylabel('neighborhood')
zlabel('gap')
title('gap (test)') 
legend(axh, [h1,h2,h3], {'(1/#samples)-(1/#dimension)','(1/#samples)-(2/#dimension)','(0.5/#samples)-(1/#dimension)'});
saveas(gcf,'parameters_gap_test.png');



hFig = figure();
axh = axes('Parent', hFig);
hold(axh, 'all');
h1 = scatter3(cell2mat(data(find(c == 1),8)),cell2mat(data(find(c == 1),11)),cell2mat(data(find(c == 1),16)),'MarkerEdgeColor','b')
h2 = scatter3(cell2mat(data(find(c == 2),8)),cell2mat(data(find(c == 2),11)),cell2mat(data(find(c == 2),16)),'MarkerEdgeColor','g')
h3 = scatter3(cell2mat(data(find(c == 3),8)),cell2mat(data(find(c == 3),11)),cell2mat(data(find(c == 3),16)),'MarkerEdgeColor','r')
view(axh, -33, 22);
grid(axh, 'on');
xlabel('epochs')
ylabel('neighborhood')
zlabel('gap')
title('gap (train)') 
legend(axh, [h1,h2,h3], {'(1/#samples)-(1/#dimension)','(1/#samples)-(2/#dimension)','(0.5/#samples)-(1/#dimension)'});
saveas(gcf,'parameters_gap_train.png');