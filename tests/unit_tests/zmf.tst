// Copyright (C) 2010 - H. Nahrstaedt
//





x=linspace(-1,1,100)';
for a=linspace(-1,1,20),
	for b=linspace(-1,1,20),
		par=[a b];
		Y1=zmf(x,par);
		if (par(1)>=par(2)) then
			Y2=1*(x<=((par(1)+par(2))/2));
		else
			Y2=zeros(x);
			idx=find(x<=par(1));
			Y2(idx)=1;
			idx=find((par(1)<x)&(x<=(par(1)+par(2))/2));
			Y2(idx)=1-2*((x(idx)-par(1))/(par(2)-par(1))).^2;
			idx=find((((par(1)+par(2))/2)<x)&(x<=par(2)));
			Y2(idx)=2*((par(2)-x(idx))/(par(2)-par(1))).^2;		
		end		
		computed = Y1
		expected = Y2

		assert_checkalmostequal ( computed , expected , %eps);		
	end
end