function [rse, models, rmsle_mat] = getAdvancedLinearModelRSE(data_table, model)
variableNamess = {'id', 'semana', 'agencia','canal', 'ruta','cliente','producto','venta'};
%data_mat = cell2mat(data);
%data_table = table(data_mat(:,1),data_mat(:,2),data_mat(:,3),data_mat(:,4),data_mat(:,5),data_mat(:,6),data_mat(:,7),data_mat(:,8), 'VariableNames', variableNamess);
bimbovars = {{'producto' 'agencia'},{'producto' 'cliente'},{'producto' 'ruta'},{'producto' 'ruta'  'cliente'}, {'producto' 'ruta'  'agencia'},{'producto' 'ruta'  'agencia' 'cliente'},{'producto' 'ruta'  'canal'},{'producto' 'ruta' 'cliente' 'semana'},{'producto' 'ruta' 'semana'},{'producto' 'ruta' 'cliente' 'semana' 'agencia' 'canal'}};
bimbovarsChar = {'producto_agencia' 'producto_cliente' 'producto_ruta' 'producto_ruta_cliente' 'producto_ruta_agencia' 'producto_ruta_agencia_cliente' 'producto_ruta_canal' 'producto_ruta_cliente_semana' 'producto_ruta_semana' 'producto_ruta_cliente_semana_agencia_canal'};
rse = [];
data_matrix = {};
models = {};
j = 1;

for vv = bimbovars 
    predictors = vv{:};
    categorical = predictors;
    %class(categorical)
    %categorical
    %size(categorical)
    categorical(strcmp(categorical,'semana')) = [];
    %categorical
    mdl = fitlm(data_table, model, 'ResponseVar', 'venta', 'PredictorVars', predictors, 'CategoricalVars', categorical);
    rse(1, j) = mdl.RMSE;
    test = feval(mdl, data_table);
    rmsle_mat(1, j) = rmsle(test, data_table.venta);
    models(1, j) = {mdl};
    j = j + 1;
end

rse = table(rse(:,1), rse(:,2), rse(:,3), rse(:,4), rse(:,5), rse(:,6), rse(:,7),rse(:,8),rse(:,9),rse(:,10), 'VariableNames', bimbovarsChar);
rmsle_mat = table(rmsle_mat(:,1), rmsle_mat(:,2), rmsle_mat(:,3), rmsle_mat(:,4), rmsle_mat(:,5), rmsle_mat(:,6),rmsle_mat(:,7),rmsle_mat(:,8),rmsle_mat(:,9),rmsle_mat(:,10), 'VariableNames', bimbovarsChar);

end 