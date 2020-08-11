grammar hm;

fragment HUMAN_RAW_LETTER: [a-zA-Z_0-9 ];
fragment HUMAN_RAW_LETTER_ESC: HUMAN_RAW_LETTER | ESCAPE;
fragment ESCAPE: '?' [?ntr"'];
fragment MAG_SYM_CHAR: [a-zA-Z_];
fragment DIGIT: [0-9];
fragment Ja: 'ja' | 'Ja';
fragment Nein: 'nein' | 'Nein';
fragment Bool: 'logic';
fragment I32: 'i32';
fragment Str: 'lang';
fragment Letter: 'letter';

// keywords
MAGIC_KW: 'magic' | 'mag';
AREA: 'area';
HUMAN_BOOL: Ja | Nein;

TYPE: Bool | I32 | Str | Letter;

// literal values
HUMAN_NUM: '-'? DIGIT+;
HUMAN_LETTER: '\'' HUMAN_RAW_LETTER_ESC '\'';
HUMAN_LANG: '"' HUMAN_RAW_LETTER_ESC* '"';

// symbol
SYMBOL: MAG_SYM_CHAR (DIGIT | MAG_SYM_CHAR)* '?'?;

// parsers
path: head=SYMBOL ('->' tail=SYMBOL)*;
area_use: AREA area=path '.';

literal: HUMAN_BOOL | HUMAN_NUM | HUMAN_LETTER | HUMAN_LANG;
expr: literal | SYMBOL;

type_decl: ':' type=TYPE;

box_expr: 'box' SYMBOL (type=type_decl)? '<-' init=expr;

stmte: (box_expr | expr);
stmt: stmte '.';


args: SYMBOL type_decl (',' SYMBOL type_decl)* ','?;

magic: MAGIC_KW sym=SYMBOL '[' args? ']' ('{' body=stmt* '}' | '{' body=stmt* ret=expr '}' ':' ret_type=TYPE);

item: stmt | area_use | magic;

test: item* EOF;

// ignores
WS: [ \n\t\r] -> skip;