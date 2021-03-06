/** Componente. La clase genéria Nodo.*/
package ast.patron.compuesto;
import ast.patron.visitante.*;
import ast.patron.tipos.*;

public class Nodo {
    public Hijos hijos; //lista de hijos
    Variable valor; 
    Tipo tipo;
    String name;
    Operador operador;

    /*(1)**********GETTERS**************/
    public Hijos getHijos(){return hijos;}
    public Nodo getHijo(){return null;}
    //public void setHijo(Nodo c){}
    public Nodo getUltimoHijo(){return null;}
    public Nodo getPrimerHijo(){return null;}
    public Variable getValor(){return valor;}
    public Tipo getType(){return tipo;}
    public Operador getOperador(){return operador;}
    public String getNombre(){return name;}
    /***********************************/

    public void agregaHijoFinal(Nodo r){}
    public void agregaHijoPrincipio(Nodo r){}

    /*(3)**********SETTERS**************/
    public void setValor(Variable nuevo){valor = nuevo;}
    public void setTipo(Tipo nuevo){tipo = nuevo;}
    /***********************************/

    // private Tipo calculaTipo(){
        
    // }

    public void accept(Visitor v){v.visit(this);}
    public void semanticAccept(AbstractVisitor a){a.abVisit((Nodo)this);}

}
