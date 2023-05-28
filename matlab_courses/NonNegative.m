function output=NonNegative(input)
%% This function makes the negative inputs to be zero, but doesn't change positive inputs.
    if(input<0)
        output=0;
    else
        output=input;
    end
    global last_input;
    last_input=input;
end