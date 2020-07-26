for i=1:size(sampledPoints,1)
  xx=sampledPoints(i,1);
  yy=sampledPoints(i,2);
  zz=sampledPoints(i,3);
  mesh(xx,yy,zz,'marker','+')
  hold on
endfor