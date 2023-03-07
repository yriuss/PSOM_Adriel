% Marcondes Ricarte

clear all;


load('norm4200'); % ['norm', 'norm4200']
[samples, attributes] = size(SamplesTrain.data); 

labels = unique(SamplesTrain.labels)
lenLabels = length(labels);
Model.fatorSigma = 0.05; 


disp('No normalize...');
hist(SamplesTrain.data,100)
title('Histograma dos dados sem normalização');
saveas( gcf, ['histograma_dados_sem_normalizacao.png'] );


for i = 1:lenLabels
    data = SamplesTrain.data(strcmp(labels(i),SamplesTrain.labels),:);
    meanData = mean(data);
    stem(meanData,'MarkerSize',2)
    title(['Média não normalizada (zoom) para categoria ', int2str(i)]);
    saveas( gcf, ['media_nao_normalizada_zoom_categoria_' int2str(i) '.png'] );       
    stem(meanData,'MarkerSize',2)
    axis([0 attributes 0 1]);
    title(['Média não normalizada para categoria ', int2str(i)]);
    saveas( gcf, ['media_nao_normalizada_categoria_' int2str(i) '.png'] );       
end;
    

disp('Normalize samples...');
low = min(SamplesTrain.data');
high = max(SamplesTrain.data');

[row,col] = size(SamplesTrain.data);

normalizeSamples = zeros(row,col);
for i = 1:row
	for j = 1:col
		normalizeSamples(i,j) = (SamplesTrain.data(i,j)-low(i))/(high(i)-low(i));
	end;
end;

hist(normalizeSamples,100)
title('Histograma dos dados normalizados por amostra');
saveas( gcf, ['histograma_dados_normalizado_amostra.png'] );


for i = 1:lenLabels
    data = normalizeSamples(strcmp(labels(i),SamplesTrain.labels),:);
    meanData = mean(data);
    stem(meanData,'MarkerSize',2)
    axis([0 attributes 0 1]);
    title(['Média normalizada por amostra para categoria ', int2str(i)]);
    saveas( gcf, ['media_normalizado_amostra_categoria_' int2str(i) '.png'] );       
end;


disp('Normalize attributes...');
low = min(SamplesTrain.data);
high = max(SamplesTrain.data);

[row,col] = size(SamplesTrain.data);

normalizeAtributes = zeros(row,col);
for i = 1:row
	for j = 1:col
		normalizeAtributes(i,j) = (SamplesTrain.data(i,j)-low(j))/(high(j)-low(j));
	end;
end;

hist(normalizeAtributes,100)
title('Histograma normalização por atributos');
saveas( gcf, ['histograma_dados_normalizado_atributos.png'] );


for i = 1:lenLabels
    data = normalizeAtributes(strcmp(labels(i),SamplesTrain.labels),:);
    meanData = mean(data);
    stem(meanData,'MarkerSize',2)
    axis([0 attributes 0 1]);
    title(['Média normalizada por atributos para categoria ', int2str(i)]);
    saveas( gcf, ['media_normalizado_atributos_categoria_' int2str(i) '.png'] );       
end;




disp('Normalize attributes (standard deviation)...');
[normalizeAtributesStandardDeviation,normalizeAtributesStandardDeviation2] = ...
            NormalizeData(SamplesTrain.data, SamplesTrain.data, 'attributes_standard_deviation');

hist(normalizeAtributesStandardDeviation,100)
title('Histograma normalização por atributos (Desvio padrão)');
saveas( gcf, ['histograma_dados_normalizado_atributos_desvio_padrao.png'] );


for i = 1:lenLabels
    data = normalizeAtributesStandardDeviation(strcmp(labels(i),SamplesTrain.labels),:);
    meanData = mean(data);
    stem(meanData,'MarkerSize',2)
    axis([0 attributes -3 3]);
    title(['Média normalizada (desvio padrão) por atributos para categoria ', int2str(i)]);
    saveas( gcf, ['media_normalizado_atributos_desvio_padrao_categoria_' int2str(i) '.png'] );       
end;




disp('Normalize attributes with filter...');
[normalizeAtributesFilter,normalizeAtributesFilter] = ...
            NormalizeData(Model, SamplesTrain.data, SamplesTrain.data, 'attributes_filter');

hist(normalizeAtributesFilter,100)
title('Histograma normalização por atributos com filtro');
saveas( gcf, ['histograma_dados_normalizado_atributos_desvio_padrao_com_filtro.png'] );


for i = 1:lenLabels
    data = normalizeAtributesFilter(strcmp(labels(i),SamplesTrain.labels),:);
    meanData = mean(data);
    stem(meanData,'MarkerSize',2)
    axis([0 attributes 0 1]);
    title(['Média normalizada por atributos com filtro para categoria ', int2str(i)]);
    saveas( gcf, ['media_normalizado_atributos_com_filtro_categoria_' int2str(i) '.png'] );       
end;




disp('Normalize attributes with filter (pos)...');
[normalizeAtributesPosFilter,normalizeAtributesPosFilter] = ...
            NormalizeData(Model, SamplesTrain.data, SamplesTrain.data, 'attributes_pos_filter');

hist(normalizeAtributesPosFilter,100)
title('Histograma normalização por atributos com filtro (pos)');
saveas( gcf, ['histograma_dados_normalizado_atributos_pos_filtro.png'] );


for i = 1:lenLabels
    data = normalizeAtributesPosFilter(strcmp(labels(i),SamplesTrain.labels),:);
    meanData = mean(data);
    stem(meanData,'MarkerSize',2)
    axis([0 attributes 0 1]);
    title(['Média normalizada por atributos pos filtro para categoria ', int2str(i)]);
    saveas( gcf, ['media_normalizado_atributos_pos_filtro_categoria_' int2str(i) '.png'] );       
end;



% Print
