/********************************************************************************                                                     **
**  @about Proyecto 1: Analizador léxico para p, subconjunto de Python.        **
*********************************************************************************/
package lexico;
import java.util.Stack;
import java.io.*;

%%
%public
%class Alexico
%unicode
%standalone

%{
    
    /* Para guardar la secuencia de tokens. */
    private StringBuilder builder = new StringBuilder();
    /* Pila que guarda el numero de identaciones por bloque*/
    private Stack<Integer> pila_global = new Stack<>();
    /* Contador del número de línea actual.*/
    private int no_linea = 1;
    /* Verifica si existe un error de identacion. */
    private boolean error_identa = false;

    /**
    * Añade una nueva representanción de un token al {@link StringBuilder}.
    * @param type La cadena con el tipo de token.
    */
    private void nextSymbol(final String type) {
        builder.append(type);
    }

    /**
    * Añade una nueva representación de un token al {@link StringBuilder}.
    * @param type La cadena con el tipo de token.
    * @param value La cadena con el valor del token.
    */
    private void nextSymbol(final String type, final String value) {
        final String tokenWithValue = String.format("%s(%s)", type, value);
        builder.append(tokenWithValue);
    }

    /**
     * Crea un nuevo bloque de identaci&oacute; (representado como un nuevo)
     * elemento en la pila, con el entero de valor 0 (porque llevamos 0 
     * identaciones en el momento que se crea).
     */
    private void newIdenta(){
        pila_global.push(0);
    }

    /**
     * Incrementa el contador de espacios del bloque actual
     */
    private void pushIdenta(){
        int count = pila_global.pop();
        pila_global.push(++count);
    }

    /**
     * Verifica si la siguiente linea pertenece al mismo bloque de identaci&oacute;n
     * esto con el fin de reconocer si es un atomo IDENTA o no, esto se vera reflejado
     * en la pila con un nuevo elmento en el caso de que si fuera una nueva identaci&oacute;n
     */
    private void isIdenta(){
        int bloque_actual = pila_global.pop();
        if(pila_global.empty()){
                pila_global.push(bloque_actual);
        }else{
            int bloque_anterior = pila_global.peek();
            if(bloque_actual > bloque_anterior){ 
                pila_global.push(bloque_actual);
                nextSymbol("IDENTA",Integer.toString(bloque_actual));
            }else if(bloque_actual < bloque_anterior){
                do{
                    nextSymbol("DEIDENTA",Integer.toString(bloque_anterior));
                    pila_global.pop();
                    if(!pila_global.empty())
                        bloque_anterior = pila_global.peek();
                    //aqui tambien asumimos que el primer bloque inicia en 0
                    else bloque_anterior = 0; 
                }
                while(bloque_actual < bloque_anterior);
                if(bloque_actual != bloque_anterior) error_identa = true;
            }
        }
    }

    /**
     * Reporta el error ocurrido.
     * @param type El tipo de error, 0: cadena, 1: Identación 2: Lexema
     */
    private void reportError(int type){
        switch(type){
            case 0:
                nextSymbol("\nERROR de cadena en la linea: ");
                break;
            case 1:
                nextSymbol("\nERROR de Identación en la linea: ");
                break;
            case 2:
                nextSymbol("\nERROR Lexema no encontado en la linea: ");
                break;
        }

        nextSymbol("" + no_linea);
    }
    /**
     * @return si ocurrio un error de identacion
     */
    private boolean errorIdenta(){
        return error_identa;
    }
%}

%eof{
    /* Imprimimos al final la secuencia de tokens. */
    System.out.println(builder.toString());
    /* Guardamos en directorio 'out/' */
    try{
        Writer output = null;
        File file = new File("fizzbuzz.plx");
        output = new BufferedWriter(new FileWriter("../../../out" + file,true));
        output.write(builder.toString());
        output.write("HHUHUOJJO");
        output.close();
    }catch(Exception e){
        System.out.println("No se pudo escribir en archivo.");
        e.printStackTrace(); 
    }

%eof}

/* ---- Expresiones regulares. ----*/
IDENTIFICADORES_RAW = [\w_][\w\d_]*
IDENTIFICADOR = {IDENTIFICADORES_RAW}
BOOLEANO = True|False
ENTERO = (([1-9][0-9]*)|0+)
REAL = \.[0-9]+|{ENTERO}\.\d|{ENTERO}\.
CADENA = \"(\\.|[^\\\"])*\"
CADENA_MAL = \"(\\.|[^\\\"])*
PALABRA_RESERVADA = and|or|not|while|if|else|elif|print
OPERADOR = \+|-|\*|\%|<|>|>=|<=|=|\!|\+=
SEPARADOR = :
LINE_TERMINATOR = \r|\n|\r\n

%state IDENTA
%state ATOMOS
%state ERROR

%%
/*---- Macros y acciones. ----*/
<YYINITIAL>{
    .                   {nextSymbol("\n"); newIdenta(); yypushback(1); yybegin(IDENTA);}
}

<ATOMOS>{
    #.* { System.out.println("COMENTARIO"); }
    {BOOLEANO}          { nextSymbol("BOOLEAN", yytext()); }
    {ENTERO}            { nextSymbol("ENTERO", yytext()); }
    {REAL}              { nextSymbol("REAL", yytext()); }
    {CADENA}            { nextSymbol("CADENA", yytext()); }
    {PALABRA_RESERVADA} { nextSymbol("RESERVADA", yytext()); }
    {OPERADOR}          { nextSymbol("OPERADOR", yytext()); }
    {IDENTIFICADOR}     { nextSymbol("IDENTIFICADOR", yytext()); }
    {SEPARADOR}         { nextSymbol("SEPARADOR", yytext()); }
    {CADENA_MAL}        { reportError(0); }
    /* Abre nuevo contexto de identacion para esto se creara una pila qu guarde el
       numero de identaciones en el nuevo bloque que estamos creando.*/ 
    {LINE_TERMINATOR}   { nextSymbol("SALTO\n"); no_linea++; newIdenta(); yybegin(IDENTA); }
    //{OTRO}              { nextSymbol("ERROR en la linea: " + no_linea); }
    . { nextSymbol(yytext()); reportError(2); }
}

<IDENTA>{
    \s                  { pushIdenta(); }
    \S                  { 
        isIdenta();
        if(errorIdenta()){
            yybegin(ERROR);
        }else{
            yypushback(1); 
            yybegin(ATOMOS);
        }
    }
}

<ERROR>{
    (.|{LINE_TERMINATOR})*                  { reportError(1); }
}