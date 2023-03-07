a = 1;

subplot(4,1,1);
plot(BMUsValuesKitchen(a,:));
title('Kitchen');

subplot(4,1,2);
plot(BMUsValuesBathroom(a,:));
title('Bathroom');

subplot(4,1,3);
plot(BMUsValuesBedroom(a,:));
title('Bedroom');

subplot(4,1,4);
plot(BMUsValuesOffice(a,:));
title('Office');

%%%%%%%%%%%%%
subplot(4,1,1);
plot(BMUsValues(1,:));

subplot(4,1,2);
plot(BMUsValues(2,:));

subplot(4,1,3);
plot(BMUsValues(71,:));

subplot(4,1,4);
plot(BMUsValues(72,:));
    

%%%%%%%%%%%%%%%%%%%%%%
a = 1;
col = 5;
row = 4;
subplot(col,row,a);
M = BMUsValuesBathroom;
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));
a = a+1;
subplot(col,row,a);
plot(M(a,:));


plot(1:1024,M(1,:),1:1024,M(2,:),1:1024,M(3,:),1:1024,M(4,:))


subplot(5,1,1);
plot(x);

subplot(5,1,2);
plot(M(1,:));

subplot(5,1,3);
plot(M(11,:));




% 
A = sum(X);
A = sum(A >= 1)


subplot(2,1,1);
plot(counts);
subplot(2,1,2);
plot(counts2);



%%%%%%%%%%
subplot(5,1,1);
plot(winners(1,:));
subplot(5,1,2);
plot(winners(2,:));
subplot(5,1,3);
plot(winners(3,:));
subplot(5,1,4);
plot(winners(4,:));
subplot(5,1,5);
plot(1:256, winners(1,:), 1:256, winners(2,:), 1:256, winners(3,:), 1:256, winners(4,:));

plot(1:1024, winners(1,:), 1:1024, winners(2,:), 1:1024, winners(3,:), 1:1024, winners(4,:));
plot(1:64, winners(1,:), 1:64, winners(2,:), 1:64, winners(3,:), 1:64, winners(4,:));



%%%%%%%%%%%%%%%%%%%

subplot(3,1,1);
plot(D(selected(55),:));
subplot(3,1,2);
plot(M(52,:));
subplot(3,1,3);
plot(M(40,:));

subplot(6,1,3);
plot(D(selected(6),:));
subplot(6,1,4);
plot(D(selected(8),:));
subplot(6,1,5);
plot(M(12,:));
subplot(6,1,6);
plot(M(7,:));