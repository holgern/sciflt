function plotfls(fs)

drawlater();

    input_num = size(fs.input);
    output_num = size(fs.output);
    rules_num = size(fs.rule,1);

    pts = 101;
    
    
    for cnt = 1:input_num
        x = linspace(fs.input(cnt).range(1),fs.input(cnt).range(2),pts);
        subplot(input_num,3,3*(cnt-1)+1)
        
        mem_num = size(fs.input(cnt).mf);
        for cnt2 = 1:mem_num   
            str = fs.input(cnt).mf(cnt2).type + '(' +  'x' +...
                 ',[' + strcat(string(fs.input(cnt).mf(cnt2).par),' ' ) + '])'; 
            pause
            y = evstr(str); // To get the current value
            plot(x,y);     
            
        end
            a = gca();
            a.auto_ticks = ['off' 'off' 'off'];
            a.background = 7;
            a.thickness = 2;
            xlabel(fs.input(cnt).name + ' (' + string(mem_num) + ')')       
    end


    subplot(1,3,2)
    //pause
    plot(0,0);

    xstring(-0.4,0.5,fs.name);
    e = gce();
    e.font_size = 4;
    
    if fs.type == 'm' then
        xstring(-0.5,0,'Mamdani');
    else
        xstring(-0.8,0,'Takagi-Sugeno');
    end   
    e = gce();
    e.font_size = 4;
    
    xstring(-0.4,-0.5,string(rules_num) + ' rules');
    e = gce();
    e.font_size = 4;
    a = gca();
    a.auto_ticks = ['off' 'off' 'off'];
    a.thickness = 2;

    for cnt = 1:output_num
        x = linspace(fs.output(cnt).range(1),fs.output(cnt).range(2),pts);
        
        if  output_num == 1 then
            subplot(3,3,3*(cnt)+3)
        else
            subplot(output_num,3,3*(cnt-1)+3)
        end

        
        mem_num = size(fs.output(cnt).mf);
        for cnt2 = 1:mem_num   
            str = fs.output(cnt).mf(cnt2).type + '(' +  'x' +...
                 ',[' + strcat(string(fs.output(cnt).mf(cnt2).par),' ' ) + '])'; 
            y = evstr(str); // To get the current value
            plot(x,y)
            
        end
            a = gca();
            a.auto_ticks = ['off' 'off' 'off'];    
            a.background = 4;
            a.thickness = 2;     
            xlabel(fs.output(cnt).name + ' (' + string(mem_num) + ')')               
    end
    
    
drawnow();

  str = ('System ' + fs.name + ' : ' + string(input_num) + ' inputs, ' + string(output_num) + ' outputs, ' + string(rules_num) + ' rules');
  h = gcf();
  h.info_message= str;

endfunction
