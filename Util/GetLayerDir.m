% Marcondes Ricarte

function dirLayer = GetLayerDir(Model, i)
    dirLayer = 0;
     if i == 1
        dirLayer = Model.dir.layer2;
     elseif i == 2
        dirLayer = Model.dir.layer3;
     elseif i == 3
        dirLayer = Model.dir.layer4;
     elseif i == 4
        dirLayer = Model.dir.layer5;
     end;

end