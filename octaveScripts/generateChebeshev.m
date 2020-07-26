close all
x = -1:0.01:1;
cheb0 = 1.;
cheb1 = (2*x);
cheb2 = (4*x.**2-1);
cheb3 = (8*x.**3-4*x);
cheb4 = (16*x.**4-12*x.**2+1);
cheb5 = (32*x.**5-32*x.**3+6*x);
cheb6 = (64*x.**6-80*x.**4+24*x.**2-1);
close all
plot (x,cheb2,"linewidth", 2)
hold on
plot (x,cheb3,"linewidth", 2)
plot (x,cheb4,"linewidth", 2)
plot (x,cheb5,"linewidth", 2)
plot (x,cheb6,"linewidth", 2)
axis ([-1, 1, -3, 3]);
l = legend("n=2","n=3","n=4","n=5","n=6");
set (l, "fontsize", 14);
set(gca, "linewidth", 2, "fontsize", 14)

#cheb2_2d_x = repmat(cheb2,[size(cheb2,2),1]);
#cheb2_2d_x = resize(cheb2_2d_x,size(cheb2_2d_x)+50);
#cheb2_2d_x = resize(rot90(flip(cheb2_2d_x,1)),size(cheb2_2d_x)+50);
#cheb2_2d_y = cheb2_2d_x';
#figure(), imshow(cheb2_2d_x)
#figure(), imshow(cheb2_2d_y)
#figure(),imshow(cheb2_2d_x.*cheb2_2d_y./DIV)

#cheb3_2d_x = repmat(cheb3,[size(cheb3,2),1]);
#cheb3_2d_x = resize(cheb3_2d_x,size(cheb3_2d_x)+50);
#cheb3_2d_x = resize(rot90(flip(cheb3_2d_x,1)),size(cheb3_2d_x)+50);
#cheb3_2d_y = cheb3_2d_x';
#figure(),imshow(cheb3_2d_x)
#figure(),imshow(cheb3_2d_y)
#figure(),imshow(cheb3_2d_x.*cheb3_2d_y./DIV)

#X = repmat(x,[size(x,2),1]);
#Y = X';
#tp = sin(7*acos(X)).*sin(7*acos(Y));
#tp = resize(tp,size(tp)+50);
#tp = resize(rot90(flip(tp,1)),size(tp)+50);
#tp = rot90(flip(tp,1));
#tp= abs(tp);
#h= figure(),
#imshow(tp)
print -dpdfcrop 1.pdf
