function y = flsviewrule(fs,var_in,new)
    ieee(2);

    // Evaluate the stucture for plotting rules
    input_num = size(fs.input);
    output_num = size(fs.output);
    rules_num = size(fs.rule,1);

    n = argn(2);

    if n==1 then
        var_in = zeros(1,input_num);
    end

    if n <=2 then
        //　Initialize figure for plotting
        figure();a1 = newaxes(); a1.visible = 'off';
        drawlater();
        delmenu(0,'File');
        delmenu(0,'Edit');
        delmenu(0,'Tools');
        delmenu(0,'?');
        toolbar(0,'off');
    else
        drawlater();
        a = gcf();delete(a.children);     
    end

    // Going through all rules 
    for cnt = 1:rules_num // cnt is the number of rules

        current_rule = fs.rule(cnt,:);

        // 1 Rule  [ip1 ip2 op w con]
        for cnt2 = 1:input_num // cnt2 is the number of inputs
            pts = 101;
            x = linspace(fs.input(cnt2).range(1),fs.input(cnt2).range(2),pts);
            if current_rule(cnt2) ~= 0 
                // This line is to create the string for the given point evaluation
                str(cnt2) = fs.input(cnt2).mf(current_rule(cnt2)).type + '(' + string(var_in(cnt2)) +...
                ',[' + strcat(string(fs.input(cnt2).mf(current_rule(cnt2)).par),' ' ) + '])';
                // This line is to create the string for all x range evaluation
                str2(cnt2) = fs.input(cnt2).mf(current_rule(cnt2)).type + '(' +  'x' +...
                ',[' + strcat(string(fs.input(cnt2).mf(current_rule(cnt2)).par),' ' ) + '])';                
            else // If the rule does not use the input
                str(cnt2) = '0';
                str2(cnt2) = '0';
            end        
            //pause
            input_val(cnt2) = evstr(str(cnt2)); // To get the current value
            if str2(cnt2) == '0'
                input_val_all(cnt2,:) = zeros(x);
            else
                input_val_all(cnt2,:) = evstr(str2(cnt2)); // To get all values over x range
            end
            // Plot of the membership functions according to rules
            subplot(rules_num + 2,input_num+output_num,(cnt-1)*(input_num+output_num)+cnt2);
            plot2d(x,input_val_all(cnt2,:),strf = '051',rect = [min(x) 0 max(x) 1]);
            plot2d(var_in(cnt2)*ones(11,1),0:0.1:1,strf = '051',rect = [min(x) 0 max(x) 1],style = 3);
            plot2d(0:10,input_val(cnt2)*ones(11,1),strf = '051',rect = [min(x) 0 max(x) 1],style = 3);
        end

    end
//pause
    [output, rule_input, rule,rule_output, fuzzy_output]=evalfis_rv(var_in,fs);
    
    if fs.type ~= 'm' then
        for cnt2 = 1:output_num
            
        end
    end
    

    // 
    for cnt = 1:size(fs.rule,1)
        current_rule = fs.rule(cnt,:);

        for cnt2 = 1:output_num
            
            if fs.type == 'm' then
                pts = 101;
                x = linspace(fs.output(cnt2).range(1),fs.output(cnt2).range(2),pts);
                if current_rule(cnt2+input_num) ~= 0
                    str(cnt2) = fs.output(cnt2).mf(current_rule(cnt2+input_num)).type + '(' +  'x,[' +...
                    strcat(string(fs.output(cnt2).mf(current_rule(cnt2+input_num)).par),' ' ) + '])';                
                else
                    str(cnt2) = '0';
                end        

                out_val(cnt2,:) = evstr(str(cnt2));
                subplot(rules_num + 2,input_num+output_num,(cnt-1)*(input_num+output_num) + input_num+cnt2);
                plot2d(x,out_val(cnt2,:),strf = '051',rect = [min(x) 0 max(x) 1]);
                imp(cnt2,:) = min(out_val(cnt2,:),rule(cnt));                
                plot2d(x,imp(cnt2,:),strf = '051',rect = [min(x) 0 max(x) 1],style = 2);                            
            else
                //rule_output 
                //for cnt3 = 1:output_num
                    
               // end
                subplot(rules_num + 2,input_num+output_num,(cnt-1)*(input_num+output_num) + input_num+cnt2);
                //disp(rule_output);    
                plot2d([rule_output(1,cnt) rule_output(1,cnt)],[0 1],strf = '051',rect = [min(rule_output(1,:)) 0 max(rule_output(1,:)) 1],style = 2);
                a = gce();
                a.children.thickness = 5;
                a.children.foreground=4;
                plot2d([rule_output(1,cnt) rule_output(1,cnt)],[0 rule_output(2,cnt)],strf = '051',rect = [min(rule_output(1,:)) 0 max(rule_output(1,:)) 1],style = 2);
                a = gce();
                a.children.thickness = 5;
                a.children.foreground=2;                
                //pause
                //plot2d(1:10,1:10);                            
            end

        end
        if fs.type == 'm' then
            imp2(:,:,cnt) = imp;
        else
            
        end

    end


    h = gcf();
    for cnt3 = 1:output_num
        // Aggregation Operation
        if fs.type == 'm' then
            agg(:,cnt3) = max(squeeze(imp2(cnt3,:,:)),'c');
            x = linspace(fs.output(cnt3).range(1),fs.output(cnt3).range(2),pts);
            subplot(rules_num + 2,input_num+output_num,(rules_num)*(input_num+output_num) + input_num + cnt3);
            plot2d(x,agg(:,cnt3),strf = '051',rect = [min(x) 0 max(x) 1]);
            //y(cnt3) = sum(x'.*agg(:,cnt3))./sum(agg(:,cnt3));
            y = output;
        else            
            subplot(rules_num + 2,input_num+output_num,(rules_num)*(input_num+output_num) + input_num + cnt3);
            plot2d([rule_output(1,:);rule_output(1,:)],[zeros(rule_output(2,:));rule_output(2,:)],strf = '051',...
            rect = [min(rule_output(1,:)) 0 max(rule_output(1,:)) 1]);
            //plot([rule_output(1,:);rule_output(1,:)],[0 0 0;rule_output(2,:)])
            //bar(rule_output(1,:),rule_output(2,:),0.2);
            a = gce();
            a.children.thickness = 5;
            a.children.foreground=2;             
            y = output;
            
            plot2d([y(cnt3) y(cnt3)],[0 1]);
            //plot([rule_output(1,:);rule_output(1,:)],[0 0 0;rule_output(2,:)])
            //bar(rule_output(1,:),rule_output(2,:),0.2);
            a = gce();
            a.children.thickness = 3;
            a.children.foreground=5;             
            
        end
    end


    message_str = 'if ';
    for cnt = 1:input_num
        message_str = message_str + fs.input(cnt).name + ' is ';
        message_str = message_str + string(var_in(cnt)) + ', '; 
    end
    message_str = message_str + 'then '
    for cnt = 1:output_num
        message_str = message_str + fs.output(cnt).name + ' is ';
        message_str = message_str + string(y(cnt)) + ', ';
    end

    h.info_message= message_str;

    handles = struct();
    handles.h = h;
    handles.fs=1;
    handles.fs = fs;    

    uicontrol(h,'style','text','position',[10 10 50 30],'string','Input:','fontsize',12);
    handles.hedit=uicontrol(h,'style','edit','position',[60 10 100 30],...
    'callback','call_rv(handles)','string','[' + strcat(string(var_in),' ') + ']','fontsize',12);
    drawnow();
    handles = resume(handles);
endfunction

function call_rv(handles)
    //pause

    fs = handles.fs;
    try
        data = evstr(handles.hedit.string);
    catch
        data = zeros(1,size(fs.input));
    end
    
    if  size(data) ~= size(fs.input)
        data = zeros(1,size(fs.input));
    end
    
    y = flsviewrule(fs,data,1);
    
    handles = resume(handles);

    //disp(fs);
endfunction


