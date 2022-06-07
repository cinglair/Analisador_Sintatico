/* just like Unix wc */
%option noyywrap
%{
 #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "parser.tab.h"
    
    int line = 1; //Contador de linhas
    int error = 0; //Contador de erros
    extern int yyval;

    void comentario (int tam, char *coment) {
        int i;
        for (i=0; i<tam ;i++) {
            if (coment[i] == 10) 
                line++;
        }
    }
    void mensagem_erro() { 
        printf("\n\033[0;31mERRO LEXICO ---> Linha %d\033[0;37m\n", line);
        error++;
    }
%}

id [a-zA-Z][0-9a-zA-Z_]*
num [0-9]+ 
inteiros [+|-]?{num}
numErro {num}[^\n\t" "]+
idErro {id}[^\n\t" "]+
flutuante {inteiros}[.]{num}


%%
\n                     { line++; }
\t                     {  }
[[:space:]]            {  }
[{][^}]*[}]            { comentario(yyleng, yytext);} // Qualquer conteúdo entre { e } que seja diferente de '}' será ignorado!



se                      { return IF;            }
entao                   { return THEN;          }
senao                   { return ELSE;          }
enquanto                { return FOR;           }
faca                    { return DO;            }

inteiro                 { return INT;           }
real                    { return REAL;          }
booleano                { return BOOL;          }
funcao                  { return FUNC;          }

[=]                     { return EQUAL;         }
[<]                     { return SMALLER;       }
[>]                     { return BIGGER;        }
"<>"                    { return DIF;           }
"<="                    { return SMALLEQ;       }
">="                    { return BIGGEQ;        }

ou                      { return OR;            }
":="                    { return ATRIB;         }
":"                     { return DOUBDOT;       } 
[+]                     { return PLUS;          }
[-]                     { return MINUS;         }
[;]                     { return SEMICON;       }
[,]                     { return COL;           }

[(]                     { return OPENPARENT;    }
[)]                     { return CLOSEPARENT;   }

[[]                     { return OPENBRACES;    }
[]]                     { return CLOSEBRACES;   }

[*]                     { return MULTIPLY;      }
div                     { return DIV;           }
e                       { return AND;           }
verdadeiro              { return TRUE;          }
falso                   { return FALSE;         }
inicio                  { return START;         }
leia                    { return READ;          }
escreva                 { return WRITE;         }
programa                { return PROG;          }
fim                     { return END;           }
{inteiros}              { return NUM;           }
{flutuante}             { return NUM;           }
var                     { return VAR;           }
{id}                    { return ID;            }
{idErro}                { mensagem_erro();      }
{numErro}               { mensagem_erro();      }

.                      { mensagem_erro();}

%%
