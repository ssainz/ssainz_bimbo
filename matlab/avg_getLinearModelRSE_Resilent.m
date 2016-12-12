function [rmsle_mat, rmsle_mat_test] = avg_getLinearModelRSE_Resilent(N)

[data_matrix, rmsle_mat_a, rmsle_mat_test_a, test_matrix] = getLinearModelRSE_Resilient;
rmsle_mat = table2array(rmsle_mat_a);
rmsle_mat_test = table2array(rmsle_mat_test_a);
1
timess = 2:N;

for i = timess
    [data_matrix_temp, rmsle_mat_temp, rmsle_mat_test_temp, test_matrix_temp] = getLinearModelRSE_Resilient;
    i
    rmsle_mat = rmsle_mat + table2array(rmsle_mat_temp);
    rmsle_mat_test = rmsle_mat_test + table2array(rmsle_mat_test_temp);
    
end

rmsle_mat = rmsle_mat ./ N;
rmsle_mat_test = rmsle_mat_test ./ N;

sizeChar = {'10', '20','40'};
rmsle_mat = table(rmsle_mat(:,1), rmsle_mat(:,2), rmsle_mat(:,3), rmsle_mat(:,4), rmsle_mat(:,5), rmsle_mat(:,6), 'VariableNames', {'agencia' 'canal' 'ruta' 'cliente' 'producto' 'samana'}, 'RowNames',sizeChar);
rmsle_mat_test = table(rmsle_mat_test(:,1), rmsle_mat_test(:,2), rmsle_mat_test(:,3), rmsle_mat_test(:,4), rmsle_mat_test(:,5), rmsle_mat_test(:,6), 'VariableNames', {'agencia' 'canal' 'ruta' 'cliente' 'producto' 'samana'}, 'RowNames',sizeChar);

end
