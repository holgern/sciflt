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
