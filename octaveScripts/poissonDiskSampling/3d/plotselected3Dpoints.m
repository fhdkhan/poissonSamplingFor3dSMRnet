for i=526:729
  xx=sampledPoints(i,1);
  yy=sampledPoints(i,2);
  zz=sampledPoints(i,3);
  mesh(xx,yy,zz,'marker','+')
  hold on
  pause(0.1)
endfor