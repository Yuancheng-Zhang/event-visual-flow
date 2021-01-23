function par = FlowPlaneFit(events, th1, th2, L, delta_t, epsilon)

par.th1 = th1;
par.th2 = th2
par.L = L;
par.delta_t = delta_t;

par.xytpv = [];
par.tscale_flag = 1;
plot_flag = 0;
for i = 1:length(events.ts)
    par.curr_t = events.ts(i);
    par.curr_x = events.x(i);
    par.curr_y = events.y(i);
    par.curr_p = events.p(i);
    switch par.curr_p
        case 1
            neighbors = gatherNeighbors(events,par);
%             figure;
%             scatter3(neighbors(:,1),neighbors(:,2),neighbors(:,3));

            if size(neighbors,1) >= 4
                
                abcd_col = fit3Dsvd(neighbors(:,1),neighbors(:,2),neighbors(:,3));
%                 plotLocalPlane(abcd_col,par,'interp');
                while epsilon > th1 && size(neighbors,1) >=4
                    errs = neighbors*abcd_col;
                    [err_val,errs_idx] = max(abs(errs));
                    if err_val < th2
                        break;
                    else
                        neighbors(errs_idx,:) = [];
                        vec = fit3Dsvd(neighbors(:,1),neighbors(:,2),neighbors(:,3));
                        epsilon = sum(abs(vec-abcd_col));
                        abcd_col = vec;
                    end
                end

            end
        %case 0
        case -1
            neighbors = gatherNeighbors(events,par);
            
%             figure;
%             plotScatter(neighbors);
            if size(neighbors,1) >= 4
                
                abcd_col = fit3Dsvd(neighbors(:,1),neighbors(:,2),neighbors(:,3));
%                 plotLocalPlane(abcd_col,par,'interp');
                
                while epsilon > th1 && size(neighbors,1) >=4
                    errs = neighbors*abcd_col;
                    [err_val,errs_idx] = max(abs(errs));
                    if err_val < th2
                        break;
                    else
                        neighbors(errs_idx,:) = [];
                        vec = fit3Dsvd(neighbors(:,1),neighbors(:,2),neighbors(:,3));
                        epsilon = sum(abs(vec-abcd_col));
                        abcd_col = vec;
                    end
                end

            end
    end

    if epsilon <= th1 && size(neighbors,1) >=4
        temp_sum = abcd_col(1)^2 + abcd_col(2)^2;
        vx = -abcd_col(3)*abcd_col(1)/temp_sum*par.delta_t;
        vy = -abcd_col(3)*abcd_col(2)/temp_sum*par.delta_t;
        xytpv = [par.curr_x;par.curr_y;par.curr_t;par.curr_p;vx;vy;abcd_col(3)*par.delta_t];
        if abs(vx) <= 2*par.L && abs(vy) <= 2*par.L
            par.xytpv = cat(2,par.xytpv,xytpv);
            if plot_flag == 1
                figure;
                plotScatter(neighbors);
                plotLocalPlane(abcd_col,par,'interp');
                xlabel('x');
                ylabel('y');
                zlabel('t');

                hold on
                % plot normal
        %         n_norm = sqrt(abcd_col(1)^2+abcd_col(2)^2+abcd_col(3)^2);
        %         n1 = abcd_col(1)/n_norm;
        %         n2 = abcd_col(2)/n_norm;
        %         n3 = abcd_col(3)/n_norm;
        %         q1 = quiver3(xytpv(1),xytpv(2),xytpv(3),n1,n2,-n3);
        %         q1.Color = [228,192,44]/255;
        %         q1.AutoScale = 'off';
        %         hold on
        %         figure;
        %         q1 = quiver3(0,0,0,abcd_col(1),abcd_col(2),abcd_col(3));
        %         q1.Color = [44,192,228]/255;
        %         q1.AutoScale = 'off';
        %         hold on
        %         [xgrid_,ygrid_] = meshgrid(linspace(-50,50,20),linspace(-50,50,20));
        %         tgrid_ = -(0+abcd_col(1)*xgrid_+abcd_col(2)*ygrid_)/abcd_col(3);
        %         hold on
        %         s_ = surf(xgrid_,ygrid_,tgrid_);
        %         s_.EdgeColor = 'none';
        %         s_.FaceColor = 'interp';
        %         s_.FaceAlpha = 0.7;
                % plot gradient
                q2 = quiver3(xytpv(1),xytpv(2),xytpv(3),vx,vy,xytpv(7));
                q2.Color = 'k';
                q2.AutoScale = 'off';
                view(10,20);
            end
        end
    end
          
end
    

    function neighbors = gatherNeighbors(event,parameter)
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

end