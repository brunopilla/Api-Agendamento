
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
        oMetadata:add('title', 'Ve¡culos').
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                oJsonObject:add('label', 'In¡cio').
                oJsonObject:add('link', '/home').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('label', 'Ve¡culos').
            aJsonArray:add(oJsonObject).
            oJsonObject = new jsonObject().
            oJsonObject:add('items', aJsonArray ).
        oMetadata:add('breadcrumb', ojsonObject).
            oJsonObject = new jsonObject().
            oJsonObject:add('detail', 'veiculos/detail/:id').
            oJsonObject:add('duplicate', 'veiculos/new').
            oJsonObject:add('edit', 'veiculos/edit/:id').
            oJsonObject:add('new', 'veiculos/new').
            oJsonObject:add('remove', true).
        oMetadata:add('actions', ojsonObject).
        oMetadata:add('keepFilters', true).
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'todos').
                oJsonObject:add('label', 'Incluir Inativos').
                oJsonObject:add('type', 'boolean').
                oJsonObject:add('filter', true).
                oJsonObject:add('visible', false).
                ojsonObject:add('booleanTrue', 'Sim').
                ojsonObject:add('booleanFalse', 'NÆo').
            aJsonArray:add(oJsonObject).    
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'placa').
                oJsonObject:add('key', true).
                oJsonObject:add('label', 'Placa').
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'modelo').
                oJsonObject:add('label', 'Modelo').
                oJsonObject:add('filter', true).
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'marca').
                oJsonObject:add('label', 'Marca').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'ano').
                oJsonObject:add('label', 'Ano').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'cor').
                oJsonObject:add('label', 'Cor').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'renavam').
                oJsonObject:add('label', 'Renavam').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'cod_categ_habilit').
                oJsonObject:add('label', 'Categ.Habilita‡Æo').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'ativo').
                oJsonObject:add('label', 'Situa‡Æo').
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', true).
                        oJsonObject2:add('label', 'Ativo').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', false).
                        oJsonObject2:add('label', 'Inativo').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'disponivel').
                oJsonObject:add('label', 'Status').
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', false).
                        oJsonObject2:add('label', 'Indispon¡vel').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', true).
                        oJsonObject2:add('label', 'Dispon¡vel').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'km').
                oJsonObject:add('label', 'Km').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','combustivel').
                ojsonObject:add('label','Combust¡vel').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Reserva').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', '1/4').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', '1/2').
                        oJsonObject2:add('color', 'color-09').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 4).
                        oJsonObject2:add('label', '3/4').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 5).
                        oJsonObject2:add('label', 'Completo').
                        oJsonObject2:add('color', 'color-11').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'proprietario').
                oJsonObject:add('label', 'Propriet rio').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'observacoes').
                oJsonObject:add('label', 'Anota‡äes').
                ojsonObject:add('duplicate', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'limp_ext').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'limp_int').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'pneus').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'estepe').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'lataria').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'pintura').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'parachoque_diant').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'parachoque_tras').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'setas').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'farol_alto').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'farol_baixo').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'luz_re').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'agua_limp').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'agua_rad').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'embreagem').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'cambio').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'freio').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'oleo_freio').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'oleo_motor').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'parabrisa').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'alarme').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'buzina').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'cintos').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'documentos').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'extintor').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'limpadores').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'macaco').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'triangulo').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'chave_roda').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'retrov_ext').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'retrov_int').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('visible', false).
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
        oMetadata:add('title', 'Detalhes do Ve¡culo').
            oJsonObject = new jsonObject().
            ojsonObject:add('back','/veiculos').
            ojsonObject:add('edit','/veiculos/edit/:id').
            ojsonObject:add('remove','/veiculos').
        oMetadata:add('actions', oJsonObject).
            oJsonObject = new jsonObject().
                aJsonArray = new jsonArray().
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','In¡cio').
                    ojsonObject2:add('link','/home').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Ve¡culos').
                    ojsonObject2:add('link','/veiculos').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Detalhes').
                aJsonArray:add(oJsonObject2).
            oJsonObject:add('items', aJsonArray).
        oMetadata:add('breadcrumb', oJsonObject).
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                ojsonObject:add('property','placa').
                ojsonObject:add('label','Placa').
                ojsonObject:add('key', true).
                ojsonObject:add('divider','Dados Gerais do Ve¡culo').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','modelo').
                ojsonObject:add('label','Modelo').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','marca').
                ojsonObject:add('label','Marca').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','ano').
                ojsonObject:add('label','Ano').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cor').
                ojsonObject:add('label','Cor').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','renavam').
                ojsonObject:add('label','Renavam').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cod_categ_habilit').
                ojsonObject:add('label','Categ.CNH').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','ativo').
                ojsonObject:add('label','Situa‡Æo').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', true).
                        oJsonObject2:add('label', 'Ativo').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', false).
                        oJsonObject2:add('label', 'Inativo').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','disponivel').
                ojsonObject:add('label','Status').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', true).
                        oJsonObject2:add('label', 'Dispon¡vel').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', false).
                        oJsonObject2:add('label', 'Indispon¡vel').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','km').
                ojsonObject:add('label','Km').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','combustivel').
                ojsonObject:add('label','Combust¡vel').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Reserva').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', '1/4').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', '1/2').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 4).
                        oJsonObject2:add('label', '3/4').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 5).
                        oJsonObject2:add('label', 'Completo').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','proprietario').
                ojsonObject:add('label','Propriet rio').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','observacoes').
                ojsonObject:add('label','Anota‡äes').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_ext').
                ojsonObject:add('label','Limpeza Externa').
                ojsonObject:add('divider','Situa‡Æo Atual do Ve¡culo (Checklist)').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_int').
                ojsonObject:add('label','Limpeza Interna').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pneus').
                ojsonObject:add('label','Pneus').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','estepe').
                ojsonObject:add('label','Estepe').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pintura').
                ojsonObject:add('label','Pintura').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','lataria').
                ojsonObject:add('label','Lataria').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_diant').
                ojsonObject:add('label','Parachoque Diant.').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_tras').
                ojsonObject:add('label','Parachoque Tras.').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_alto').
                ojsonObject:add('label','Farol Alto').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_baixo').
                ojsonObject:add('label','Farol Baixo').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','setas').
                ojsonObject:add('label','Setas').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','luz_re').
                ojsonObject:add('label','Luz de R‚').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_limp').
                ojsonObject:add('label','Agua limpadores').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_rad').
                ojsonObject:add('label','Agua Radiador').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','embreagem').
                ojsonObject:add('label','Embreagem').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cambio').
                ojsonObject:add('label','Cƒmbio').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_freio').
                ojsonObject:add('label','Flu¡do Freio').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_motor').
                ojsonObject:add('label','àleo Motor').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parabrisa').
                ojsonObject:add('label','Parabrisa').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','alarme').
                ojsonObject:add('label','Alarme').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','buzina').
                ojsonObject:add('label','Buzina').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cintos').
                ojsonObject:add('label','Cintos').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','documentos').
                ojsonObject:add('label','Documentos').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','extintor').
                ojsonObject:add('label','Extintor').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limpadores').
                ojsonObject:add('label','Limpadores').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','macaco').
                ojsonObject:add('label','Macaco').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','chave_roda').
                ojsonObject:add('label','Chave Roda').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_ext').
                ojsonObject:add('label','Retrovisores Ext.').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_int').
                ojsonObject:add('label','Retrovisor Int.').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).    
        oMetadata:add('fields', aJsonArray).
    end.

/*****************************************************************************
                                  CADASTRAR
******************************************************************************/

    if aType:GetJsonText(1) = "create" then do:
        oMetadata = new jsonObject().
        oMetadata:add('version', 1).
        oMetadata:add('type', 'create').
        oMetadata:add('title', 'Novo Ve¡culo').
            oJsonObject = new jsonObject().
            ojsonObject:add('save','/veiculos').
            ojsonObject:add('saveNew', 'metadata-new/').
            ojsonObject:add('cancel','/veiculos').
        oMetadata:add('actions', oJsonObject).
            oJsonObject = new jsonObject().
                aJsonArray = new jsonArray().
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','In¡cio').
                    ojsonObject2:add('link','/home').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Ve¡culos').
                    ojsonObject2:add('link','/veiculos').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Novo').
                aJsonArray:add(oJsonObject2).
            oJsonObject:add('items', aJsonArray).
        oMetadata:add('breadcrumb', oJsonObject).
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                ojsonObject:add('property','placa').
                ojsonObject:add('label','Placa').
                ojsonObject:add('key', true).
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 12).
                ojsonObject:add('divider','Dados Gerais do Ve¡culo').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','modelo').
                ojsonObject:add('label','Modelo').
                ojsonObject:add('gridColumns', 9).
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 40).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','marca').
                ojsonObject:add('label','Marca').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 20).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','ano').
                ojsonObject:add('label','Ano').
                ojsonObject:add('type', 'number').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 4).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cor').
                ojsonObject:add('label','Cor').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 20).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','renavam').
                ojsonObject:add('label','Renavam').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 16).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cod_categ_habilit').
                ojsonObject:add('label','Categ.CNH').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 4).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','km').
                ojsonObject:add('label','Km').
                ojsonObject:add('type', 'number').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 7).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','combustivel').
                ojsonObject:add('label','Combust¡vel').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Reserva').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', '1/4').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', '1/2').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 4).
                        oJsonObject2:add('label', '3/4').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 5).
                        oJsonObject2:add('label', 'Completo').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','proprietario').
                ojsonObject:add('label','Propriet rio').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 40).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','observacoes').
                ojsonObject:add('label','Anota‡äes').
                ojsonObject:add('rows', 4).
                ojsonObject:add('gridColumns', 12).
                ojsonObject:add('type', 'textarea').
                ojsonObject:add('optional', true).
                ojsonObject:add('maxLength', 300).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_ext').
                ojsonObject:add('label','Limpeza Externa').
                ojsonObject:add('required', true).
                ojsonObject:add('divider','Situa‡Æo Atual do Ve¡culo (Checklist)').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_int').
                ojsonObject:add('label','Limpeza Interna').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pneus').
                ojsonObject:add('label','Pneus').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','estepe').
                ojsonObject:add('label','Estepe').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pintura').
                ojsonObject:add('label','Pintura').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','lataria').
                ojsonObject:add('label','Lataria').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_diant').
                ojsonObject:add('label','Parachoque Dianteiro').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_tras').
                ojsonObject:add('label','Parachoque Traseiro').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_alto').
                ojsonObject:add('label','Farol Alto').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_baixo').
                ojsonObject:add('label','Farol Baixo').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','setas').
                ojsonObject:add('label','Setas').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','luz_re').
                ojsonObject:add('label','Luz de R‚').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_limp').
                ojsonObject:add('label','Agua Limpador Parabrisa').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_rad').
                ojsonObject:add('label','Agua Radiador').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','embreagem').
                ojsonObject:add('label','Embreagem').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cambio').
                ojsonObject:add('label','Cƒmbio').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_freio').
                ojsonObject:add('label','Flu¡do Freio').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_motor').
                ojsonObject:add('label','àleo Motor').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parabrisa').
                ojsonObject:add('label','Parabrisa').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','alarme').
                ojsonObject:add('label','Alarme').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','buzina').
                ojsonObject:add('label','Buzina').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cintos').
                ojsonObject:add('label','Cintos').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','documentos').
                ojsonObject:add('label','Documentos').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','extintor').
                ojsonObject:add('label','Extintor').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limpadores').
                ojsonObject:add('label','Limpadores').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','macaco').
                ojsonObject:add('label','Macaco').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','chave_roda').
                ojsonObject:add('label','Chave Roda').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_ext').
                ojsonObject:add('label','Retrovisores Externos').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_int').
                ojsonObject:add('label','Retrovisor Interno').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
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
        oMetadata:add('title', 'Editando Ve¡culo').
            oJsonObject = new jsonObject().
            ojsonObject:add('save','/veiculos').
            ojsonObject:add('cancel','/veiculos').
        oMetadata:add('actions', oJsonObject).
            oJsonObject = new jsonObject().
                aJsonArray = new jsonArray().
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','In¡cio').
                    ojsonObject2:add('link','/home').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Ve¡culos').
                    ojsonObject2:add('link','/veiculos').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Editando').
                aJsonArray:add(oJsonObject2).
            oJsonObject:add('items', aJsonArray).
        oMetadata:add('breadcrumb', oJsonObject).
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                ojsonObject:add('property','placa').
                ojsonObject:add('label','Placa').
                ojsonObject:add('key', true).
                ojsonObject:add('disabled', true).
                ojsonObject:add('maxLength', 12).
                ojsonObject:add('divider','Dados Gerais do Ve¡culo').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','modelo').
                ojsonObject:add('label','Modelo').
                ojsonObject:add('gridColumns', 9).
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 40).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','marca').
                ojsonObject:add('label','Marca').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 20).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','ano').
                ojsonObject:add('label','Ano').
                ojsonObject:add('type', 'number').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 4).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cor').
                ojsonObject:add('label','Cor').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 20).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','renavam').
                ojsonObject:add('label','Renavam').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 16).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cod_categ_habilit').
                ojsonObject:add('label','Categ.CNH').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 4).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','ativo').
                ojsonObject:add('label','Situa‡Æo').
                ojsonObject:add('type', 'boolean').
                ojsonObject:add('booleanTrue', 'Ativo').
                ojsonObject:add('booleanFalse', 'Inativo').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','km').
                ojsonObject:add('label','Km').
                ojsonObject:add('type', 'number').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 7).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','combustivel').
                ojsonObject:add('label','Combust¡vel').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Reserva').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', '1/4').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', '1/2').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 4).
                        oJsonObject2:add('label', '3/4').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 5).
                        oJsonObject2:add('label', 'Completo').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','proprietario').
                ojsonObject:add('label','Propriet rio').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 40).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','observacoes').
                ojsonObject:add('label','Anota‡äes').
                ojsonObject:add('rows', 4).
                ojsonObject:add('gridColumns', 12).
                ojsonObject:add('type', 'textarea').
                ojsonObject:add('optional', true).
                ojsonObject:add('maxLength', 300).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_ext').
                ojsonObject:add('label','Limpeza Externa').
                ojsonObject:add('divider','Situa‡Æo Atual do Ve¡culo (Checklist)').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_int').
                ojsonObject:add('label','Limpeza Interna').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pneus').
                ojsonObject:add('label','Pneus').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','estepe').
                ojsonObject:add('label','Estepe').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pintura').
                ojsonObject:add('label','Pintura').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','lataria').
                ojsonObject:add('label','Lataria').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_diant').
                ojsonObject:add('label','Parachoque Dianteiro').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_tras').
                ojsonObject:add('label','Parachoque Traseiro').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_alto').
                ojsonObject:add('label','Farol Alto').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_baixo').
                ojsonObject:add('label','Farol Baixo').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','setas').
                ojsonObject:add('label','Setas').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','luz_re').
                ojsonObject:add('label','Luz de R‚').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_limp').
                ojsonObject:add('label','Agua Limpador Parabrisa').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_rad').
                ojsonObject:add('label','Agua Radiador').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','embreagem').
                ojsonObject:add('label','Embreagem').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cambio').
                ojsonObject:add('label','Cƒmbio').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_freio').
                ojsonObject:add('label','Flu¡do Freio').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_motor').
                ojsonObject:add('label','àleo Motor').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parabrisa').
                ojsonObject:add('label','Parabrisa').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','alarme').
                ojsonObject:add('label','Alarme').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','buzina').
                ojsonObject:add('label','Buzina').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cintos').
                ojsonObject:add('label','Cintos').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','documentos').
                ojsonObject:add('label','Documentos').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','extintor').
                ojsonObject:add('label','Extintor').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limpadores').
                ojsonObject:add('label','Limpadores').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','macaco').
                ojsonObject:add('label','Macaco').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','chave_roda').
                ojsonObject:add('label','Chave Roda').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_ext').
                ojsonObject:add('label','Retrovisores Externos').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_int').
                ojsonObject:add('label','Retrovisor Interno').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).    
        oMetadata:add('fields', aJsonArray).
    end.
    
    assign oRes = JsonApiResponseBuilder:ok(oMetadata, 200).

end procedure.
