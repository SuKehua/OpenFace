function [geom_data, valid_ids] = Read_geom_files_dynamic(users, model_param_data_dir)

    geom_data = [];
    valid_ids = [];
    
    load('../../pca_generation/pdm_68_aligned_wild.mat');
    
    user_files = [];
    
    for i=1:numel(users)
        
        geom_file = [model_param_data_dir, '/' users{i} '.txt'];
        
        user_files = cat(1, user_files, str2num(users{i}(3:5)));
                
        m_file = [model_param_data_dir, '/', users{i}, '.mat'];

        res = dlmread(geom_file, ',', 1, 0);

        valid = res(:, 4);        
        res = res(:, 11:end);

        actual_locs = res * V';
        res = cat(2, actual_locs, res);

        valid_ids = cat(1, valid_ids, valid);

        geom_data_curr_p = res;

        geom_data = cat(1, geom_data, geom_data_curr_p);
        
    end
       
    if(numel(users) > 0)
        uq_ids = unique(user_files)';
        
        for u=uq_ids
            geom_data(user_files==u,:) = bsxfun(@plus, geom_data(user_files==u,:), -median( geom_data(valid_ids & user_files==u,:)));        
        end
    end    
    
end