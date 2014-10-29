% figure(1);
% fun = @(x)[sin(x), cos(x)];
% fplot(fun ,[0,2*pi])
% hold on;
% fplot(fun ,[1,2*pi])



figure
f_1 = @(x)sin(0.25*x);
f_2 = @(x)sin(0.5*x);

f_3 = @(x)sin(2*x);
f_4 = @(x)sin(1*x);


h = @(x)(x*0);
hold on
cellfun(@(func, range) fplot(func, range), {f_1, f_2, f_3, f_4, h}, {[0*pi, 8*pi], [8*pi, 12*pi],[12*pi, 14*pi],[14*pi, 16*pi], [0, 16*pi]})