// Copyright (C) 2010 - H. Nahrstaedt
//



// CENTROIDE
x=linspace(0,10,1000)';
y=rand(1000,1);

y_sum=sum(y);
Y1=sum(y.*x)/y_sum;
Y2=defuzzm(x,y,"centroide");
computed = Y1
 expected = Y2

assert_checkalmostequal ( computed , expected , %eps);
	
	
	
// BISECTOR
x=linspace(0,10,1000)';
y=rand(1000,1);
y_sum=sum(y);
tmp=0;
for k=1:size(x,"*"),
	tmp=tmp+y(k);
	if tmp>= y_sum/2 then
		break;
	end
end
Y1=x(k);
Y2=defuzzm(x,y,"bisector");

computed = Y1
expected = Y2

assert_checkalmostequal ( computed , expected , %eps);

// MEAN OF MAXIMUM
x=linspace(0,10,1000)';
y0=rand(200,1);
y=[];
for j=1:5,
	y=[y;y0];
end
Y1=mean(x(find(y==max(y))));
Y2=defuzzm(x,y,"mom");

computed = Y1
expected = Y2

assert_checkalmostequal ( computed , expected , %eps);
	
// LARGEST OF MAXIMUM
x=linspace(0,10,1000)';
y0=rand(200,1);
y=[];
for j=1:5,
	y=[y;y0];
end
tmp=find(y==max(y));
Y1=max(x(tmp));
Y2=defuzzm(x,y,"lom");

computed = Y1
expected = Y2

assert_checkalmostequal ( computed , expected , %eps);
	
// SHORTEST OF MAXIMUM
x=linspace(0,10,1000)';
y0=rand(200,1);
y=[];
for j=1:5,
	y=[y;y0];
end
tmp=find(y==max(y));
Y1=min(x(tmp));
Y2=defuzzm(x,y,"som");

computed = Y1
expected = Y2

assert_checkalmostequal ( computed , expected , %eps);