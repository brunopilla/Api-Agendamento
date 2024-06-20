&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCST0194
&GLOBAL-DEFINE DBOVersion 2.00
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName cst_veiculos
&GLOBAL-DEFINE TableLabel Veiculos
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cstp/api/v1/services/bocst0194.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE cPlaca  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cModelo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lTodos  AS logical     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 17.88
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if can-find (first cst_veiculos_agendamento no-lock
        where cst_veiculos_agendamento.placa = RowObject.placa) then

        {method/svc/errors/inserr.i
            &ErrorNumber="112"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorDescription="Ve°culo n∆o pode ser exclu°do!"
            &ErrorHelp="Ve°culo possui hist¢rico com agendamentos. Neste caso apenas desative o ve°culo sem exclu°-lo."}

    if can-find (first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.
    
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod_categ_habilit":U THEN ASSIGN pFieldValue = RowObject.cod_categ_habilit.
        WHEN "cor":U THEN ASSIGN pFieldValue = RowObject.cor.
        WHEN "marca":U THEN ASSIGN pFieldValue = RowObject.marca.
        WHEN "modelo":U THEN ASSIGN pFieldValue = RowObject.modelo.
        WHEN "observacoes":U THEN ASSIGN pFieldValue = RowObject.observacoes.
        WHEN "placa":U THEN ASSIGN pFieldValue = RowObject.placa.
        WHEN "proprietario":U THEN ASSIGN pFieldValue = RowObject.proprietario.
        WHEN "renavam":U THEN ASSIGN pFieldValue = RowObject.renavam.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "agua_limp":U THEN ASSIGN pFieldValue = RowObject.agua_limp.
        WHEN "agua_rad":U THEN ASSIGN pFieldValue = RowObject.agua_rad.
        WHEN "alarme":U THEN ASSIGN pFieldValue = RowObject.alarme.
        WHEN "ano":U THEN ASSIGN pFieldValue = RowObject.ano.
        WHEN "buzina":U THEN ASSIGN pFieldValue = RowObject.buzina.
        WHEN "cambio":U THEN ASSIGN pFieldValue = RowObject.cambio.
        WHEN "chave_roda":U THEN ASSIGN pFieldValue = RowObject.chave_roda.
        WHEN "cintos":U THEN ASSIGN pFieldValue = RowObject.cintos.
        WHEN "combustivel":U THEN ASSIGN pFieldValue = RowObject.combustivel.
        WHEN "documentos":U THEN ASSIGN pFieldValue = RowObject.documentos.
        WHEN "embreagem":U THEN ASSIGN pFieldValue = RowObject.embreagem.
        WHEN "estepe":U THEN ASSIGN pFieldValue = RowObject.estepe.
        WHEN "extintor":U THEN ASSIGN pFieldValue = RowObject.extintor.
        WHEN "farol_alto":U THEN ASSIGN pFieldValue = RowObject.farol_alto.
        WHEN "farol_baixo":U THEN ASSIGN pFieldValue = RowObject.farol_baixo.
        WHEN "freio":U THEN ASSIGN pFieldValue = RowObject.freio.
        WHEN "km":U THEN ASSIGN pFieldValue = RowObject.km.
        WHEN "lataria":U THEN ASSIGN pFieldValue = RowObject.lataria.
        WHEN "limpadores":U THEN ASSIGN pFieldValue = RowObject.limpadores.
        WHEN "limp_ext":U THEN ASSIGN pFieldValue = RowObject.limp_ext.
        WHEN "limp_int":U THEN ASSIGN pFieldValue = RowObject.limp_int.
        WHEN "luz_re":U THEN ASSIGN pFieldValue = RowObject.luz_re.
        WHEN "macaco":U THEN ASSIGN pFieldValue = RowObject.macaco.
        WHEN "oleo_freio":U THEN ASSIGN pFieldValue = RowObject.oleo_freio.
        WHEN "oleo_motor":U THEN ASSIGN pFieldValue = RowObject.oleo_motor.
        WHEN "parabrisa":U THEN ASSIGN pFieldValue = RowObject.parabrisa.
        WHEN "parachoque_diant":U THEN ASSIGN pFieldValue = RowObject.parachoque_diant.
        WHEN "parachoque_tras":U THEN ASSIGN pFieldValue = RowObject.parachoque_tras.
        WHEN "pintura":U THEN ASSIGN pFieldValue = RowObject.pintura.
        WHEN "pneus":U THEN ASSIGN pFieldValue = RowObject.pneus.
        WHEN "retrov_ext":U THEN ASSIGN pFieldValue = RowObject.retrov_ext.
        WHEN "retrov_int":U THEN ASSIGN pFieldValue = RowObject.retrov_int.
        WHEN "setas":U THEN ASSIGN pFieldValue = RowObject.setas.
        WHEN "triangulo":U THEN ASSIGN pFieldValue = RowObject.triangulo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice pk
  Parameters:  
               retorna valor do campo placa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pplaca LIKE cst_veiculos.placa NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pplaca = RowObject.placa.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ativo":U THEN ASSIGN pFieldValue = RowObject.ativo.
        WHEN "disponivel":U THEN ASSIGN pFieldValue = RowObject.disponivel.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice pk
  Parameters:  
               recebe valor do campo placa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pplaca LIKE cst_veiculos.placa NO-UNDO.

    FIND FIRST bfcst_veiculos WHERE 
        bfcst_veiculos.placa = pplaca NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcst_veiculos THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcst_veiculos)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAtivos DBOProgram 
PROCEDURE openQueryAtivos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.ativo = true.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if lTodos then
        open query {&QueryName} for each {&TableName} no-lock.
    else
        open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.ativo = true.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryModelo DBOProgram 
PROCEDURE openQueryModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if lTodos then
        open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.modelo matches ("*" + cModelo + "*")
        by {&TableName}.modelo.
    else
        open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.modelo matches ("*" + cModelo + "*")
        and {&TableName}.ativo = true
        by {&TableName}.modelo.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPlaca DBOProgram 
PROCEDURE openQueryPlaca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if lTodos then
        open query {&QueryName} for each {&TableName} no-lock 
        where {&TableName}.placa matches("*" + cPlaca + "*")
        by    {&TableName}.placa.
    else
        open query {&QueryName} for each {&TableName} no-lock 
        where {&TableName}.placa matches("*" + cPlaca + "*")
        and   {&TableName}.ativo = true
        by    {&TableName}.placa.
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPlacaModelo DBOProgram 
PROCEDURE openQueryPlacaModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if lTodos then
        open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.placa  matches("*" + cPlaca + "*")
        and   {&TableName}.modelo matches("*" + cModelo + "*")
        by    {&TableName}.placa.
    else
        open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.placa  matches("*" + cPlaca + "*")
        and   {&TableName}.modelo matches("*" + cModelo + "*")
        and   {&TableName}.ativo = true
        by    {&TableName}.placa.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySearch DBOProgram 
PROCEDURE openQuerySearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if lTodos then
        open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.placa  matches("*" + cPlaca + "*")
        or    {&TableName}.modelo matches("*" + cModelo + "*")
        by    {&TableName}.placa.
    else
        open query {&QueryName} for each {&TableName} no-lock
        where ({&TableName}.placa  matches("*" + cPlaca + "*")
        or    {&TableName}.modelo matches("*" + cModelo + "*"))
        and   {&TableName}.ativo = true
        by    {&TableName}.placa.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pTodos  as logical   no-undo.
    
    assign lTodos = pTodos.
    
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintModelo DBOProgram 
PROCEDURE setConstraintModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pModelo as character no-undo.
    define input parameter pTodos  as logical   no-undo.

    assign 
        cModelo = pModelo
        lTodos  = pTodos.

    return "OK".

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPlaca DBOProgram 
PROCEDURE setConstraintPlaca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pPlaca as character no-undo.
    define input parameter pTodos as logical   no-undo.

    assign 
        cPlaca = pPlaca
        lTodos = pTodos.
    
    return "OK".

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPlacaModelo DBOProgram 
PROCEDURE setConstraintPlacaModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pPlaca  as character no-undo.
    define input parameter pModelo as character no-undo.
    define input parameter pTodos  as logical   no-undo.

    assign
        cPlaca  = pPlaca
        cModelo = pModelo
        lTodos  = pTodos.
    
    return "OK".

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    define input parameter pType as character no-undo.
        /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
              executadas ---*/
        /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
        /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
              include: method/svc/errors/inserr.i ---*/
        /*:T--- Inclua aqui as validaá‰es ---*/
    if pType = "Create":U then do:

        if can-find(cst_veiculos 
           where cst_veiculos.placa = RowObject.placa) then 
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="PLACA j† foi cadastrada!"
                &ErrorHelp="Verifique se este ve°culo ja foi cadastrado no sistema."}
                 
        if RowObject.placa = "" then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo Placa!"
                &ErrorHelp="Informe a placa do ve°culo."}         
    end.
    
    if pType = "Create":U or pType = "Update":U then do:

        if RowObject.modelo = "" then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo MODELO!"
                &ErrorHelp="Informe o modelo do ve°culo."}
                    
        if RowObject.marca = "" then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo MARCA!"
                &ErrorHelp="Informe a marca do ve°culo."}
                    
        if RowObject.ano = 0 then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo ANO!"
                &ErrorHelp="Informe o ano do ve°culo."}
                    
        if RowObject.renavam = "" then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo RENAVAM!"
                &ErrorHelp="Informe o renavam do ve°culo."}
                    
        if RowObject.cod_categ_habilit = "" then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo CATEG. HABILITAÄ«O!"
                &ErrorHelp="Informe a categoria da habilitaá∆o do ve°culo. Exemplos: A, B, C ..."} 
                               
        if RowObject.proprietario = "" then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo PROPRIETµRIO!"
                &ErrorHelp="Informe a Raz∆o Social do propriet†rio do ve°culo."}
                   
        if RowObject.ativo = no then
            assign RowObject.disponivel = no.
    
        if RowObject.ativo = yes then
            assign RowObject.disponivel = yes. 
    
    end.
        /*:T--- Verifica ocorrància de erros ---*/
        if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
            return "NOK":U.
        
        return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

