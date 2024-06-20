procedure pi-metadata:

    define input  param oReq     as JsonObject no-undo.
    define output param oRes     as JsonObject no-undo.
    define variable oMetadata    as JsonObject no-undo.
    define variable aJsonArray   as JsonArray  no-undo.
    define variable aJsonArray2  as JsonArray  no-undo.
    define variable oJsonObject  as JsonObject no-undo.
    define variable oJsonObject2 as JsonObject no-undo.
    define variable oQueryParams as JsonObject no-undo.
    define variable aType        as JsonArray  no-undo.

    assign
        oQueryParams = new JsonObject()
        oQueryParams = oReq:getJsonObject("queryParams").
        aType        = oQueryParams:getJsonArray("type").

/*****************************************************************************
                                  LISTAR
******************************************************************************/

    if aType:GetJsonText(1) = "list" then do:
        oMetadata = new jsonObject().
        oMetadata:add('version', 1).
        oMetadata:add('type', 'list').
        oMetadata:add('autoRouter', true).
        oMetadata:add('title', 'Agendamentos').
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                oJsonObject:add('label', 'In°cio').
                oJsonObject:add('link', '/home').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('label', 'Agendamentos').
            aJsonArray:add(oJsonObject).
            oJsonObject = new jsonObject().
            oJsonObject:add('items', aJsonArray ).
        oMetadata:add('breadcrumb', ojsonObject).
            oJsonObject = new jsonObject().
            oJsonObject:add('detail', 'agendamento/detail/:id').
            oJsonObject:add('duplicate', 'agendamento/new').
            oJsonObject:add('edit', 'agendamento/edit/:id').
            oJsonObject:add('new', 'agendamento/new').
            oJsonObject:add('remove', true).
        oMetadata:add('actions', ojsonObject).
        oMetadata:add('keepFilters', true).
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'todos').
                oJsonObject:add('label', 'Incluir Finalizados').
                oJsonObject:add('visible', false).
                ojsonObject:add('type', 'boolean').
                oJsonObject:add('filter', true).
                ojsonObject:add('booleanTrue', 'Sim').
                ojsonObject:add('booleanFalse', 'N∆o').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'agendamento_id').
                oJsonObject:add('key', true).
                oJsonObject:add('label', 'Agendamento').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property', 'situacao').
                ojsonObject:add('label', 'Status').
                ojsonObject:add('width', '150px').
                ojsonObject:add('type', 'subtitle').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 0).
                        oJsonObject2:add('label', '0 - Agendamento Reprovado').
                        oJsonObject2:add('color', 'color-07').
                        oJsonObject2:add('content', 'AR' ).
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', '1 - Pendente de Aprovaá∆o').
                        oJsonObject2:add('color', 'color-08').
                        oJsonObject2:add('content', 'PA').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', '2 - Agendamento Aprovado').
                        oJsonObject2:add('color', 'color-10').
                        oJsonObject2:add('content', 'AA').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', '3 - Rota Iniciada').
                        oJsonObject2:add('color', 'color-03').
                        oJsonObject2:add('content', 'RI').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 4).
                        oJsonObject2:add('label', '4 - Rota Finalizada').
                        oJsonObject2:add('color', 'color-05').
                        oJsonObject2:add('content', 'RF').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('subtitles', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'placa').
                oJsonObject:add('label', 'Placa').
                ojsonObject:add('duplicate', true).
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'modelo').
                oJsonObject:add('label', 'Ve°culo').
                ojsonObject:add('duplicate', true).
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'condutor').
                oJsonObject:add('label', 'Condutor').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'nome_condutor').
                oJsonObject:add('label', 'Nome').
                ojsonObject:add('duplicate', true).
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'prev_data_inic').
                oJsonObject:add('label', 'Data Prevista Sa°da').
                oJsonObject:add('type', 'date').
                oJsonObject:add('format', 'dd/MM/yyy').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'prev_hora_inic').
                oJsonObject:add('label', 'Hora Prevista Sa°da').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'prev_data_fin').
                oJsonObject:add('label', 'Data Prevista Retorno').
                oJsonObject:add('type', 'date').
                oJsonObject:add('format', 'dd/MM/yyy').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'prev_hora_fin').
                oJsonObject:add('label', 'Hora Prevista Retorno').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'destino').
                oJsonObject:add('label', 'Destino / Itiner†rio').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'motivo').
                oJsonObject:add('label', 'Motivo').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
        oMetadata:add('fields', ajsonArray).
    end.
    
/*****************************************************************************
                                  DETALHAR
******************************************************************************/

    if aType:GetJsonText(1) = "detail" then do:
        oMetadata = new jsonObject().
        oMetadata:add('version', 1).
        oMetadata:add('type', 'detail').
        oMetadata:add('title', 'Detalhes do Agendamento').
            oJsonObject = new jsonObject().
            ojsonObject:add('back','/agendamento').
            ojsonObject:add('edit','/agendamento/edit/:id').
            ojsonObject:add('remove','/agendamento').
        oMetadata:add('actions', oJsonObject).
            oJsonObject = new jsonObject().
                aJsonArray = new jsonArray().
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','In°cio').
                    ojsonObject2:add('link','/home').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Agendamento').
                    ojsonObject2:add('link','/agendamento').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Detalhes').
                aJsonArray:add(oJsonObject2).
            oJsonObject:add('items', aJsonArray).
        oMetadata:add('breadcrumb', oJsonObject).
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'agendamento_id').
                oJsonObject:add('key', true).
                oJsonObject:add('label', 'Agendamento').
                oJsonObject:add('filter', true).
                oJsonObject:add('divider', 'Dados Gerais Agendamento').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'placa').
                oJsonObject:add('label', 'Placa Ve°culo').
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'modelo').
                oJsonObject:add('label', 'Ve°culo').
                oJsonObject:add('gridColumns', 5).
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).    
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'condutor').
                oJsonObject:add('label', 'Matr°cula Condutor').
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'nome_condutor').
                oJsonObject:add('label', 'Condutor').
                oJsonObject:add('gridColumns', 5).
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'prev_data_inic').
                oJsonObject:add('label', 'Data').
                oJsonObject:add('type', 'date').
                oJsonObject:add('tag', true).
                oJsonObject:add('format', 'dd/MM/yyy').
                ojsonObject:add('icon','po-icon po-icon-calendar').
                oJsonObject:add('divider', 'Previs∆o de Sa°da').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'prev_hora_inic').
                oJsonObject:add('label', 'Hor†rio').
                oJsonObject:add('tag', true).
                ojsonObject:add('icon','po-icon po-icon-clock').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'prev_data_fin').
                oJsonObject:add('label', 'Data').
                oJsonObject:add('type', 'date').
                oJsonObject:add('tag', true).
                oJsonObject:add('format', 'dd/MM/yyy').
                ojsonObject:add('icon','po-icon po-icon-calendar').
                oJsonObject:add('divider', 'Previs∆o de Retorno').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'prev_hora_fin').
                oJsonObject:add('label', 'Hor†rio').
                oJsonObject:add('tag', true).
                ojsonObject:add('icon','po-icon po-icon-clock').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'destino').
                oJsonObject:add('label', 'Destino / Itiner†rio').
                oJsonObject:add('divider', 'Informaá‰es adicionais').
                oJsonObject:add('gridColumns', 11).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'motivo').
                oJsonObject:add('label', 'Motivo').
                oJsonObject:add('gridColumns', 11).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'situacao').
                oJsonObject:add('label', 'Status').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 0).
                        oJsonObject2:add('label', 'Agendamento Reprovado').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Pendente de Aprovaá∆o').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'Agendamento Aprovado').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Rota Iniciada').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 4).
                        oJsonObject2:add('label', 'Rota Finalizada').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'user_agendamento').
                oJsonObject:add('label', 'Usu†rio:').
                oJsonObject:add('divider', 'Agendamento').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'dt_agendamento').
                oJsonObject:add('label', 'Data').
                oJsonObject:add('type', 'date').
                oJsonObject:add('tag', true).
                oJsonObject:add('format', 'dd/MM/yyy').
                ojsonObject:add('icon','po-icon po-icon-calendar').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'hr_agendamento').
                oJsonObject:add('label', 'Hor†rio').
                oJsonObject:add('tag', true).
                ojsonObject:add('icon','po-icon po-icon-clock').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'aprovador').
                oJsonObject:add('label', 'Respons†vel:').
                oJsonObject:add('divider', 'Aprovaá∆o').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'dt_aprov').
                oJsonObject:add('label', 'Data').
                oJsonObject:add('type', 'date').
                oJsonObject:add('tag', true).
                oJsonObject:add('format', 'dd/MM/yyy').
                ojsonObject:add('icon','po-icon po-icon-calendar').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'hr_aprov').
                oJsonObject:add('label', 'Hor†rio').
                oJsonObject:add('tag', true).
                ojsonObject:add('icon','po-icon po-icon-clock').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'consideracoes_aprov').
                oJsonObject:add('label', 'Consideraá‰es Aprovador:').
                oJsonObject:add('gridColumns', 5).
            aJsonArray:add(oJsonObject).
        oMetadata:add('fields', ajsonArray).
    end.

/*****************************************************************************
                                  CADASTRAR
******************************************************************************/

    if aType:GetJsonText(1) = "create" then do:
        oMetadata = new jsonObject().
        oMetadata:add('version', 1).
        oMetadata:add('type', 'create').
        oMetadata:add('title', 'Novo Agendamento').
            oJsonObject = new jsonObject().
            ojsonObject:add('save','/agendamento').
            ojsonObject:add('saveNew', 'metadata-new/').
            ojsonObject:add('cancel','/agendamento').
        oMetadata:add('actions', oJsonObject).
            oJsonObject = new jsonObject().
                aJsonArray = new jsonArray().
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','In°cio').
                    ojsonObject2:add('link','/home').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Agendamentos').
                    ojsonObject2:add('link','/agendamento').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Novo').
                aJsonArray:add(oJsonObject2).
            oJsonObject:add('items', aJsonArray).
        oMetadata:add('breadcrumb', oJsonObject).
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agendamento_id').
                ojsonObject:add('label','Agendamentos').
                ojsonObject:add('key', true).
                ojsonObject:add('visible', false).
                ojsonObject:add('divider','Dados Gerais do Agendamento').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','placa').
                ojsonObject:add('label','Ve°culo').
                ojsonObject:add('gridColumns', 7).
                ojsonObject:add('required', true).
                ojsonObject:add('searchService', '{&environment}veiculos').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'placa').
                        oJsonObject2:add('label', 'Placa').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'modelo').
                        oJsonObject2:add('label', 'Modelo').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'marca').
                        oJsonObject2:add('label', 'Marca').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'ano').
                        oJsonObject2:add('label', 'Ano').
                    aJsonArray2:add(oJsonObject2).
                ojsonObject:add('columns', aJsonArray2).
                    aJsonArray2 = new jsonArray().
                    aJsonArray2:add('placa').
                    aJsonArray2:add('modelo').
                ojsonObject:add('format', aJsonArray2).
                ojsonObject:add('fieldLabel', 'modelo').
                ojsonObject:add('fieldValue', 'placa').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','condutor').
                ojsonObject:add('label','Condutor').
                ojsonObject:add('gridColumns', 7).
                ojsonObject:add('required', true).
                ojsonObject:add('type', 'select').
                ojsonObject:add('searchService', '{&environment}agendamento/condutor').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'cdn_funcionario').
                        oJsonObject2:add('label', 'Matr°cula').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'nom_pessoa_fisic').
                        oJsonObject2:add('label', 'Nome').
                    aJsonArray2:add(oJsonObject2).
                ojsonObject:add('columns', aJsonArray2).
                    aJsonArray2 = new jsonArray().
                    aJsonArray2:add('cdn_funcionario').
                    aJsonArray2:add('nom_pessoa_fisic').
                ojsonObject:add('format', aJsonArray2).
                ojsonObject:add('fieldLabel', 'nom_pessoa_fisic').
                ojsonObject:add('fieldValue', 'cdn_funcionario').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','prev_data_inic').
                ojsonObject:add('label','Data').
                ojsonObject:add('required', true).
                ojsonObject:add('type', 'date').
                ojsonObject:add('divider','Previs∆o de Sa°da').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','prev_hora_inic').
                ojsonObject:add('label','Hor†rio').
                ojsonObject:add('icon','po-icon po-icon-clock').
                ojsonObject:add('type','time').
                ojsonObject:add('format','HH:mm').
                ojsonObject:add('required', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','prev_data_fin').
                ojsonObject:add('label','Data').
                ojsonObject:add('required', true).
                ojsonObject:add('type', 'date').
                ojsonObject:add('divider','Previs∆o de Retorno').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','prev_hora_fin').
                ojsonObject:add('label','Hor†rio').
                ojsonObject:add('icon','po-icon po-icon-clock').
                ojsonObject:add('type','time').
                ojsonObject:add('format','HH:mm').
                ojsonObject:add('required', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','destino').
                ojsonObject:add('label','Destino / Itiner†rio').
                ojsonObject:add('required', true).
                ojsonObject:add('gridColumns', 7).
                ojsonObject:add('maxLength', 100).
                ojsonObject:add('divider','Informaá‰es Adicionais').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','motivo').
                ojsonObject:add('label','Motivo').
                ojsonObject:add('required', true).
                ojsonObject:add('gridColumns', 7).
                ojsonObject:add('maxLength', 100).
            aJsonArray:add(oJsonObject).
        oMetadata:add('fields', aJsonArray).
    end.

/*****************************************************************************
                                  EDITAR
******************************************************************************/

    if aType:GetJsonText(1) = "edit" then do:
        oMetadata = new jsonObject().
        oMetadata:add('version', 1).
        oMetadata:add('type', 'edit').
        oMetadata:add('title', 'Editando Agendamento').
            oJsonObject = new jsonObject().
            ojsonObject:add('save','/agendamento').
            ojsonObject:add('cancel','/agendamento').
        oMetadata:add('actions', oJsonObject).
            oJsonObject = new jsonObject().
                aJsonArray = new jsonArray().
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','In°cio').
                    ojsonObject2:add('link','/home').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Agendamentos').
                    ojsonObject2:add('link','/agendamento').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Editando').
                aJsonArray:add(oJsonObject2).
            oJsonObject:add('items', aJsonArray).
        oMetadata:add('breadcrumb', oJsonObject).
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agendamento_id').
                ojsonObject:add('label','Agendamento').
                ojsonObject:add('key', true).
                ojsonObject:add('disabled', true).
                ojsonObject:add('divider','Dados Gerais do Agendamento').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','placa').
                ojsonObject:add('label','Ve°culo').
                ojsonObject:add('gridColumns', 7).
                ojsonObject:add('required', true).
                 ojsonObject:add('transform', true).
                ojsonObject:add('searchService', '{&environment}veiculos').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'placa').
                        oJsonObject2:add('label', 'Placa').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'modelo').
                        oJsonObject2:add('label', 'Modelo').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'marca').
                        oJsonObject2:add('label', 'Marca').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'ano').
                        oJsonObject2:add('label', 'Ano').
                    aJsonArray2:add(oJsonObject2).
                ojsonObject:add('columns', aJsonArray2).
                    aJsonArray2 = new jsonArray().
                    aJsonArray2:add('placa').
                    aJsonArray2:add('modelo').
                ojsonObject:add('format', aJsonArray2).
                ojsonObject:add('fieldLabel', 'modelo').
                ojsonObject:add('fieldValue', 'placa').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','condutor').
                ojsonObject:add('label','Condutor').
                ojsonObject:add('gridColumns', 7).
                ojsonObject:add('required', true).
                ojsonObject:add('type', 'select').
                ojsonObject:add('searchService', '{&environment}agendamento/condutor').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'cdn_funcionario').
                        oJsonObject2:add('label', 'Matr°cula').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'nom_pessoa_fisic').
                        oJsonObject2:add('label', 'Nome').
                    aJsonArray2:add(oJsonObject2).
                ojsonObject:add('columns', aJsonArray2).
                    aJsonArray2 = new jsonArray().
                    aJsonArray2:add('cdn_funcionario').
                    aJsonArray2:add('nom_pessoa_fisic').
                ojsonObject:add('format', aJsonArray2).
                ojsonObject:add('fieldLabel', 'nom_pessoa_fisic').
                ojsonObject:add('fieldValue', 'cdn_funcionario').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','prev_data_inic').
                ojsonObject:add('label','Data').
                ojsonObject:add('required', true).
                ojsonObject:add('type', 'date').
                ojsonObject:add('divider','Previs∆o de Sa°da').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','prev_hora_inic').
                ojsonObject:add('label','Hor†rio').
                ojsonObject:add('icon','po-icon po-icon-clock').
                ojsonObject:add('format','HH:mm').
                ojsonObject:add('required', true).
                ojsonObject:add('type', 'time').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','prev_data_fin').
                ojsonObject:add('label','Data').
                ojsonObject:add('required', true).
                ojsonObject:add('type', 'date').
                ojsonObject:add('divider','Previs∆o de Retorno').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','prev_hora_fin').
                ojsonObject:add('label','Hor†rio').
                ojsonObject:add('icon','po-icon po-icon-clock').
                ojsonObject:add('format','HH:mm').
                ojsonObject:add('type', 'time').
                ojsonObject:add('required', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','destino').
                ojsonObject:add('label','Destino / Itiner†rio').
                ojsonObject:add('required', true).
                ojsonObject:add('gridColumns', 7).
                ojsonObject:add('maxLength', 100).
                ojsonObject:add('divider','Informaá‰es Adicionais').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','motivo').
                ojsonObject:add('label','Motivo').
                ojsonObject:add('required', true).
                ojsonObject:add('gridColumns', 7).
                ojsonObject:add('maxLength', 100).
            aJsonArray:add(oJsonObject).
        oMetadata:add('fields', aJsonArray).
    end.
    
    assign oRes = JsonApiResponseBuilder:ok(oMetadata, 200).

end procedure.
