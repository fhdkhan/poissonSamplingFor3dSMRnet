close all;
a = 11; # plotting the curves for
b = 12; # different values of a/b
delta = pi/2;
t = linspace(-pi,pi,300);

x = sin(a * t + delta);
y = sin(b * t);
plot(x,y,"linewidth", 2)

axis ([-1.2, 1.2, -1.2, 1.2], "square");
set(gca, "linewidth", 2, "fontsize", 14)
print -dpdfcrop 2.pdf
