%{
    #include <stdio.h>
    #include <stdlib.h>

    extern void yyerror(const char *msg);
    extern int yylex(void);
%}

%token  
        IF  
        THEN  
        ELSE  
        FOR
        DO  
        INT
        REAL  
        BOOL  
        FUNC 
        EQUAL 
        SMALLER
        BIGGER
        DIF
        SMALLEQ
        BIGGEQ
        OR  
        ATRIB 
        DOUBDOT 
        PLUS  
        MINUS  
        SEMICON 
        COL 
        OPENPARENT 
        CLOSEPARENT 
        OPENBRACES 
        CLOSEBRACES 
        MULTIPLY  
        DIV  
        AND  
        TRUE  
        FALSE  
        START  
        READ  
        WRITE
        PROG 
        END  
        NUM
        VAR 
        ID     

%right NOT
%left  MULT DIV
%left  PLUS MINUS
%left  SMALLER BIGGER SMALLEQ BIGGEQ
%left  EQUAL DIF
%left  TRUE FALSE
%right ASSIGN

%%

programa: PROG identificador SEMICON bloco          { printf("P -> prog ID; BLOCO \n\n\033[0;32m  Nenhum erro encontrado.\033[0;37m");};
   ;
bloco: VAR declaracao START comandos END            { printf("B -> var DECLA inicio CMD fim\n");}
   ;
declaracao: nome_var DOUBDOT tipo SEMICON           { printf("DECLA -> VARNAME : TIPO;\n");}
    | nome_var DOUBDOT tipo SEMICON declaracao      { printf("DECLA -> VARNAME : TIPO; DECLA\n");}
   ;
nome_var: identificador                             { printf("VARNAME -> IDEN\n");}
    | identificador COL nome_var                    { printf("VARNAME -> IDEN , VARNAME\n");}
   ;
tipo: INT                                           { printf("TIPO -> .inteiro\n");}
    | REAL                                          { printf("TIPO -> .real\n");}
    | BOOL                                          { printf("TIPO -> .booleano\n");}
   ;
comandos: comando                                   { printf("CMDS -> CMD\n");}
    | comando SEMICON comandos                      { printf("CMDS -> CMD; CMDS\n");}
   ;
    /*Correção de ambiguidade*/
comando: cmd_Associado                              { printf("CMD -> CMD_ASSOCIADO\n");}
    | cmd_NaoAssociado                              { printf("CMD -> CMD_NAO_ASSOCIADO\n");}                 
   ;
cmd_Associado: IF expressao THEN cmd_Associado ELSE cmd_Associado { printf("CMD_ASSOCIADO -> se EXPRESSAO entao CMD_ASSOCIADO senao CMD_ASSOCIADO\n");}  
    | atribuicao                                    { printf("CMD -> ATRIB\n");}
    | enquanto                                      { printf("CMD -> ENQUANTO\n");}
    | leitura                                       { printf("CMD -> LEITURA\n");}
    | escrita                                       { printf("CMD -> ESCRITA\n");}
   ;
cmd_NaoAssociado: IF expressao THEN comando         { printf("CMD_NAO_ASSOCIADO -> se EXPRESSAO entao CMD\n");}
    | IF expressao THEN cmd_Associado ELSE cmd_NaoAssociado { printf("CMD_NAO_ASSOCIADO -> se EXPRESSAO entao CMD_ASSOCIADO senao CMD_NAO_ASSOCIADO\n");}
   ;
/*Fim da correção de ambiguidade*/
atribuicao: identificador ASSIGN expressao          { printf("ATRIB -> IDEN := EXPR\n");}
   ;
enquanto: FOR expressao DO cmd_Associado            { printf("ENQUANTO -> enquanto EXPRESSAO faca CMD_ASSOCIADO\n");}
   ;
leitura: READ OPENPARENT identificador CLOSEPARENT  { printf("LEITURA -> leia (IDEN)\n");}
   ;
escrita: WRITE OPENPARENT identificador CLOSEPARENT { printf("LEITURA -> escreva (IDEN)\n");}
   ;
expressao: simples                                  { printf("EXPRESSAO -> SIMP\n");}
    | simples opRelacional simples                  { printf("EXPRESSAO -> SIMP RELACIONAL SIMP\n");}
   ;
opRelacional: DIF                                   { printf("RELACIONAL -> <>\n");}
    | EQUAL                                         { printf("RELACIONAL -> =\n");}
    | SMALLER                                       { printf("RELACIONAL -> <\n");}
    | BIGGER                                        { printf("RELACIONAL -> >\n");}
    | SMALLEQ                                       { printf("RELACIONAL -> <=\n");}
    | BIGGEQ                                        { printf("RELACIONAL -> >=\n");}
   ;
simples: termo operador termo                       { printf("SIMP -> TERMO OPERADOR TERMO\n");}
    | termo                                         { printf("SIMP -> TERMO\n");}
   ;
operador: PLUS                                      { printf("OPERADOR -> +\n");}
    | MINUS                                         { printf("OPERADOR -> -\n");}
    | OR                                            { printf("OPERADOR -> ou\n");}
   ;
termo: fator                                        { printf("TERMO -> FATOR\n");}
    | fator op fator                                { printf("TERMO -> FATOR OPERADOR FATOR\n");}
   ;
op: MULT                                            { printf("OP -> *\n");}
    | DIV                                           { printf("OP -> div\n");}
    | AND                                           { printf("OP -> e\n");}
   ;
fator: identificador                                { printf("FATOR -> IDEN\n");}
    | numero                                        { printf("FATOR -> NUM\n");}
    | OPENPARENT expressao CLOSEPARENT              { printf("FATOR -> (EXPRESSAO)\n");}
    | TRUE                                          { printf("FATOR -> verdadeiro\n");}
    | FALSE                                         { printf("FATOR -> falso\n");}
    | NOT fator                                     { printf("FATOR -> not FATOR\n");}
   ;
identificador: ID                                   { printf("IDENTIFICADOR -> id\n");}
   ;
numero: NUM                                         { printf("NUM -> num\n");}
   ;
%%