function neighbors = gatherNeighbors(event,parameter)
        %win_t = [parameter.curr_t - parameter.t_wid, parameter.curr_t + parameter.t_wid];
        %win_x = [parameter.curr_x - parameter.s_wid, parameter.curr_x + parameter.s_wid];
        %win_y = [parameter.curr_y - parameter.s_wid, parameter.curr_y + parameter.s_wid];
        win_t = [parameter.curr_t - parameter.delta_t, parameter.curr_t + parameter.delta_t];
        win_x = [parameter.curr_x - parameter.L, parameter.curr_x + parameter.L];
        win_y = [parameter.curr_y - parameter.L, parameter.curr_y + parameter.L];
        neighbors = [];
        for j = 1:size(event.x)
            p = event.p(j);
            if p == parameter.curr_p
                t = event.ts(j);
                if t >=win_t(1) && t <= win_t(2)
                    x = event.x(j);
                    if x >=win_x(1) && x <= win_x(2)
                        y = event.y(j);
                        if y >= win_y(1) && y <= win_y(2)
                            if ~exist('neighbors')
                                neighbors = [x,y,t,1];
                            else
                                neighbors = cat(1,neighbors,[x,y,t,1]);
                            end
                            
                        end
                    end
                end
            end
        end
        
    end