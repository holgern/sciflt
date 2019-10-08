// Copyright (C) 2010 - H. Nahrstaedt
//


x=linspace(0,1,100)';
for a=[0 0.2 0.4 0.6 0.8 1],
	for b=[-100 -50 -10 -1 1 10 50 100],
		for c=[1 0.8 0.6 0.4 0.2 0],
			for d=[100 50 10 1 -1 -100 -20 -100],
				Y1=gauss2mf(x,[b,a,d,c]);
				idxA=1*(x<=a);
				idxB=1*(x>=c);
				YA=exp(-((x-a).^2)/((2*b^2))).*idxA+(1-idxA);
				YB=exp(-((x-c).^2)/((2*d^2))).*idxB+(1-idxB);	
				Y2=YA .* YB;
				computed = Y1;
				expected = Y2;

				assert_checkalmostequal ( computed , expected , %eps);	
			end
		end

	end
end

