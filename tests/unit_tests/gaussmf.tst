// Copyright (C) 2010 - H. Nahrstaedt
//

x=linspace(0,1,100)';
for a=[0 0.2 0.4 0.6 0.8 1],
	for b=[-100 -50 -10 -1 1 10 50 100],
		Y1=gaussmf(x,[b,a]);
		Y2=exp(-((x-a).^2)/((2*b^2)));
		computed = Y1;
		expected = Y2;

		assert_checkalmostequal ( computed , expected , %eps);	
	end
end


