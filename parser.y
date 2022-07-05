%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "storage.h"

    extern void yyerror(const char *msg);
    extern int yylex(void);
    Storage *storage;
    int memory[30];
%}

%union{
        int value;
        char* lex_value;
}

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
%left  MULTIPLY DIV
%left  PLUS MINUS
%left  SMALLER BIGGER SMALLEQ BIGGEQ
%left  EQUAL DIF
%left  TRUE FALSE
%right ATRIB
%type <value> numero fator termo simples expressao nome_var
%start programa

%%

programa: PROG identificador SEMICON bloco          { printf("\n\n\033[0;32m Concluído → Nenhum erro encontrado.\033[0;37m"); clearStorage(storage);};
   ;
bloco: VAR declaracao START comandos END            { ;}
   ;
declaracao: nome_var DOUBDOT tipo SEMICON           { ;}
    | nome_var DOUBDOT tipo SEMICON declaracao      { ;}
   ;
nome_var: identificador                             { ;}
    | identificador COL nome_var                    { ;}
   ;
tipo: INT                                           { ;}
    | REAL                                          { ;}
    | BOOL                                          { ;}
   ;
comandos: comando                                   { ;}
    | comando SEMICON comandos                      { ;}
   ;
    /*Correção de ambiguidade*/
comando: cmd_Associado                              { ;}
    | cmd_NaoAssociado                              { ;}                 
   ;
cmd_Associado: IF expressao THEN cmd_Associado ELSE cmd_Associado { ;}  
    | atribuicao                                    { ;}
    | enquanto                                      { ;}
    | leitura                                       { ;}
    | escrita                                       { ;}
   ;
cmd_NaoAssociado: IF expressao THEN comando         { ;}
    | IF expressao THEN cmd_Associado ELSE cmd_NaoAssociado { ;}
   ;
/*Fim da correção de ambiguidade*/
atribuicao: identificador ATRIB expressao           { ;  if(isEmpty(storage)){
        storage = createStorage();
                                                      } insertBox(storage, $<lex_value>1, $<value>3);
                                                      }
   ;
enquanto: FOR expressao DO cmd_Associado            {;}
   ;
leitura: READ OPENPARENT identificador CLOSEPARENT  { ;}
   ;
escrita: WRITE OPENPARENT identificador CLOSEPARENT { ;printf("%d\n", getValue(storage, $<lex_value>3));}
   ;
expressao: simples                                  { ;}
    | simples opRelacional simples                  { ;$<value>$ = $<value>1;}
   ;
opRelacional: DIF                                   { ;}
    | EQUAL                                         { ;}
    | SMALLER                                       { ;}
    | BIGGER                                        { ;}
    | SMALLEQ                                       { ;}
    | BIGGEQ                                        { ;}
   ;
simples: termo operador termo                       { ;  if(strcmp($<lex_value>2, "+") == 0){
                                                               $<value>$ = $<value>1 + $<value>3;
                                                      }else if(strcmp($<lex_value>2, "-") == 0){
                                                               $<value>$ = $<value>1 - $<value>3;
                                                      }
                                                      }
    | termo                                         { ;$<value>$ = $<value>1;}
   ;
operador: PLUS                                      { ;}
    | MINUS                                         { ;}
    | OR                                            { ;}
   ;
termo: fator                                        { ;$<value>$ = $<value>1;}
    | fator op fator                                { ; if(strcmp($<lex_value>2, "*") == 0){
                                                                           $<value>$ = $<value>1 * $<value>3;}
                                                                 else if(strcmp($<lex_value>2 , "div") == 0){
                                                                           $<value>$ = $<value>1 / $<value>3;
                                                                  }
                                                         }
   ;
op: MULTIPLY                                        { ;}
    | DIV                                           { ;}
    | AND                                           { ;}
   ;
fator: identificador                                { ;$<value>$ = getValue(storage, $<lex_value>1);}
    | numero                                        { ;$<value>$ = $<value>1;}
    | OPENPARENT expressao CLOSEPARENT              { ; $<value>$ = $<value>2;}
    | TRUE                                          { ;}
    | FALSE                                         { ;}
    | NOT fator                                     { ;}
   ;
identificador: ID                                   { ;}
   ;
numero: NUM                                         { ;$<value>$ = $<value>1;}
   ;
%%

