using Progress.Json.ObjectModel.*.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using progress.Lang.error.
using com.totvs.framework.api.*.

{cstp/api/v1/services/environments.i}

{utp/ut-api.i}
{utp/ut-api-action.i pi-logbook-metadata get /diario/metadata/~* }
{utp/ut-api-action.i pi-metadata get /metadata/~* }
{utp/ut-api-action.i pi-upload-file post /upload/~* }
{utp/ut-api-action.i pi-logbook-list get /diario/~* }
{utp/ut-api-action.i pi-evaluator-find get /avaliador/~*/~* }
{utp/ut-api-action.i pi-evaluator-list get /avaliador/~* }
{utp/ut-api-action.i pi-find get /~*/~* }
{utp/ut-api-action.i pi-list get /~* }
{utp/ut-api-action.i pi-create post /~* } 
{utp/ut-api-action.i pi-update put /~*/~* } 
{utp/ut-api-action.i pi-delete delete /~*/~* }
{utp/ut-api-notfound.i}

{method/dbotterr.i}

{cstp/api/v1/services/bocst0200.i ttChecklist}
{cstp/api/v1/services/bopy085.i ttAvaliador}
{cstp/api/v1/services/checklist-metadata.i}
{cstp/api/v1/services/diario-metadata.i}

define variable boHandler as handle no-undo.


/*****************************************************************************
                              UPLOAD ARQUIVO
******************************************************************************/
procedure pi-upload-file:

    define input  param oReq       as JsonObject           no-undo.
    define output param oRes       as JsonObject           no-undo.
    define variable msg            as JsonObject           no-undo.
    define variable msgArray       as JsonArray            no-undo.
    define variable cFileContent   as longchar             no-undo.
    define variable cFileName      as character            no-undo.
    define variable oMultiPartFile as JsonObject           no-undo.
    define variable oQueryParams   as JsonObject           no-undo.
    define variable oRequest       as JsonAPIRequestParser no-undo.
    define variable iMatricula     as integer initial 0    no-undo.

    assign
        oRequest       = new JsonAPIRequestParser(oReq)
        oQueryParams   = new JsonObject()
        oQueryParams   = oReq:getJsonObject("queryParams")
        oMultiPartFile = new JsonObject()
        oMultiPartFile = oReq:GetJsonArray("multiPartFile"):getJsonObject(1).
    
    if oQueryParams:GetJsonArray("data"):getJsonText(1) <> "" then

        iMatricula = integer(oQueryParams:GetJsonArray("data"):getJsonText(1)).
    
    if  oMultiPartFile:has('fileName':U) 
    and oMultiPartFile:has('content':U) then do:

        assign
        cFileName    = oMultiPartFile:getCharacter('fileName')
        cFileContent = oMultiPartFile:getLongchar('content').
    end.
    
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0200.p persistent set boHandler.
    end.
   
    run saveAnexo    in boHandler (input cFileName, input cFileContent, input iMatricula).
    run getRowErrors in boHandler (output table RowErrors append).

    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
        return.
    end.
    else do :
        msg = new JsonObject().
        msg:add("code", 2).
        msg:add("message", "Arquivo enviado com sucesso!").
        msg:add("detailedMessage", "Arquivo salvo no hist¢rico do Condutor!").
        assign oRes = JsonApiResponseBuilder:ok(msg, 201).
        return.
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally. 
    
end procedure.



/*****************************************************************************
                            PESQUISAR CHECKLIST
******************************************************************************/
procedure pi-find:
    define input  param oReq       as JsonObject           no-undo.
    define output param oRes       as JsonObject           no-undo.
    define variable oJsonObject    as JsonObject           no-undo.
    define variable oJsonObjectRes as JsonObject           no-undo.
    define variable cPathParams    as character            no-undo.
    define variable iAgendamento   as integer              no-undo.
    define variable iTipo          as integer              no-undo.
    define variable msg            as JsonObject           no-undo.
    define variable msgArray       as JsonArray            no-undo.
    define variable oRequest       as JsonAPIRequestParser no-undo.
    
    assign
        oRequest     = new JsonAPIRequestParser(oReq)
        cPathParams  = oRequest:getPathParams():GetCharacter(1)
        iAgendamento = integer(entry(1, cPathParams, "|"))
        iTipo        = integer(entry(2, cPathParams, "|")).
    
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0200.p persistent set boHandler.
    end.
   
    run openQueryStatic in boHandler (input "Main":U).
    run emptyRowErrors  in boHandler.
    run getRowErrors    in boHandler (output table RowErrors append).
    run goToKey         in boHandler (input iAgendamento, input iTipo).

    if upper(return-value) = "OK":U then do:
        run getRecord in boHandler (output table ttChecklist).
        assign
            oJsonObject    = new jsonObject()
            oJsonObjectRes = new jsonObject()
            oJsonObject    = JsonAPIUtils:ConvertTempTableToJsonObject(temp-table ttChecklist:handle)
            oJsonObjectRes = oJsonObject:getJsonArray("ttChecklist"):getJsonObject(1).
        
        for first cst_veiculos_agendamento
        fields (placa condutor destino motivo)
        no-lock
        where cst_veiculos_agendamento.agendamento_id = oJsonObjectRes:getinteger('agendamento_id'):
            oJsonObjectRes:add('placa', cst_veiculos_agendamento.placa).
            oJsonObjectRes:add('condutor', cst_veiculos_agendamento.condutor).
            oJsonObjectRes:add('destino', cst_veiculos_agendamento.destino).
            oJsonObjectRes:add('motivo', cst_veiculos_agendamento.motivo).
        end.
       
        for first cst_veiculos
        fields (modelo)
        no-lock
        where cst_veiculos.placa = cst_veiculos_agendamento.placa:
            oJsonObjectRes:add('modelo', cst_veiculos.modelo).
        end.

        for first funcionario
        fields (nom_pessoa_fisic)
        no-lock
        where funcionario.cdn_funcionario = cst_veiculos_agendamento.condutor:
            oJsonObjectRes:add('nome_condutor', funcionario.nom_pessoa_fisic).
        end.

        for first funcionario 
        fields (nom_pessoa_fisic)
        no-lock
        where funcionario.cdn_funcionario = oJsonObjectRes:getinteger('avaliador'):
            oJsonObjectRes:add('nome_avaliador', funcionario.nom_pessoa_fisic).
        end.
       
        assign oRes = JsonApiResponseBuilder:ok(oJsonObjectRes, 200).
            
        if valid-handle(boHandler) then
            run destroy in boHandler.

        return.
    end.
    else do:
        assign
            msgArray = new JsonArray()
            msg      = new JsonObject().
        
        msg:add("ErrorHelp", "Checklist nÆo encontrado na base de dados!").
        msg:add("ErrorNumber", 1).
        msg:add("ErrorDescription", "Checklist nÆo encontrado!").
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
   
    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally.

end procedure.


/*****************************************************************************
                            LISTAR CHECKLISTS
******************************************************************************/
procedure pi-list:
    define input  param oReq      as JsonObject           no-undo.
    define output param oRes      as JsonObject           no-undo.
    define variable aJsonArray    as JsonArray            no-undo.
    define variable msg           as JsonObject           no-undo.
    define variable msgArray      as JsonArray            no-undo.
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
    define variable cHora         as character            no-undo.
    define variable aJsonArrayRes as JsonArray            no-undo.
    define variable i             as integer              no-undo.
    define variable oJsonObject   as JsonObject           no-undo.
    define variable oQueryParams  as JsonObject           no-undo.
    define variable cModelo       as character            no-undo.
    define variable cCondutor     as character            no-undo.
    define variable iAgendamento  as integer              no-undo.
    define variable cSearch       as character            no-undo.

    assign
        orequest     = new JsonAPIRequestParser(oReq)
        oQueryParams = new JsonObject()
        oQueryParams = oReq:getJsonObject("queryParams")
        iStartRow    = oRequest:getStartRow()
        iPageSize    = oRequest:getPageSize()
        iPage        = oRequest:getPage().
    
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0200.p persistent set boHandler.
    end.

    if oQueryParams:has("modelo") and oQueryParams:has("nome_condutor") then do:
        assign 
            cModelo   = string(oQueryParams:GetJsonArray("modelo"):getJsonText(1))
            cCondutor = string(oQueryParams:GetJsonArray("nome_condutor"):getJsonText(1)).

        run setConstraintModeloCondutor in boHandler (input cModelo, input cCondutor).
        run openQueryStatic             in boHandler (input "ModeloCondutor":U).
        run emptyRowErrors              in boHandler.
        run getFirst                    in boHandler.
    end.
    else if oQueryParams:has("modelo") then do:
        assign cModelo = string(oQueryParams:GetJsonArray("modelo"):getJsonText(1)).
        run setConstraintModelo in boHandler (input cModelo).
        run openQueryStatic     in boHandler (input "Modelo":U).
        run emptyRowErrors      in boHandler.
        run getFirst            in boHandler.
    end.
    else if oQueryParams:has("agendamento_id") then do:
        assign iAgendamento = integer(oQueryParams:GetJsonArray("agendamento_id"):getJsonText(1)).
        run setConstraintAgendamento in boHandler (input iAgendamento).
        run openQueryStatic          in boHandler (input "Agendamento":U).
        run emptyRowErrors           in boHandler.
        run getFirst                 in boHandler.
    end.
    else if oQueryParams:has("nome_condutor") then do:
        assign cCondutor = string(oQueryParams:GetJsonArray("nome_condutor"):getJsonText(1)).
        run setConstraintCondutor in boHandler (input cCondutor).
        run openQueryStatic       in boHandler (input "Condutor":U).
        run emptyRowErrors        in boHandler.
        run getFirst              in boHandler.
    end.
    else if oQueryParams:has("search") then do:
        assign
            cSearch      = string(oQueryParams:GetJsonArray("search"):getJsonText(1))
            iAgendamento = integer(cSearch) no-error.
        if error-status:error then do:
            run setConstraintModeloCondutor in boHandler (input cSearch, input cSearch).
            run openQueryStatic             in boHandler (input "Search":U).
            run emptyRowErrors              in boHandler.
            run getFirst                    in boHandler.
        end.
        else do:
            run setConstraintAgendamento in boHandler (input iAgendamento).
            run openQueryStatic          in boHandler (input "Agendamento":U).
            run emptyRowErrors           in boHandler.
            run getFirst                 in boHandler.
        end.
    end.
    else do:
        run openQueryStatic in boHandler (input "Main":U).
        run emptyRowErrors  in boHandler.
        run getFirst        in boHandler.
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
        run getRowid        in boHandler (output rId).
        run getBatchRecords in boHandler( 
            input rId,//parƒmetro de entrada, que indica o rowid a ser reposicionado para o in¡cio da leitura
            input no, //parƒmetro de entrada, que indica se a leitura deve ser feita a partir do pr¢ximo registro
            input iPageSize, //parƒmetro de entrada, que indica o n£mero de registros a serem retornados;
            output iReturnedRows, //parƒmetro de sa¡da, que indica o n£mero de registros retornados
            output table ttChecklist //parƒmetro de entrada, que cont‚m o handle da temp-table onde serÆo retornados os registros
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
    else do :
        assign
            aJsonArray = JsonAPIUtils:ConvertTempTableToJsonArray(temp-table ttChecklist:handle).
            aJsonArrayRes = new jsonArray().
        do i = 1 to iReturnedRows:
            oJsonObject = new jsonObject().
            oJsonObject = aJsonArray:getJsonObject(i).
                    
            for first cst_veiculos_agendamento
            fields (placa condutor)
            no-lock
            where cst_veiculos_agendamento.agendamento_id = oJsonObject:getinteger('agendamento_id'):

                oJsonObject:add('placa', cst_veiculos_agendamento.placa).
                oJsonObject:add('condutor', cst_veiculos_agendamento.condutor).
            end.
            
            for first cst_veiculos
            fields (modelo)
            no-lock
            where cst_veiculos.placa = cst_veiculos_agendamento.placa:
                oJsonObject:add('modelo', cst_veiculos.modelo).
            end.

            for first funcionario
            fields (nom_pessoa_fisic)
            no-lock
            where funcionario.cdn_funcionario = cst_veiculos_agendamento.condutor:
                oJsonObject:add('nome_condutor', funcionario.nom_pessoa_fisic).
            end.

            for first funcionario
            fields (nom_pessoa_fisic)
            no-lock
            where funcionario.cdn_funcionario = oJsonObject:getinteger('avaliador'):
                oJsonObject:add('nome_avaliador', funcionario.nom_pessoa_fisic).
            end.
            
            aJsonArrayRes:add(oJsonObject).
        end.
        assign aJsonArray = aJsonArrayRes.
        assign oRes = JsonApiResponseBuilder:ok(aJsonArray, hasNext).
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally. 

end procedure.


/*****************************************************************************
                            CADASTRAR CHECKLIST
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
        run {&prefix}services/bocst0200.p persistent set boHandler.
    end.

    run openQueryStatic in boHandler (input "Main":U).
    run emptyRowErrors  in boHandler.
    create ttChecklist.
    
    find first ttChecklist no-lock no-error.
    
    if oPayload:has('agendamento_id':U) then do:
        ttChecklist.agendamento_id = oPayload:getInteger('agendamento_id').
    end.
    if oPayload:has('tipo':U) then do:
        ttChecklist.tipo = oPayload:getInteger('tipo').
    end.
    if oPayload:has('avaliador':U) then do:
        ttChecklist.avaliador = oPayload:getInteger('avaliador').
    end.
    if oPayload:has('dt_checklist':U) then do:
        ttChecklist.dt_checklist = oPayload:getDate('dt_checklist').
    end.
    if oPayload:has('hr_checklist':U) then do:
        ttChecklist.hr_checklist = oPayload:getCharacter('hr_checklist').
    end.
    if oPayload:has('km':U) then do:
        ttChecklist.km = oPayload:getInteger('km').
    end.
    if oPayload:has('observacoes':U) then do:
        ttChecklist.observacoes = oPayload:getCharacter('observacoes').
    end.
    if oPayload:has('limp_ext':U) then do:
        ttChecklist.limp_ext = oPayload:getInteger('limp_ext').
    end.
    if oPayload:has('limp_int':U) then do:
        ttChecklist.limp_int = oPayload:getInteger('limp_int').
    end.
    if oPayload:has('pneus':U) then do:
        ttChecklist.pneus = oPayload:getInteger('pneus').
    end.
    if oPayload:has('estepe':U) then do:
        ttChecklist.estepe = oPayload:getInteger('estepe').
    end.
    if oPayload:has('pintura':U) then do:
        ttChecklist.pintura = oPayload:getInteger('pintura').
    end.
    if oPayload:has('lataria':U) then do:
        ttChecklist.lataria = oPayload:getInteger('lataria').
    end.
    if oPayload:has('parachoque_diant':U) then do:
        ttChecklist.parachoque_diant = oPayload:getInteger('parachoque_diant').
    end.
    if oPayload:has('parachoque_tras':U) then do:
        ttChecklist.parachoque_tras = oPayload:getInteger('parachoque_tras').
    end.
    if oPayload:has('farol_alto':U) then do:
        ttChecklist.farol_alto = oPayload:getInteger('farol_alto').
    end.
    if oPayload:has('farol_baixo':U) then do:
        ttChecklist.farol_baixo = oPayload:getInteger('farol_baixo').
    end.
    if oPayload:has('setas':U) then do:
        ttChecklist.setas = oPayload:getInteger('setas').
    end.
    if oPayload:has('luz_re':U) then do:
        ttChecklist.luz_re = oPayload:getInteger('luz_re').
    end.
    if oPayload:has('agua_limp':U) then do:
        ttChecklist.agua_limp = oPayload:getInteger('agua_limp').
    end.
    if oPayload:has('agua_rad':U) then do:
        ttChecklist.agua_rad = oPayload:getInteger('agua_rad').
    end.
    if oPayload:has('embreagem':U) then do:
        ttChecklist.embreagem = oPayload:getInteger('embreagem').
    end.
    if oPayload:has('cambio':U) then do:
        ttChecklist.cambio = oPayload:getInteger('cambio').
    end.
    if oPayload:has('freio':U) then do:
        ttChecklist.freio = oPayload:getInteger('freio').
    end.
    if oPayload:has('oleo_freio':U) then do:
        ttChecklist.oleo_freio = oPayload:getInteger('oleo_freio').
    end.
    if oPayload:has('oleo_motor':U) then do:
        ttChecklist.oleo_motor = oPayload:getInteger('oleo_motor').
    end.
    if oPayload:has('combustivel':U) then do:
        ttChecklist.combustivel = oPayload:getInteger('combustivel').
    end.
    if oPayload:has('parabrisa':U) then do:
        ttChecklist.parabrisa = oPayload:getInteger('parabrisa').
    end.
    if oPayload:has('alarme':U) then do:
        ttChecklist.alarme = oPayload:getInteger('alarme').
    end.
    if oPayload:has('buzina':U) then do:
        ttChecklist.buzina = oPayload:getInteger('buzina').
    end.
    if oPayload:has('cintos':U) then do:
        ttChecklist.cintos = oPayload:getInteger('cintos').
    end.
    if oPayload:has('documentos':U) then do:
        ttChecklist.documentos = oPayload:getInteger('documentos').
    end.
    if oPayload:has('extintor':U) then do:
        ttChecklist.extintor = oPayload:getInteger('extintor').
    end.
    if oPayload:has('limpadores':U) then do:
        ttChecklist.limpadores = oPayload:getInteger('limpadores').
    end.
    if oPayload:has('macaco':U) then do:
        ttChecklist.macaco = oPayload:getInteger('macaco').
    end.
    if oPayload:has('chave_roda':U) then do:
        ttChecklist.chave_roda = oPayload:getInteger('chave_roda').
    end.
    if oPayload:has('retrov_ext':U) then do:
        ttChecklist.retrov_ext = oPayload:getInteger('retrov_ext').
    end.
    if oPayload:has('retrov_int':U) then do:
        ttChecklist.retrov_int = oPayload:getInteger('retrov_int').         
    end.

    run setRecord      in boHandler (input table ttChecklist).
    run validateRecord in boHandler (input pType).
    run getRowErrors   in boHandler (output table RowErrors append).

    if not can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        run createRecord in boHandler.
        run getRowErrors in boHandler (output table RowErrors append).
    end.

    if valid-handle(boHandler) then
        run destroy in boHandler.

    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
    end.
    else do :
        msg = new JsonObject().
        msg:add("code", 2).
        msg:add("message", "Checklist Cadastrado!").
        msg:add("detailedMessage", "Checklist cadastrado com sucesso!").
        assign oRes = JsonApiResponseBuilder:ok(msg, 201).
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally. 
    
end procedure.
 

/*****************************************************************************
                            ATUALIZAR CHECKLIST
******************************************************************************/
procedure pi-update:
    define input  param oReq     as JsonObject            no-undo.                                                                   
    define output param oRes     as JsonObject            no-undo.                                                                   
    define variable oRequest     as JsonAPIRequestParser  no-undo.                                                                   
    define variable oPayload     as JsonObject            no-undo.                                                                   
    define variable msg          as JsonObject            no-undo.
    define variable msgArray     as JsonArray             no-undo.
    define variable pType        as char initial "Update" no-undo.
    define variable cPathParams  as character             no-undo.
    define variable iAgendamento as integer               no-undo.
    define variable iTipo        as integer               no-undo.                                                                   
                                                                                                                                  
    assign
        oRequest     = new JsonAPIRequestParser(oReq)                                                                            
        oPayload     = oRequest:getPayload()                                                                                     
        cPathParams  = oRequest:getPathParams():GetCharacter(1)
        iAgendamento = integer(entry(1, cPathParams, "|"))
        iTipo        = integer(entry(2, cPathParams, "|")).                                                          
                                                                                                                                  
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0200.p persistent set boHandler.
    end.                                                                
    
    run openQueryStatic in boHandler (input "Main":U).                                                                        
    run emptyRowErrors  in boHandler.                                                                                              
    run goToKey         in boHandler (input iAgendamento, input iTipo).                                                                                   
                                                                                                                                  
    if return-value = "NOK" then do:
        assign
            msgArray = new JsonArray()
            msg      = new JsonObject().
        
        msg:add("ErrorHelp", "Checklist nÆo encontrado na base de dados!").
        msg:add("ErrorNumber", 1).
        msg:add("ErrorDescription", "Checklist nÆo encontrado!").
        msg:add("ErrorSubType", "error").
        msgArray:Add(msg).
        assign oRes = JsonApiResponseBuilder:asError(msgArray, 404).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.                                                                                                               
    end.                                                                                                                          
                                                                                                                                  
    run getRecord in boHandler (output table ttChecklist).

    find first ttChecklist no-lock no-error.

    if oPayload:has('avaliador':U) then do:
        ttChecklist.avaliador = oPayload:getInteger('avaliador').
    end.
    if oPayload:has('dt_checklist':U) then do:
        ttChecklist.dt_checklist = oPayload:getDate('dt_checklist').
    end.
    if oPayload:has('hr_checklist':U) then do:
        ttChecklist.hr_checklist = oPayload:getCharacter('hr_checklist').
    end.
    if oPayload:has('km':U) then do:
        ttChecklist.km = oPayload:getInteger('km').
    end.
    if oPayload:has('observacoes':U) then do:
        ttChecklist.observacoes = oPayload:getCharacter('observacoes').
    end.
    if oPayload:has('limp_ext':U) then do:
        ttChecklist.limp_ext = oPayload:getInteger('limp_ext').
    end.
    if oPayload:has('limp_int':U) then do:
        ttChecklist.limp_int = oPayload:getInteger('limp_int').
    end.
    if oPayload:has('pneus':U) then do:
        ttChecklist.pneus = oPayload:getInteger('pneus').
    end.
    if oPayload:has('estepe':U) then do:
        ttChecklist.estepe = oPayload:getInteger('estepe').
    end.
    if oPayload:has('pintura':U) then do:
        ttChecklist.pintura = oPayload:getInteger('pintura').
    end.
    if oPayload:has('lataria':U) then do:
        ttChecklist.lataria = oPayload:getInteger('lataria').
    end.
    if oPayload:has('parachoque_diant':U) then do:
        ttChecklist.parachoque_diant = oPayload:getInteger('parachoque_diant').
    end.
    if oPayload:has('parachoque_tras':U) then do:
        ttChecklist.parachoque_tras = oPayload:getInteger('parachoque_tras').
    end.
    if oPayload:has('farol_alto':U) then do:
        ttChecklist.farol_alto = oPayload:getInteger('farol_alto').
    end.
    if oPayload:has('farol_baixo':U) then do:
        ttChecklist.farol_baixo = oPayload:getInteger('farol_baixo').
    end.
    if oPayload:has('setas':U) then do:
        ttChecklist.setas = oPayload:getInteger('setas').
    end.
    if oPayload:has('luz_re':U) then do:
        ttChecklist.luz_re = oPayload:getInteger('luz_re').
    end.
    if oPayload:has('agua_limp':U) then do:
        ttChecklist.agua_limp = oPayload:getInteger('agua_limp').
    end.
    if oPayload:has('agua_rad':U) then do:
        ttChecklist.agua_rad = oPayload:getInteger('agua_rad').
    end.
    if oPayload:has('embreagem':U) then do:
        ttChecklist.embreagem = oPayload:getInteger('embreagem').
    end.
    if oPayload:has('cambio':U) then do:
        ttChecklist.cambio = oPayload:getInteger('cambio').
    end.
    if oPayload:has('freio':U) then do:
        ttChecklist.freio = oPayload:getInteger('freio').
    end.
    if oPayload:has('oleo_freio':U) then do:
        ttChecklist.oleo_freio = oPayload:getInteger('oleo_freio').
    end.
    if oPayload:has('oleo_motor':U) then do:
        ttChecklist.oleo_motor = oPayload:getInteger('oleo_motor').
    end.
    if oPayload:has('combustivel':U) then do:
        ttChecklist.combustivel = oPayload:getInteger('combustivel').
    end.
    if oPayload:has('parabrisa':U) then do:
        ttChecklist.parabrisa = oPayload:getInteger('parabrisa').
    end.
    if oPayload:has('alarme':U) then do:
        ttChecklist.alarme = oPayload:getInteger('alarme').
    end.
    if oPayload:has('buzina':U) then do:
        ttChecklist.buzina = oPayload:getInteger('buzina').
    end.
    if oPayload:has('cintos':U) then do:
        ttChecklist.cintos = oPayload:getInteger('cintos').
    end.
    if oPayload:has('documentos':U) then do:
        ttChecklist.documentos = oPayload:getInteger('documentos').
    end.
    if oPayload:has('extintor':U) then do:
        ttChecklist.extintor = oPayload:getInteger('extintor').
    end.
    if oPayload:has('limpadores':U) then do:
        ttChecklist.limpadores = oPayload:getInteger('limpadores').
    end.
    if oPayload:has('macaco':U) then do:
        ttChecklist.macaco = oPayload:getInteger('macaco').
    end.
    if oPayload:has('chave_roda':U) then do:
        ttChecklist.chave_roda = oPayload:getInteger('chave_roda').
    end.
    if oPayload:has('retrov_ext':U) then do:
        ttChecklist.retrov_ext = oPayload:getInteger('retrov_ext').
    end.
    if oPayload:has('retrov_int':U) then do:
        ttChecklist.retrov_int = oPayload:getInteger('retrov_int').         
    end.

    run setRecord      in boHandler (input table ttChecklist).
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
        msg:add("message", "Checklist Atualizado!").
        msg:add("detailedMessage", "Checklist atualizado com sucesso!").
        assign oRes = JsonApiResponseBuilder:ok(msg, 200). 
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally. 

end procedure.


/*****************************************************************************
                            ELIMINAR CHECKLIST
******************************************************************************/
procedure pi-delete:
    define input  param oReq     as JsonObject           no-undo.
    define output param oRes     as JsonObject           no-undo.
    define variable aJsonArray   as JsonArray            no-undo.
    define variable iAgendamento as integer              no-undo.
    define variable iTipo        as integer              no-undo.
    define variable msg          as JsonObject           no-undo.
    define variable msgArray     as JsonArray            no-undo.
    define variable oRequest     as JsonAPIRequestParser no-undo.
    define variable cPathParams  as character            no-undo.
   
    assign
        oRequest     = new JsonAPIRequestParser(oReq)
        cPathParams  = oRequest:getPathParams():GetCharacter(1)
        iAgendamento = integer(entry(1, cPathParams, "|"))
        iTipo        = integer(entry(2, cPathParams, "|")).

    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0200.p persistent set boHandler.
    end.

    run openQueryStatic in boHandler (input "Main":U).
    run emptyRowErrors  in boHandler.
    run goToKey         in boHandler (input iAgendamento , input iTipo).

    if return-value = "OK" then do:
        run deleteRecord in boHandler.
        run getRowErrors in boHandler (output table RowErrors append).   
    end.

    else do:
        assign
            msgArray = new JsonArray()
            msg      = new JsonObject().
        
        msg:add("ErrorHelp", "Checklist nÆo encontrado na base de dados!").
        msg:add("ErrorNumber", 1).
        msg:add("ErrorDescription", "Checklist nÆo encontrado!").
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


/*****************************************************************************
                               LISTAR AVALIADORES 
******************************************************************************/
procedure pi-evaluator-list:
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
    define variable iLength       as integer              no-undo.
    define variable oJsonObject   as JsonObject           no-undo.
    define variable cSearch       as character            no-undo.
    define variable iMatricula    as integer              no-undo.
   
    assign
        orequest     = new JsonAPIRequestParser(oReq)
        oQueryParams = new JsonObject()
        oQueryParams = oReq:getJsonObject("queryParams")
        iStartRow    = oRequest:getStartRow()
        iPageSize    = oRequest:getPageSize()
        iPage        = oRequest:getPage().

    if not valid-handle(boHandler) then do:
        run {&prefix}services/bopy085.p persistent set boHandler.
    end.

    if oQueryParams:has("filter") then do:
        assign
            cSearch      = string(oQueryParams:GetJsonArray("filter"):getJsonText(1))
            iMatricula = integer(cSearch) no-error.
        if cSearch <> "" then do:
            if error-status:error then do:
                run setConstraintNome in boHandler (input cSearch).
                run openQueryStatic in boHandler (input "Nome":U).
                run emptyRowErrors  in boHandler.
                run getFirst        in boHandler.
            end.
            else do:
                run setConstraintMatricula in boHandler (input iMatricula).
                run openQueryStatic in boHandler (input "Matricula":U).
                run emptyRowErrors  in boHandler.
                run getFirst        in boHandler.
            end.
        end.
        else do:
            run openQueryStatic in boHandler (input "Main":U).
            run emptyRowErrors  in boHandler.
            run getFirst        in boHandler.
        end.
    end.
    else do:
        run openQueryStatic in boHandler (input "Main":U).
        run emptyRowErrors  in boHandler.
        run getFirst        in boHandler.
    end.

    if iStartRow > 1 then do:
        assign iContFin = iStartRow - 1.
        do iContIni = 1 to iContFin:
            run getNext in boHandler.
            if return-value = "NOK":U then do:
                run emptyRowErrors in boHandler.
                assign hasNext  = false.
                if iStartRow > iContIni then
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
            output table ttAvaliador //parƒmetro de entrada, que cont‚m o handle da temp-table onde serÆo retornados os registros
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
        assign
            aJsonArray = JsonAPIUtils:ConvertTempTableToJsonArray(temp-table ttAvaliador:handle)
            oRes = JsonApiResponseBuilder:ok(aJsonArray, hasNext).
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally. 

end procedure.


/*****************************************************************************
                          PESQUISAR AVALIADOR 
******************************************************************************/
procedure pi-evaluator-find:
    define input  param oReq       as JsonObject           no-undo.
    define output param oRes       as JsonObject           no-undo. 
    define variable oJsonObject    as JsonObject           no-undo.
    define variable cPathParams    as character            no-undo.
    define variable oMsg           as JsonObject           no-undo.
    define variable aMsgArray      as JsonArray            no-undo.
    define variable iId            as integer              no-undo.
    define variable oRequest       as JsonAPIRequestParser no-undo.
    define variable oJsonObjectRes as JsonObject           no-undo.
    
    assign 
        oJsonObject    = new JsonObject()
        oJsonObjectRes = new JsonObject()
        oRequest       = new JsonAPIRequestParser(oReq)
        cPathParams    = oRequest:getPathParams():GetCharacter(2)
        iId            = integer(cPathParams).
    
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bopy085.p persistent set boHandler.
    end.
    
    run openQueryStatic in boHandler (input "Main":U).
    run emptyRowErrors  in boHandler.
    run getRowErrors    in boHandler (output table RowErrors append).
    run goToKey         in boHandler (input iId).

    if upper(return-value) = "OK":U then do:
        run getRecord in boHandler (output table ttAvaliador).
        assign 
            oJsonObject = JsonAPIUtils:ConvertTempTableToJsonObject(temp-table ttAvaliador:handle)
            oJsonObjectRes = oJsonObject:getJsonArray("ttAvaliador"):getJsonObject(1).

        oRes = JsonApiResponseBuilder:ok(oJsonObjectRes, 200).
        if valid-handle(boHandler) then
        run destroy in boHandler.
        return.
    end.
    else do:
        assign
            aMsgArray = new JsonArray()
            oMsg      = new JsonObject().
        
        oMsg:add("ErrorHelp", "Avaliador " + string(cPathParams) + " nÆo encontrado na base de dados!").
        oMsg:add("ErrorNumber", 1).
        oMsg:add("ErrorDescription", "Avaliador nÆo encontrado!").
        oMsg:add("ErrorSubType", "error").
        aMsgArray:Add(oMsg).
        assign oRes = JsonApiResponseBuilder:asError(aMsgArray, 404).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.
    end.

    if valid-handle(boHandler) then
        run destroy in boHandler.

    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
    end.
    else do :
        assign 
            oJsonObject    = JsonAPIUtils:ConvertTempTableToJsonObject(temp-table ttAvaliador:handle)
            oJsonObjectRes = oJsonObject:getJsonArray("ttAvaliador"):getJsonObject(1)
            oRes           = JsonApiResponseBuilder:ok(oJsonObjectRes, 200).
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally.

end procedure.


/*****************************************************************************
                              DIµRIO DE BORDO 
******************************************************************************/
procedure pi-logbook-list:
    define input  param oReq      as JsonObject           no-undo.
    define output param oRes      as JsonObject           no-undo.
    define variable aJsonArray    as JsonArray            no-undo.
    define variable msg           as JsonObject           no-undo.
    define variable msgArray      as JsonArray            no-undo.
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
    define variable cHora         as character            no-undo.
    define variable aJsonArrayRes as JsonArray            no-undo.
    define variable i             as integer              no-undo.
    define variable oJsonObject   as JsonObject           no-undo.
    define variable oQueryParams  as JsonObject           no-undo.
    define variable cPlaca        as character            no-undo.
    define variable cModelo       as character            no-undo.
    define variable cCondutor     as character            no-undo.
    define variable cSearch       as character            no-undo.
    define variable hr_checklist  as character            no-undo.
    define variable dData         as date                 no-undo.
    define variable cData         as character            no-undo.

    assign
        orequest     = new JsonAPIRequestParser(oReq)
        oQueryParams = new JsonObject()
        oQueryParams = oReq:getJsonObject("queryParams")
        iStartRow    = oRequest:getStartRow()
        iPageSize    = oRequest:getPageSize()
        iPage        = oRequest:getPage().
    
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0200.p persistent set boHandler.
    end.

    if oQueryParams:has("modelo") and oQueryParams:has("nome_condutor") and oQueryParams:has("placa") then do:
        assign 
            cModelo   = string(oQueryParams:GetJsonArray("modelo"):getJsonText(1))
            cCondutor = string(oQueryParams:GetJsonArray("nome_condutor"):getJsonText(1)).
            cPlaca    = string(oQueryParams:GetJsonArray("placa"):getJsonText(1)).

        run setConstraintModeloCondutor in boHandler (input cModelo, input cCondutor).
        run openQueryStatic             in boHandler (input "ModeloCondutorDiario":U).
        run emptyRowErrors              in boHandler.
        run getFirst                    in boHandler.
    end.
     else if oQueryParams:has("placa") then do:
        assign cPlaca = string(oQueryParams:GetJsonArray("placa"):getJsonText(1)).
        run setConstraintPlaca in boHandler (input cPlaca).
        run openQueryStatic in boHandler (input "PlacaDiario":U).
        run emptyRowErrors  in boHandler.
        run getFirst        in boHandler.
    end.
    else if oQueryParams:has("modelo") then do:
        assign cModelo = string(oQueryParams:GetJsonArray("modelo"):getJsonText(1)).
        run setConstraintModelo in boHandler (input cModelo).
        run openQueryStatic     in boHandler (input "ModeloDiario":U).
        run emptyRowErrors      in boHandler.
        run getFirst            in boHandler.
    end.
    else if oQueryParams:has("dt_checklist") then do:
        assign cData = string(oQueryParams:GetJsonArray("dt_checklist"):getJsonText(1)).
        assign dData = date(substring(cData,9,2) + "/" + substring(cData,6,2) + "/" + substring(cData,1,4)).
        run setConstraintData in boHandler (input dData).
        run openQueryStatic   in boHandler (input "dataDiario":U).
        run emptyRowErrors    in boHandler.
        run getFirst          in boHandler.
    end.
    else if oQueryParams:has("nome_condutor") then do:
        assign cCondutor = string(oQueryParams:GetJsonArray("nome_condutor"):getJsonText(1)).
        run setConstraintCondutor in boHandler (input cCondutor).
        run openQueryStatic       in boHandler (input "CondutorDiario":U).
        run emptyRowErrors        in boHandler.
        run getFirst              in boHandler.
    end.
    else if oQueryParams:has("search") then do:
        assign cSearch = string(oQueryParams:GetJsonArray("search"):getJsonText(1)).
        run setConstraintSearch in boHandler (input cSearch, input cSearch, input cSearch).
        run openQueryStatic in boHandler (input "SearchDiario":U).
        run emptyRowErrors  in boHandler.
        run getFirst        in boHandler.
    end.
    else do:
        run openQueryStatic in boHandler (input "Diario":U).
        run emptyRowErrors  in boHandler.
        run getFirst        in boHandler.
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
        run getRowid        in boHandler (output rId).
        run getBatchRecords in boHandler( 
            input rId,//parƒmetro de entrada, que indica o rowid a ser reposicionado para o in¡cio da leitura
            input no, //parƒmetro de entrada, que indica se a leitura deve ser feita a partir do pr¢ximo registro
            input iPageSize, //parƒmetro de entrada, que indica o n£mero de registros a serem retornados;
            output iReturnedRows, //parƒmetro de sa¡da, que indica o n£mero de registros retornados
            output table ttChecklist //parƒmetro de entrada, que cont‚m o handle da temp-table onde serÆo retornados os registros
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
    else do :
        assign
            aJsonArray = JsonAPIUtils:ConvertTempTableToJsonArray(temp-table ttChecklist:handle).
            aJsonArrayRes = new jsonArray().
        do i = 1 to iReturnedRows:
            assign
                oJsonObject = new jsonObject()
                oJsonObject = aJsonArray:getJsonObject(i).
                    
            for first cst_veiculos_agendamento
            fields (placa destino motivo condutor)
            no-lock
            where cst_veiculos_agendamento.agendamento_id = oJsonObject:getinteger('agendamento_id'):
                oJsonObject:add('placa', cst_veiculos_agendamento.placa).
                oJsonObject:add('destino', cst_veiculos_agendamento.destino).
                oJsonObject:add('motivo', cst_veiculos_agendamento.motivo).
            end.
            
            for first cst_veiculos
            fields (modelo)
            no-lock
            where cst_veiculos.placa = cst_veiculos_agendamento.placa:
                oJsonObject:add('modelo', cst_veiculos.modelo).
            end.

            for first funcionario
            fields (nom_pessoa_fisic)
            no-lock
            where funcionario.cdn_funcionario = cst_veiculos_agendamento.condutor:
                oJsonObject:add('nome_condutor', funcionario.nom_pessoa_fisic).
            end.

            for first cst_veiculos_checklist
            fields (hr_checklist dt_checklist km observacoes)
            no-lock 
            where cst_veiculos_checklist.agendamento_id = oJsonObject:getinteger('agendamento_id')
            and cst_veiculos_checklist.tipo = 2:

                assign
                   hr_checklist = substring(cst_veiculos_checklist.hr_checklist,1,2) + ":" + substring(cst_veiculos_checklist.hr_checklist,3,2).

                oJsonObject:add('dt_final', cst_veiculos_checklist.dt_checklist).
                oJsonObject:add('hr_final', hr_checklist).
                oJsonObject:add('km_final', cst_veiculos_checklist.km).
                oJsonObject:add('observacoesRetorno', cst_veiculos_checklist.observacoes).
            end.
            
            aJsonArrayRes:add(oJsonObject).
        end.
        assign aJsonArray = aJsonArrayRes.
        assign oRes = JsonApiResponseBuilder:ok(aJsonArray, hasNext).
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally. 

end procedure.

