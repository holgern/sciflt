// Copyright (C) 2010 - H. Nahrstaedt
//



x=linspace(%eps,1,100)';
for c=[-100 -50 -10 -1 0],
	for b=[1 10 50 100],
		for a=[-1 0 -1 0 1 1.5 2 2.5] ;
			Y1=gbellmf(x,[a,b,c]);
			if (c==0) then
				Y2=0.5*ones(x);
			elseif (c<0) then
				Y2=zeros(x);
			else
				Y2=1 ./ ( 1 + (abs((x-c)/a)).^(2*b) );
			end			
			computed = Y1;
			expected = Y2;

			assert_checkalmostequal ( computed , expected , %eps);	
		end
	end
end