
len = length(Model.test.layer{3}.compareTest{i}); 
for i = 1:10
    sta(i) = 1-(sum(Model.test.layer{2}.compareTest{1} == Model.test.layer{3}.compareTest{i})/len);
end;
mean(sta)
std(sta)

%%%% mean
len = length(Model.test.layer{3}.compareTest{i}); 
for i = 1:len   
    cont = 0;
    for j = 1:10        
        if Model.test.layer{3}.compareTest{j}(i) == 1
            cont = cont + 1
        end;
    end; 
    conts(i) = cont; 
end;

for i = 1:len
    if conts(i) > 0 && conts(i) < 10
        conts(i) = 1; 
    elseif conts(i) == 10
        conts(i) = 2;
    end;
end;


% first
find(Model.test.layer{3}.compareTrain{1} == 0); 
find(Model.test.layer{3}.compareTrain{1} == 1); 
find(Model.test.layer{3}.compareTest{1} == 0); 
find(Model.test.layer{3}.compareTest{1} == 1); 

