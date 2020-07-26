close all
x = 2:2:10;
y = x;
xx = repmat(x,1,5);
yy = repmat(y,5,1)
yy = yy(yy!=0)'; 

plot (xx, yy, "*");
hold on
scatter (xx, yy, "b","filled");
axis ([0, 11, 0, 11], "square");


set(gca, "linewidth", 2, "fontsize", 14)
print -dpdfcrop equiGrid.pdf
