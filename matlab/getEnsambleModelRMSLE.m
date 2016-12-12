function [rmsle_mat, rmsle_test_mat, models] =  getEnsambleModelRMSLE

cliente_range = 500;
cliente_size = 25;
sizes = [1 5 8 10 15 30 50 100];
sizeChar = {'25'};

data_matrix = {};
test_matrix = {};
models = {};
i = 1;
j = 1;

for siz = sizes
    %siz
    data = getSampleData(cliente_range, cliente_size, 10000);
    data_mat = cell2mat(data);
    
    %normalize week from 3 - 9 to values between 0 - 1:
    data_mat(:,2) = (data_mat(:,2) - 3) / 6;
    [rowData_mat, colData_mat] = size(data_mat);
    data_mat(:,(colData_mat+1)) = ones(rowData_mat,1); 
    %add entry for the max values of each matrix.
    total_len = size(data_mat, 1);
    [trainInd,valInd,testInd] = dividerand(total_len,0.5,0,0.5);
    %cut_len = floor(total_len / 2);
    %test_table = data_table(1:cut_len,:);
    test_mat = data_mat(testInd,:);
    test_matrix{i}=test_mat;
    %NOT CUT TRAIN SET: data_table = data_table(cut_len+1:total_len,:);
    data_mat = data_mat(trainInd,:);
    data_matrix{i} = data_mat;
    
    % 1 id
    % 2 semana
    % 3 Agencia_ID, 
    % 4 Canal_ID, 
    % 5 Ruta_SAK, 
    % 6 Cliente_ID, 
    % 7 Producto_ID, 
    % 8 Venta_Adjusted
    XX = [data_mat(:,2) data_mat(:,3) data_mat(:,4) data_mat(:,5) data_mat(:,6) data_mat(:,7)  data_mat(:,9)];
    YY = data_mat(:,8);
    isCategorical = [0 1 1 1 1 1 0];
    
    leaf = [1 3 5 10 20 50 100];
    col = 'rbcmy';
    %figure
    i= 1;
    for h=1:length(leaf)
        
        B = TreeBagger(siz,XX,YY,'Method','R','OOBPred','On',...
                'CategoricalPredictors',find(isCategorical == 1),...
                'MinLeafSize',leaf(h));
            
            
        train_eval = predict(B, XX);
        rmsle_mat(i,j) = rmsle(train_eval, YY);

        %TEST%
        XX_test = [test_mat(:,2) test_mat(:,3) test_mat(:,4) test_mat(:,5) test_mat(:,6) test_mat(:,7)  test_mat(:,9)];
        YY_test = test_mat(:,8);
        test_eval = predict(B, XX_test);
        rmsle_test_mat(i,j) = rmsle(test_eval, YY_test);
        %TEST%

        models{i,j} = {B};
        i = i + 1;    
            
        %plot(oobError(B),col(h))
        
        %hold on
    end
    xlabel 'Number of Grown Trees'
    ylabel 'Mean Squared Error'
    legend({'5' '10' '20' '50' '100'},'Location','NorthEast')
    hold off
    j = j +1;
    
end

%rmsle_mat = table(rmsle_mat(:,1), 'VariableNames', {'all_vars'}, 'RowNames',sizeChar);
%rmsle_test_mat =  table(rmsle_test_mat(:,1), 'VariableNames', {'all_vars'}, 'RowNames',sizeChar);
end