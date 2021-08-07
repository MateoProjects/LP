grammar Expr;

root : assigncolor EOF
       |expresiopoligon EOF
       |operaciopoligonsimple EOF
       |operadorspoligons EOF
       |newpoly EOF
       |printtxt EOF
       |EOF
       ;
expresiopoligon:  (poligonID|listvertexs|operadorspoligons|operadorspoligons2)
                  |PRIORITYOP (poligonID|listvertexs|operadorspoligons|operadorspoligons2|expresiopoligon) PRIORITYEND;
vertexdef: (INT|FLOAT) (INT|FLOAT);
listvertexs : LISTSTART vertexdef* LISTEND;
newpoly: poligonID ASSIGN expresiopoligon;

assigncolor : COLOR expresiopoligon COMA colorvalues;


operaciopoligonsimple:  PERIMETER expresiopoligon
                        |EQUAL expresiopoligon COMA expresiopoligon
                        |INSIDE expresiopoligon COMA expresiopoligon
                        |AREA expresiopoligon
                        |PRINT expresiopoligon
                        |CENTROID expresiopoligon
                        |VERTICES expresiopoligon
                        |DRAW TXT COMA expresiopoligon (COMA expresiopoligon)*
                        ;
printtxt: PRINT TXT;
operadorspoligons:  poligonID UNION expresiopoligon
                    |poligonID INTERSECTION expresiopoligon

;

operadorspoligons2 : BOUNDINGBOX expresiopoligon
                    |POLI expresiopoligon
                    |ASSIGN expresiopoligon

;
/* OPERADORS*/

UNION: '+';
INTERSECTION: '*';
BOUNDINGBOX: '#';
POLI: '!';
ASSIGN : ':=';

/* DEFINICIONS DE VALORS */


colorvalues : COLORSTART (INT|FLOAT) (INT|FLOAT) (INT|FLOAT)  COLOREND;
poligonID: ID;

/* OPERACIONS */

INSIDE: 'inside';
PRINT: 'print';
COLOR: 'color';
PERIMETER: 'perimeter';
VERTICES: 'vertices';
CENTROID: 'centroid';
AREA: 'area';
EQUAL: 'equal';
DRAW: 'draw';


/* SIMBOLS */

COLORSTART: '{';
COLOREND: '}';
PRIORITYOP: '(';
PRIORITYEND: ')';
LISTSTART: '[';
LISTEND: ']';
COMA: ',';

/* DEFINICIONS*/

TXT: '"'.*'"';
INT: [0-9]+;
FLOAT: [0-9]+'.'[0-9]+;
ENDLINE: '\n';
ID : [a-zA-Z_]+[0-9]*[a-zA-Z_]*;
WHITE : [ \t\r]+ -> skip;
COMENTARI: '//'.* -> skip;

