using Progress.Json.ObjectModel.*.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using progress.Lang.error.
using com.totvs.framework.api.*.

{cstp/api/v1/services/environments.i}

{utp/ut-api.i}
{utp/ut-api-action.i pi-metadata get /metadata/~* }
{utp/ut-api-action.i pi-find get /~*/~* }
{utp/ut-api-action.i pi-list get /~* }
{utp/ut-api-action.i pi-create post /~* } 
{utp/ut-api-action.i pi-update put /~*/~* } 
{utp/ut-api-action.i pi-delete delete /~*/~* } 
{utp/ut-api-notfound.i}
{method/dbotterr.i}
{cstp/api/v1/services/bocst0194.i ttVeiculos}
{cstp/api/v1/services/veiculos-metadata.i}

define variable boHandler as handle no-undo.


  
/*****************************************************************************
                            PESQUISAR VEÖCULO 
******************************************************************************/
procedure pi-find:
    define input  param oReq      as JsonObject           no-undo.
    define output param oRes      as JsonObject           no-undo.
    define variable oJsonObject   as JsonObject           no-undo.
    define variable pathParam     as character            no-undo.
    define variable msg           as JsonObject           no-undo.
    define variable msgArray      as JsonArray            no-undo.
    define variable oRequest      as JsonAPIRequestParser no-undo.
    define variable lTodos        as logical initial true no-undo.
    define variable oQueryParams  as JsonObject           no-undo.
   
    assign 
        oRequest     = new JsonAPIRequestParser(oReq)
        pathParam    = oRequest:getPathParams():GetCharacter(1)
        oQueryParams = new JsonObject()
        oQueryParams = oReq:getJsonObject("queryParams").
    
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0194.p persistent set boHandler.
    end.

    run setConstraintMain in boHandler (input lTodos).
    run openQueryStatic   in boHandler (input "Main":U).
    run emptyRowErrors    in boHandler.
    run getRowErrors      in boHandler (output table RowErrors append).
    run goToKey           in boHandler (input pathParam).

    if upper(return-value) = "OK":U then do:
        run getRecord in boHandler (output table ttVeiculos).
        assign 
            oJsonObject = JsonAPIUtils:ConvertTempTableToJsonObject(temp-table ttVeiculos:handle)
            oRes        = JsonApiResponseBuilder:ok(oJsonObject:getJsonArray("ttVeiculos"):getJsonObject(1), 200).
        if valid-handle(boHandler) then
        run destroy in boHandler.
        return.
    end.
    else do:
        assign
            msgArray = new JsonArray()
            msg      = new JsonObject().
        
        msg:add("ErrorHelp", "Ve¡culo placa " + pathParam  + " nÆo encontrado na base de dados!").
        msg:add("ErrorNumber", 1).
        msg:add("ErrorDescription", "Ve¡culo nÆo encontrado!").
        msg:add("ErrorSubType", "error").
        msgArray:Add(msg).
        assign oRes = JsonApiResponseBuilder:asError(msgArray, 404).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.
    end.

    if valid-handle(boHandler) then
        run destroy in boHandler.

    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
    end.
    else do:
        assign 
            oJsonObject = JsonAPIUtils:ConvertTempTableToJsonObject(temp-table ttVeiculos:handle)
            oRes        = JsonApiResponseBuilder:ok(oJsonObject:getJsonArray("ttVeiculos"):getJsonObject(1), 200).
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally.
end procedure.



/*****************************************************************************
                               LISTAR VEÖCULOS 
******************************************************************************/
procedure pi-list:
    define input  param oReq      as JsonObject           no-undo.
    define output param oRes      as JsonObject           no-undo.
    define variable aJsonArray    as JsonArray            no-undo.
    define variable aJsonArrayRes as JsonArray            no-undo.
    define variable rId           as rowid                no-undo.
    define variable iReturnedRows as integer              no-undo.
    define variable iStartRow     as integer              no-undo.
    define variable iContIni      as integer              no-undo.
    define variable iContFin      as integer              no-undo.
    define variable hasNext       as logical initial true no-undo.
    define variable hasFirst      as logical initial true no-undo.
    define variable iPageSize     as integer              no-undo.
    define variable iPage         as integer              no-undo.
    define variable oRequest      as JsonAPIRequestParser no-undo.
    define variable oQueryParams  as JsonObject           no-undo.
    define variable i             as integer              no-undo.
    define variable oJsonObject   as JsonObject           no-undo.
    define variable msg           as JsonObject           no-undo.
    define variable msgArray      as JsonArray            no-undo.
    define variable cPlaca        as character            no-undo.
    define variable cModelo       as character            no-undo.
    define variable cSearch       as character            no-undo.
    define variable lTodos        as logical              no-undo.

    assign
        orequest     = new JsonAPIRequestParser(oReq)
        oQueryParams = new JsonObject()
        oQueryParams = oReq:getJsonObject("queryParams")
        iStartRow    = oRequest:getStartRow()
        iPageSize    = oRequest:getPageSize()
        iPage        = oRequest:getPage().

    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0194.p persistent set boHandler.
    end.

    if oQueryParams:has("todos") then
        assign lTodos = logical(oQueryParams:GetJsonArray("todos"):getJsonText(1)).
    else     
        assign lTodos = false.

    if oQueryParams:has("placa") and oQueryParams:has("modelo") then do:
        assign cPlaca = string(oQueryParams:GetJsonArray("placa"):getJsonText(1)).
        assign cModelo = string(oQueryParams:GetJsonArray("modelo"):getJsonText(1)).
        run setConstraintPlacaModelo in boHandler (input cPlaca, input cModelo, input lTodos).
        run openQueryStatic          in boHandler (input "PlacaModelo":U).
        run emptyRowErrors           in boHandler.
        run getFirst                 in boHandler.
    end.
    else if oQueryParams:has("placa") then do:
        assign cPlaca = string(oQueryParams:GetJsonArray("placa"):getJsonText(1)).
        run setConstraintPlaca in boHandler (input cPlaca, input lTodos).
        run openQueryStatic    in boHandler (input "Placa":U).
        run emptyRowErrors     in boHandler.
        run getFirst           in boHandler.
    end.
    else if oQueryParams:has("modelo") then do:
         assign cModelo = string(oQueryParams:GetJsonArray("modelo"):getJsonText(1)).
        run setConstraintModelo in boHandler (input cModelo, input lTodos).
        run openQueryStatic     in boHandler (input "Modelo":U).
        run emptyRowErrors      in boHandler.
        run getFirst            in boHandler.
    end.
    else if oQueryParams:has("search") then do:
        assign cSearch = string(oQueryParams:GetJsonArray("search"):getJsonText(1)).
        run setConstraintPlacaModelo in boHandler (input cSearch, input cSearch, input lTodos).
        run openQueryStatic          in boHandler (input "Search":U).
        run emptyRowErrors           in boHandler.
        run getFirst                 in boHandler.
    end.
    else if oQueryParams:has("filter") then do:
        assign cSearch = string(oQueryParams:GetJsonArray("filter"):getJsonText(1)).
        run setConstraintPlacaModelo in boHandler (input cSearch, input cSearch, input lTodos).
        run openQueryStatic          in boHandler (input "Search":U).
        run emptyRowErrors           in boHandler.
        run getFirst                 in boHandler.
    end.
    else do:
        run setConstraintMain in boHandler (input lTodos).
        run openQueryStatic   in boHandler (input "Main":U).
        run emptyRowErrors    in boHandler.
        run getFirst          in boHandler.
    end.

    if return-value = "NOK" then do:
        aJsonArray = new JsonArray().
        assign oRes = JsonApiResponseBuilder:ok(aJsonArray, false).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.
    end.

    if iStartRow > 1 then do:
        assign iContFin = iStartRow - 1.
        do iContIni = 1 to iContFin:
            run getNext in boHandler.
            if return-value = "NOK":U then do:
                run emptyRowErrors in boHandler.
                assign hasNext  = false.
                if  iStartRow > iContIni then
                    assign hasFirst = false.
                leave.
            end.
        end.
    end.
    
    if hasFirst then do:
        run getRowid in boHandler (output rId).
        run getBatchRecords in boHandler( 
            input rId,//parƒmetro de entrada, que indica o rowid a ser reposicionado para o in¡cio da leitura
            input no, //parƒmetro de entrada, que indica se a leitura deve ser feita a partir do pr¢ximo registro
            input iPageSize, //parƒmetro de entrada, que indica o n£mero de registros a serem retornados;
            output iReturnedRows, //parƒmetro de sa¡da, que indica o n£mero de registros retornados
            output table ttVeiculos //parƒmetro de entrada, que cont‚m o handle da temp-table onde serÆo retornados os registros
        ).
        if iReturnedRows < iPageSize then do:
            assign hasNext = false.
        end.
        else do:
            run getFirst in boHandler.
            do iContIni = 1 to (iPage * ipageSize):
                run getNext in boHandler.
                if return-value = "NOK":U then do:
                    run emptyRowErrors in boHandler.
                    assign hasNext = false.
                    leave.
                end.
            end.
        end.
    end.
         
    run getRowErrors in boHandler (output table RowErrors append).

    if valid-handle(boHandler) then
        run destroy in boHandler.

    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
    end.
    else do:
        assign aJsonArray = JsonAPIUtils:ConvertTempTableToJsonArray(temp-table ttVeiculos:handle).

        if oQueryParams:has("transform") then do:
            aJsonArrayRes = new jsonArray().
            do i = 1 to iReturnedRows:
                oJsonObject = new jsonObject().
                oJsonObject = aJsonArray:getJsonObject(i).
                oJsonObject:add('label', oJsonObject:getcharacter('modelo')).
                oJsonObject:add('value', oJsonObject:getcharacter('placa')).
                aJsonArrayRes:add(oJsonObject).
            end.
            assign aJsonArray = aJsonArrayRes.
        end.
        assign oRes = JsonApiResponseBuilder:ok(aJsonArray, hasNext).
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally. 

end procedure.




/*****************************************************************************
                              CADASTRAR VEÖCULO
******************************************************************************/
procedure pi-create:
    define input  param oReq  as JsonObject            no-undo.
    define output param oRes  as JsonObject            no-undo.
    define variable oRequest  as JsonAPIRequestParser  no-undo.
    define variable oPayload  as JsonObject            no-undo.
    define variable msg       as JsonObject            no-undo.
    define variable pType     as char initial "Create" no-undo.
    
    assign 
        oRequest = new JsonAPIRequestParser(oReq)
        oPayload = oRequest:getPayload().
    
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0194.p persistent set boHandler.
    end.

    run openQueryStatic in boHandler (input "Main":U).
    run emptyRowErrors in boHandler.
    create ttVeiculos.
    
    find first ttVeiculos no-lock no-error.
    
    if oPayload:has('placa':U) then do:
        ttVeiculos.placa = oPayload:getCharacter('placa').
    end.
    if oPayload:has('modelo':U) then do:
        ttVeiculos.modelo = oPayload:getCharacter('modelo').
    end.
    if oPayload:has('marca':U) then do:
        ttVeiculos.marca = oPayload:getCharacter('marca').
    end.
    if oPayload:has('ano':U) then do:
        ttVeiculos.ano = oPayload:getInteger('ano').
    end.
    if oPayload:has('cor':U) then do:
        ttVeiculos.cor = oPayload:getCharacter('cor').
    end.
    if oPayload:has('renavam':U) then do:
        ttVeiculos.renavam = oPayload:getCharacter('renavam').
    end.
    if oPayload:has('cod_categ_habilit':U) then do:
        ttVeiculos.cod_categ_habilit = oPayload:getCharacter('cod_categ_habilit').
    end.
    if oPayload:has('ativo':U) then do:
        ttVeiculos.ativo = oPayload:getLogical('ativo').
    end.
    if oPayload:has('disponivel':U) then do:
        ttVeiculos.disponivel = oPayload:getLogical('disponivel').
    end.
    if oPayload:has('km':U) then do:
        ttVeiculos.km = oPayload:getInteger('km').
    end.
    if oPayload:has('proprietario':U) then do:
        ttVeiculos.proprietario = oPayload:getCharacter('proprietario').
    end.
    if oPayload:has('observacoes':U) then do:
        ttVeiculos.observacoes = oPayload:getCharacter('observacoes').
    end.
    if oPayload:has('limp_ext':U) then do:
        ttVeiculos.limp_ext = oPayload:getInteger('limp_ext').
    end.
    if oPayload:has('limp_int':U) then do:
        ttVeiculos.limp_int = oPayload:getInteger('limp_int').
    end.
    if oPayload:has('pneus':U) then do:
        ttVeiculos.pneus = oPayload:getInteger('pneus').
    end.
    if oPayload:has('estepe':U) then do:
        ttVeiculos.estepe = oPayload:getInteger('estepe').
    end.
    if oPayload:has('pintura':U) then do:
        ttVeiculos.pintura = oPayload:getInteger('pintura').
    end.
    if oPayload:has('lataria':U) then do:
        ttVeiculos.lataria = oPayload:getInteger('lataria').
    end.
    if oPayload:has('parachoque_diant':U) then do:
        ttVeiculos.parachoque_diant = oPayload:getInteger('parachoque_diant').
    end.
    if oPayload:has('parachoque_tras':U) then do:
        ttVeiculos.parachoque_tras = oPayload:getInteger('parachoque_tras').
    end.
    if oPayload:has('farol_alto':U) then do:
        ttVeiculos.farol_alto = oPayload:getInteger('farol_alto').
    end.
    if oPayload:has('farol_baixo':U) then do:
        ttVeiculos.farol_baixo = oPayload:getInteger('farol_baixo').
    end.
    if oPayload:has('setas':U) then do:
        ttVeiculos.setas = oPayload:getInteger('setas').
    end.
    if oPayload:has('luz_re':U) then do:
        ttVeiculos.luz_re = oPayload:getInteger('luz_re').
    end.
    if oPayload:has('agua_limp':U) then do:
        ttVeiculos.agua_limp = oPayload:getInteger('agua_limp').
    end.
    if oPayload:has('agua_rad':U) then do:
        ttVeiculos.agua_rad = oPayload:getInteger('agua_rad').
    end.
    if oPayload:has('embreagem':U) then do:
        ttVeiculos.embreagem = oPayload:getInteger('embreagem').
    end.
    if oPayload:has('cambio':U) then do:
        ttVeiculos.cambio = oPayload:getInteger('cambio').
    end.
    if oPayload:has('freio':U) then do:
        ttVeiculos.freio = oPayload:getInteger('freio').
    end.
    if oPayload:has('oleo_freio':U) then do:
        ttVeiculos.oleo_freio = oPayload:getInteger('oleo_freio').
    end.
    if oPayload:has('oleo_motor':U) then do:
        ttVeiculos.oleo_motor = oPayload:getInteger('oleo_motor').
    end.
    if oPayload:has('combustivel':U) then do:
        ttVeiculos.combustivel = oPayload:getInteger('combustivel').
    end.
    if oPayload:has('parabrisa':U) then do:
        ttVeiculos.parabrisa = oPayload:getInteger('parabrisa').
    end.
    if oPayload:has('alarme':U) then do:
        ttVeiculos.alarme = oPayload:getInteger('alarme').
    end.
    if oPayload:has('buzina':U) then do:
        ttVeiculos.buzina = oPayload:getInteger('buzina').
    end.
    if oPayload:has('cintos':U) then do:
        ttVeiculos.cintos = oPayload:getInteger('cintos').
    end.
    if oPayload:has('documentos':U) then do:
        ttVeiculos.documentos = oPayload:getInteger('documentos').
    end.
    if oPayload:has('extintor':U) then do:
        ttVeiculos.extintor = oPayload:getInteger('extintor').
    end.
    if oPayload:has('limpadores':U) then do:
        ttVeiculos.limpadores = oPayload:getInteger('limpadores').
    end.
    if oPayload:has('macaco':U) then do:
        ttVeiculos.macaco = oPayload:getInteger('macaco').
    end.
    if oPayload:has('chave_roda':U) then do:
        ttVeiculos.chave_roda = oPayload:getInteger('chave_roda').
    end.
    if oPayload:has('retrov_ext':U) then do:
        ttVeiculos.retrov_ext = oPayload:getInteger('retrov_ext').
    end.
    if oPayload:has('retrov_int':U) then do:
        ttVeiculos.retrov_int = oPayload:getInteger('retrov_int').         
    end.

    run setRecord      in boHandler (input table ttVeiculos).
    run validateRecord in boHandler (input pType).
    run getRowErrors   in boHandler (output table RowErrors append).

    if not can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        run createRecord in boHandler.
        run getRowErrors   in boHandler (output table RowErrors append).
    end.

    if valid-handle(boHandler) then
        run destroy in boHandler.

    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
    end.
    else do :
        msg = new JSONObject().
        msg:add("code", 2).
        msg:add("message", "Ve¡culo Cadastrado!").
        msg:add("detailedMessage", "Ve¡culo " + ttVeiculos.placa  + " cadastrado com sucesso!").
        assign oRes = JsonApiResponseBuilder:ok(msg, 201).
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally. 
    
end procedure.
 
/*****************************************************************************
                            ATUALIZAR VEÖCULO
******************************************************************************/
procedure pi-update:
    define input  param oReq  as JsonObject            no-undo.                                                                   
    define output param oRes  as JsonObject            no-undo.                                                                   
    define variable oRequest  as JsonAPIRequestParser  no-undo.                                                                   
    define variable oPayload  as JsonObject            no-undo.                                                                   
    define variable msg       as JsonObject            no-undo.
    define variable msgArray  as JsonArray             no-undo.
    define variable pType     as char initial "Update" no-undo.                                                                   
    define variable pathParam as character             no-undo.
    define variable lTodos    as logical initial true  no-undo.
                                                                                                                                  
    assign 
        oRequest  = new JsonAPIRequestParser(oReq)                                                                            
        oPayload  = oRequest:getPayload()                                                                                     
        pathParam = oRequest:getPathParams():GetCharacter(1).                                                          
                                                                                                                                  
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0194.p persistent set boHandler.
    end.                                                                
    
    run setConstraintMain in boHandler (input lTodos).
    run openQueryStatic   in boHandler (input "Main":U).                                                                        
    run emptyRowErrors    in boHandler.                                                                                              
    run goToKey           in boHandler (input pathParam).                                                                                   
                                                                                                                                  
    if return-value = "NOK" then do:
        assign
            msgArray = new JsonArray()
            msg      = new JsonObject().
        
        msg:add("ErrorHelp", "Ve¡culo placa " + pathParam  + " nÆo encontrado na base de dados!").
        msg:add("ErrorNumber", 1).
        msg:add("ErrorDescription", "Ve¡culo nÆo encontrado!").
        msg:add("ErrorSubType", "error").
        msgArray:Add(msg).
        assign oRes = JsonApiResponseBuilder:asError(msgArray, 404).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.                                                                                                               
    end.                                                                                                                          
                                                                                                                                  
    run getRecord in boHandler (output table ttVeiculos).

    find first ttVeiculos no-lock no-error.

    if oPayload:has('modelo':U) then do:
        ttVeiculos.modelo = oPayload:getCharacter('modelo').
    end.
    if oPayload:has('marca':U) then do:
        ttVeiculos.marca = oPayload:getCharacter('marca').
    end.
    if oPayload:has('ano':U) then do:
        ttVeiculos.ano = oPayload:getInteger('ano').
    end.
    if oPayload:has('cor':U) then do:
        ttVeiculos.cor = oPayload:getCharacter('cor').
    end.
    if oPayload:has('renavam':U) then do:
        ttVeiculos.renavam = oPayload:getCharacter('renavam').
    end.
    if oPayload:has('cod_categ_habilit':U) then do:
        ttVeiculos.cod_categ_habilit = oPayload:getCharacter('cod_categ_habilit').
    end.
    if oPayload:has('ativo':U) then do:
        ttVeiculos.ativo = oPayload:getLogical('ativo').
    end.
    if oPayload:has('disponivel':U) then do:
        ttVeiculos.disponivel = oPayload:getLogical('disponivel').
    end.
    if oPayload:has('km':U) then do:
        ttVeiculos.km = oPayload:getInteger('km').
    end.
    if oPayload:has('proprietario':U) then do:
        ttVeiculos.proprietario = oPayload:getCharacter('proprietario').
    end.
    if oPayload:has('observacoes':U) then do:
        ttVeiculos.observacoes = oPayload:getCharacter('observacoes').
    end.
    if oPayload:has('limp_ext':U) then do:
        ttVeiculos.limp_ext = oPayload:getInteger('limp_ext').
    end.
    if oPayload:has('limp_int':U) then do:
        ttVeiculos.limp_int = oPayload:getInteger('limp_int').
    end.
    if oPayload:has('pneus':U) then do:
        ttVeiculos.pneus = oPayload:getInteger('pneus').
    end.
    if oPayload:has('estepe':U) then do:
        ttVeiculos.estepe = oPayload:getInteger('estepe').
    end.
    if oPayload:has('pintura':U) then do:
        ttVeiculos.pintura = oPayload:getInteger('pintura').
    end.
    if oPayload:has('lataria':U) then do:
        ttVeiculos.lataria = oPayload:getInteger('lataria').
    end.
    if oPayload:has('parachoque_diant':U) then do:
        ttVeiculos.parachoque_diant = oPayload:getInteger('parachoque_diant').
    end.
    if oPayload:has('parachoque_tras':U) then do:
        ttVeiculos.parachoque_tras = oPayload:getInteger('parachoque_tras').
    end.
    if oPayload:has('farol_alto':U) then do:
        ttVeiculos.farol_alto = oPayload:getInteger('farol_alto').
    end.
    if oPayload:has('farol_baixo':U) then do:
        ttVeiculos.farol_baixo = oPayload:getInteger('farol_baixo').
    end.
    if oPayload:has('setas':U) then do:
        ttVeiculos.setas = oPayload:getInteger('setas').
    end.
    if oPayload:has('luz_re':U) then do:
        ttVeiculos.luz_re = oPayload:getInteger('luz_re').
    end.
    if oPayload:has('agua_limp':U) then do:
        ttVeiculos.agua_limp = oPayload:getInteger('agua_limp').
    end.
    if oPayload:has('agua_rad':U) then do:
        ttVeiculos.agua_rad = oPayload:getInteger('agua_rad').
    end.
    if oPayload:has('embreagem':U) then do:
        ttVeiculos.embreagem = oPayload:getInteger('embreagem').
    end.
    if oPayload:has('cambio':U) then do:
        ttVeiculos.cambio = oPayload:getInteger('cambio').
    end.
    if oPayload:has('freio':U) then do:
        ttVeiculos.freio = oPayload:getInteger('freio').
    end.
    if oPayload:has('oleo_freio':U) then do:
        ttVeiculos.oleo_freio = oPayload:getInteger('oleo_freio').
    end.
    if oPayload:has('oleo_motor':U) then do:
        ttVeiculos.oleo_motor = oPayload:getInteger('oleo_motor').
    end.
    if oPayload:has('combustivel':U) then do:
        ttVeiculos.combustivel = oPayload:getInteger('combustivel').
    end.
    if oPayload:has('parabrisa':U) then do:
        ttVeiculos.parabrisa = oPayload:getInteger('parabrisa').
    end.
    if oPayload:has('alarme':U) then do:
        ttVeiculos.alarme = oPayload:getInteger('alarme').
    end.
    if oPayload:has('buzina':U) then do:
        ttVeiculos.buzina = oPayload:getInteger('buzina').
    end.
    if oPayload:has('cintos':U) then do:
        ttVeiculos.cintos = oPayload:getInteger('cintos').
    end.
    if oPayload:has('documentos':U) then do:
        ttVeiculos.documentos = oPayload:getInteger('documentos').
    end.
    if oPayload:has('extintor':U) then do:
        ttVeiculos.extintor = oPayload:getInteger('extintor').
    end.
    if oPayload:has('limpadores':U) then do:
        ttVeiculos.limpadores = oPayload:getInteger('limpadores').
    end.
    if oPayload:has('macaco':U) then do:
        ttVeiculos.macaco = oPayload:getInteger('macaco').
    end.
    if oPayload:has('chave_roda':U) then do:
        ttVeiculos.chave_roda = oPayload:getInteger('chave_roda').
    end.
    if oPayload:has('retrov_ext':U) then do:
        ttVeiculos.retrov_ext = oPayload:getInteger('retrov_ext').
    end.
    if oPayload:has('retrov_int':U) then do:
        ttVeiculos.retrov_int = oPayload:getInteger('retrov_int').         
    end.

    run setRecord      in boHandler (input table ttVeiculos).
    run validateRecord in boHandler (input pType).
    run getRowErrors   in boHandler (output table RowErrors append).

    if not can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        run updateRecord in boHandler.
        run getRowErrors   in boHandler (output table RowErrors append).
    end.

    if valid-handle(boHandler) then
        run destroy in boHandler.

    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
    end.
    else do :
        msg = new JSONObject().
        msg:add("code", 3).
        msg:add("message", "Ve¡culo Atualizado!").
        msg:add("detailedMessage", "Ve¡culo " + ttVeiculos.placa  + " atualizado com sucesso!").
        assign oRes = JsonApiResponseBuilder:ok(msg, 200). 
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally. 
end procedure.

/*****************************************************************************
                             ELIMINAR VEÖCULO
******************************************************************************/
procedure pi-delete:
    define input  param oReq   as JsonObject           no-undo.
    define output param oRes   as JsonObject           no-undo.
    define variable aJsonArray as JsonArray            no-undo.
    define variable pathParam  as character            no-undo.
    define variable msg        as JsonObject           no-undo.
    define variable msgArray   as JsonArray            no-undo.
    define variable oRequest   as JsonAPIRequestParser no-undo.
    define variable lTodos     as logical initial true no-undo.
    
    assign 
        oRequest = new JsonAPIRequestParser(oReq)
        pathParam = oRequest:getPathParams():GetCharacter(1).

    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0194.p persistent set boHandler.
    end.

    run setConstraintMain in boHandler (input lTodos).
    run openQueryStatic   in boHandler (input "Main":U).
    run emptyRowErrors    in boHandler.
    run goToKey           in boHandler (input pathParam).
    
    if return-value = "OK" then do:
        run deleteRecord in boHandler.
        run getRowErrors in boHandler (output table RowErrors append).   
    end.
    else do:
        assign
            msgArray = new JsonArray()
            msg      = new JsonObject().
        
        msg:add("ErrorHelp", "Ve¡culo placa " + pathParam  + " nÆo encontrado na base de dados!").
        msg:add("ErrorNumber", 1).
        msg:add("ErrorDescription", "Ve¡culo nÆo encontrado!").
        msg:add("ErrorSubType", "error").
        msgArray:Add(msg).
        assign oRes = JsonApiResponseBuilder:asError(msgArray, 404).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.
    end.
    
    if valid-handle(boHandler) then
        run destroy in boHandler.

    if can-find(first RowErrors 
                where upper(RowErrors.ErrorSubType) = 'ERROR':U 
                and RowErrors.ErrorNumber <> 10
                and RowErrors.ErrorNumber <> 3
                and RowErrors.ErrorNumber <> 8) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
    end.
    else do :
        assign oRes = JsonApiResponseBuilder:empty(204).   
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally.
end procedure.

