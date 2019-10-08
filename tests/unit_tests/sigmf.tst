// Copyright (C) 2010 - H. Nahrstaedt
//


x=linspace(0,1,100)';
for a=linspace(-1,1,10),
	for b=linspace(-1,1,10),
		Y1=sigmf(x,[a b]);
		Y2= 1 ./ ( 1 + exp( -a*(x-b) ) );
		computed = Y1;
		expected = Y2;

		assert_checkalmostequal ( computed , expected , %eps);		
	end
end