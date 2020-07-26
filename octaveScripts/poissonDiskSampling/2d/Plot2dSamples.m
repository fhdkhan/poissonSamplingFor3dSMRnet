close all
for i=1:size(sampledPoints,1)
  xx=sampledPoints(i,1);
  yy=sampledPoints(i,2);
  plot (xx, yy, "*");
  hold on
  scatter (xx, yy, "b","filled");
endfor
axis ([0, 11, 0, 11], "square");
set(gca, "linewidth", 2, "fontsize", 14)
print -dpdfcrop poissonGrid.pdf