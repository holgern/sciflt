function [output, rule_input, firing_strength,rule_output, fuzzy_output]=evalfis_rv(user_input, fis, num_points)
    //Evaluate fuzzy logic system
    //Calling Sequence
    //y=evalfis(x,fls,[npev])
    //Parameters
    //x:matrix of real. Input points.
    //fls:fls structure to evaluate
    //npev:scalar or vector, number of points to evaluate during defuzzification algorithm (mamdani)
    //Description
    //         <literal>evalfls </literal>evaluate the fuzzy logic system <literal>fls</literal>
    //     in points <literal>x</literal> and return values in <literal>y</literal>. The
    //     <literal>x</literal> parameters have dimension <literal>[npairs_of_inputs,
    //     number_of_inputs]</literal>, the output <literal>y</literal> have dimension
    //     <literal>[npairs_of_inputs, number_of_outputs]</literal>.
    // 
    //     
    //     The <literal>npev</literal> parameter is optional in Mamdani case, the user
    //     can set the number of partitions of the output variable domain to evaluate
    //     the member functions for each output. This parameter can be a scalar (all
    //     outputs are evaluated with the same number of partitions) or vector (each
    //     element set the number of partitions for each output).The default value
    //     for all outputs is 1001 points.
    //Examples
    // // GET A FLS
    // fls=loadfls(flt_path()+"demos/fan1.fls");
    // // EVALUATE
    // y1=evalfls([50 50],fls)
    // y2=evalfls([50 20;50 50],fls,100)
    //See also
    //fls_structure
    //newfls
    //scicos_fls
    // Authors
    // Holger Nahrstaedt

    if argn(2)<3 then
        num_points=101;
    end;

    // Initialize output matrix (to prevent repeated resizing).

    output = zeros (size (user_input,1), size (fis.output));

    // Process one set of inputs at a time. For each row of crisp input
    // values in the input matrix, add a row of crisp output values to the
    // output matrix.
    num_inputs = size (fis.input);               // num_inputs == N
    num_rules = size (fis.rule,1);                 // num_rules  == Q (above)
    num_outputs = size (fis.output);

    for i = 1 : size (user_input,1)
        //rule_input = fuzzify_input (fis, user_input(i, :));

        rule_input = zeros (num_rules, num_inputs);     // init to prevent resizing

        // For each rule i and each input j, compute the value of mu in the result.

        for ii = 1 : num_rules
            antecedent = fis.rule(ii,1:2);
            for jj = 1 : num_inputs
                mu = 0;
                crisp_x = user_input(i,jj);

                // Get the value of mu (with adjustment for the hedge and not_flag).

                //[mf_index hedge not_flag] = get_mf_index_and_hedge (antecedent(jj));

                if (antecedent(jj) < 0)
                    not_flag = %t;
                    antecedent(jj) =  -antecedent(jj);
                else
                    not_flag = %f;
                end

                // The membership function index is the positive whole number portion
                // of an element in the antecedent.

                mf_index = fix (antecedent(jj));
                // For custom hedges and the four built-in hedges "somewhat", "very",
                // "extremely", and "very very", return the power to which the membership
                // value should be raised. The hedges are indicated by the fractional
                // part of the corresponding rule_matrix entry (rounded to 2 digits). 

                if (mf_index ~= 0)
                    hedge = round (100 * (antecedent(jj) - mf_index)) / 10;
                else
                    hedge = 0;
                end

                if (mf_index ~= 0)
                    mf = fis.input(jj).mf(mf_index);
                    mu = mfeval (crisp_x, mf.type, mf.par, hedge, 0);
                    if not_flag then
                        mu=complement(mu,fis.Comp,fis.CompPar);   
                    end;
                end

                // Store the fuzzified input in rule_input.

                rule_input(ii, jj) = mu;
            end
        end

        //firing_strength = eval_firing_strength (fis, rule_input);

        // Initialize output matrix to prevent inefficient resizing.
        firing_strength = zeros (1, num_rules);
        // For each rule
        //    1. Apply connection to find matching degree of the rule antecedent.
        //    2. Multiply by weight of the rule to find degree of the rule.

        for ii = 1 : num_rules
            rule = fis.rule(ii,:);

            // Collect mu values for all input variables in the rule's antecedent.
            antecedent_mus = [];
            for jj = 1 : num_inputs
                if (rule(jj) ~= 0)
                    mu = rule_input(ii, jj);
                    antecedent_mus = [antecedent_mus mu];
                end
            end

            // Compute matching degree of the rule.
            if (rule($-1) == 1)
                //connect = fis.andMethod;
                firing_strength(ii) = tnorm(antecedent_mus,fis.TNorm,fis.TNormPar)*rule($);
            else
                // connect = fis.orMethod;
                firing_strength(ii) = snorm(antecedent_mus,fis.SNorm,fis.SNormPar)*rule($);
            end

        end
        
        if ((fis.type== 'm')) then
            //rule_output = eval_rules_mamdani (fis, firing_strength, num_points);
            // Initialize output matrix to prevent inefficient resizing.
            rule_output = zeros (num_points, num_rules*num_outputs);

            // Compute the fuzzy output for each (rule, output) pair:
            //   1. Apply the FIS implication method to find the fuzzy outputs
            //      for the current (rule, output) pair.
            //   2. Store the result as a column in the rule_output matrix.

            for ii = 1 : num_rules
                rule = fis.rule(ii,:);
                rule_matching_degree = firing_strength(ii);

                if (rule_matching_degree ~= 0) then
                    for jj = 1 : num_outputs

                        // Compute the fuzzy output for this (rule, output) pair.

                        //[mf_index hedge not_flag] = get_mf_index_and_hedge (rule.consequent(jj));
                        consequent=rule(num_inputs+jj);
                        if (consequent < 0)
                            not_flag = %t;
                            consequent = -consequent;
                        else
                            not_flag = %f;
                        end

                        // The membership function index is the positive whole number portion
                        // of an element in the consequent.

                        mf_index = fix (consequent);
                        // For custom hedges and the four built-in hedges "somewhat", "very",
                        // "extremely", and "very very", return the power to which the membership
                        // value should be raised. The hedges are indicated by the fractional
                        // part of the corresponding rule_matrix entry (rounded to 2 digits). 

                        if (mf_index ~= 0)
                            hedge = round (100 * (consequent - mf_index)) / 10;
                        else
                            hedge = 0;
                        end

                        if (mf_index ~= 0) then

                            // First, get the fuzzy output, adjusting for the hedge and not_flag,
                            // but not for the rule matching degree.

                            flsrange = fis.output(jj).range;
                            mf = fis.output(jj).mf(mf_index);
                            x = linspace (flsrange(1), flsrange(2), num_points);
                            fuzzy_out = mfeval (x,  mf.type, mf.par, hedge, 0);
                            if not_flag then
                                fuzzy_out=complement(fuzzy_out,fis.Comp,fis.CompPar);   
                            end;
                            // Adjust the fuzzy output for the rule matching degree.

                            select (fis.ImpMethod)
                            case 'min' then
                                fuzzy_out = min (rule_matching_degree, fuzzy_out);
                            case 'prod' then
                                fuzzy_out = fuzzy_out*rule_matching_degree;
                            case 'eprod' then

                                rule_matching_degree=rule_matching_degree*ones(fuzzy_out);
                                //                 for iii=1:max(size(fuzzy_out))
                                //                   fuzzy_out(iii)= (fuzzy_out(iii)*rule_matching_degree(iii))/(2-(fuzzy_out(iii)+rule_matching_degree(iii)-fuzzy_out(iii)*rule_matching_degree(iii)));
                                //                 end;
                                fuzzy_out=(fuzzy_out.*rule_matching_degree)./(2-(fuzzy_out+rule_matching_degree-(fuzzy_out.*rule_matching_degree)));
                            else
                                fuzzy_out = min (rule_matching_degree, fuzzy_out);
                            end

                            // Store result in column of rule_output corresponding
                            // to the (rule, output) pair.

                            rule_output(:, (jj - 1) * num_rules + ii) = fuzzy_out';
                        end //endif
                    end //endfor
                end //endif

            end //endfor
            //fuzzy_output = aggregate_output_mamdani (fis, rule_output);
            num_points = size (rule_output,1);

            // Initialize output matrix to prevent inefficient resizing.
            fuzzy_output = zeros (num_points, num_outputs);

            // Compute the ith fuzzy output values, then store the values in the
            // ith column of the fuzzy_output matrix.
            for ii = 1 : num_outputs
                indiv_fuzzy_out = rule_output(:, (ii - 1) * num_rules + 1 : ii * num_rules);
                select (fis.AggMethod)
                case 'max' then 
                    agg_fuzzy_out = (max (indiv_fuzzy_out','r'))';
                case 'esum' then 
                    indiv_fuzzy_out=indiv_fuzzy_out';
                    agg_fuzzy_out=zeros(1,size(indiv_fuzzy_out,2));
                    for iii=1:size(indiv_fuzzy_out,1);
                        agg_fuzzy_out = (agg_fuzzy_out+indiv_fuzzy_out(iii,:))./(1+agg_fuzzy_out.*indiv_fuzzy_out(iii,:));
                    end;
                    agg_fuzzy_out=agg_fuzzy_out';
                end;
                fuzzy_output(:, ii) = agg_fuzzy_out;
            end

            //output(i, :) = defuzzify_output_mamdani (fis, fuzzy_output);
            num_points = size (fuzzy_output,1);
            //output = zeros (1, num_outputs);

            for ii = 1 : num_outputs
                flsrange = fis.output(ii).range;
                x = linspace (flsrange(1), flsrange(2), num_points);
                y = (fuzzy_output(:, ii))';
                if sum(y) == 0 then
                    output(i,ii) = 0;
                else
                    output(i,ii) = defuzzm (x(:), y(:), fis.defuzzMethod);
                end
                
            end

        else
            //rule_output = eval_rules_sugeno (fis, firing_strength, user_input(i, :));

            // Initialize output matrix to prevent inefficient resizing.
            rule_output = zeros (2, num_rules * num_outputs);

            // Compute the (location, height) of the singleton output by each
            // (rule, output) pair:
            //   1. The height is given by the firing strength of the rule, and by
            //      the hedge and the not flag for the (rule, output) pair.
            //   2. If the consequent membership function is constant, then the
            //      membership function's parameter gives the location of the singleton.
            //      If the consequent membership function is linear, then the
            //      location is the inner product of the the membership function's
            //      parameters and the vector formed by appending a 1 to the user input
            //      vector.

            for ii = 1 : num_rules
                rule = fis.rule(ii,:);
                rule_firing_strength = firing_strength(ii);

                if (rule_firing_strength ~= 0)
                    for jj = 1 : num_outputs

                        // Compute the singleton height for this (rule, output) pair.
                        // Note that for Sugeno FISs, the hedge and not flag are handled by
                        // adjusting the height of the singletons for each (rule, output) pair.

                        //[mf_index hedge not_flag] = get_mf_index_and_hedge (rule.consequent(j));
                        consequent=rule(num_inputs+jj);
                        if (consequent < 0)
                            not_flag = %t;
                            consequent = -consequent;
                        else
                            not_flag = %f;
                        end

                        // The membership function index is the positive whole number portion
                        // of an element in the consequent.

                        mf_index = fix (consequent);
                        // For custom hedges and the four built-in hedges "somewhat", "very",
                        // "extremely", and "very very", return the power to which the membership
                        // value should be raised. The hedges are indicated by the fractional
                        // part of the corresponding rule_matrix entry (rounded to 2 digits). 

                        if (mf_index ~= 0)
                            hedge = round (100 * (consequent - mf_index)) / 10;
                        else
                            hedge = 0;
                        end
                        height = rule_firing_strength;
                        if (hedge ~= 0)
                            height = height ^ (1 / hedge);
                        end
                        if (not_flag)
                            height = 1 - height;
                        end

                        // Compute the singleton location for this (rule, output) pair.

                        if (mf_index ~= 0)
                            mf = fis.output(jj).mf(mf_index);
                            select (mf.type)
                            case 'constant' then
                                location = mf.par;
                            case 'linear' then
                                location = mf.par * [user_input 1]';
                            else
                                //location = str2func (mf.type) (mf.params, user_input);
                            end

                            // Store result in column of rule_output corresponding
                            // to the (rule, output) pair.

                            rule_output(1, (jj - 1) * num_rules + ii) = location;
                            rule_output(2, (jj - 1) * num_rules + ii) = height;
                        end
                    end
                end
            end

            //fuzzy_output = aggregate_output_sugeno (fis, rule_output);
            fuzzy_output = 0;
            output(i, :) = evalfls(user_input,fis);
            //output(i, :) = defuzzify_output_sugeno (fis, fuzzy_output);
        end
    end
endfunction
