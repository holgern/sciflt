// Copyright (C) 2010 - H. Nahrstaedt
//


x=linspace(0,1,100)';
for a=linspace(-1,1,10),
	for b=linspace(-1,1,10),
		Y1=dsigmf(x,[a b b a]);
		tmp1= 1 ./ ( 1 + exp( -a*(x-b) ) );
		tmp2= 1 ./ ( 1 + exp( -b*(x-a) ) );
		Y2=abs(tmp1 - tmp2);

		computed = Y1;
		expected = Y2;

		assert_checkalmostequal ( computed , expected , %eps);	
	end
end

