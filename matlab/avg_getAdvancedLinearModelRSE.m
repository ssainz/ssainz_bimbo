function [rse , rmsle_mat] = avg_getAdvancedLinearModelRSE(N)

[rse_a, models, data_matrix, rmsle_mat_a,test_matrix] = getLinearModelRSE();
[adv_rse_a, adv_models, adv_rmsle_mat_a] = getAdvancedLinearModelRSE(data_matrix{1}, 'quadratic');

rse = table2array(adv_rse_a);
rmsle_mat = table2array(adv_rmsle_mat_a);

for i = 2:N 
    [rse_A, models, data_matrix, rmsle_mat_a,test_matrix] = getLinearModelRSE();
    [adv_rse_a, adv_models, adv_rmsle_mat_a] = getAdvancedLinearModelRSE(data_matrix{1}, 'quadratic');
    rse = rse + table2array(adv_rse_a);
    rmsle_mat = rmsle_mat + table2array(adv_rmsle_mat_a);
    
end
rse = rse ./ N;
rmsle_mat = rmsle_mat ./ N;
bimbovarsChar = {'producto_agencia' 'producto_cliente' 'producto_ruta' 'producto_ruta_cliente' 'producto_ruta_agencia' 'producto_ruta_agencia_cliente' 'producto_ruta_canal' 'producto_ruta_cliente_semana' 'producto_ruta_semana' 'producto_ruta_cliente_semana_agencia_canal'};
rse = table(rse(:,1), rse(:,2), rse(:,3), rse(:,4), rse(:,5), rse(:,6), rse(:,7),rse(:,8), rse(:,9), rse(:,10), 'VariableNames', bimbovarsChar);
rmsle_mat = table(rmsle_mat(:,1), rmsle_mat(:,2), rmsle_mat(:,3), rmsle_mat(:,4), rmsle_mat(:,5), rmsle_mat(:,6),rmsle_mat(:,7),rmsle_mat(:,8),rmsle_mat(:,9),rmsle_mat(:,10), 'VariableNames', bimbovarsChar);

end
