package ast.patron.compuesto;
import ast.patron.visitante.*;

public class AddNodo extends Compuesto {
    
    public AddNodo(Nodo add, String value){
        this.agregaHijoPrincipio(add);
	    valor = new Variable("+");
    }

    public void accept(Visitor v){
     	v.visit(this);
    }
}
