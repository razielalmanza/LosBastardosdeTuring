package ast.patron.compuesto;
import java.util.LinkedList;
import java.util.Iterator;
import java.util.AbstractCollection;
import java.lang.ArrayStoreException;

/* Extends Abstract Collection. */
public class Hijos extends AbstractCollection {

    public LinkedList<Nodo> hijos;
    /*(1)***********CONSTRUCTORES*************/
    public Hijos(Nodo l){
 	hijos = new LinkedList<Nodo>();
	hijos.addFirst(l);
    }
    public Hijos() {hijos = new LinkedList<Nodo>();}
    /***************************************/
    public Iterator iterator(){return hijos.iterator();}
    /*(2)**********GETTERS**************/
    public LinkedList<Nodo> getAll(){return hijos;}
    public int size() {return hijos.size();}
    public Nodo getPrimerHijo() {return hijos.getFirst();}
    public Nodo getUltimoHijo() {return hijos.getLast();}
    /*********************************/

    public void agregaHijoPrincipio(Nodo l) {hijos.addFirst(l);}
    public void agregaHijoFinal(Nodo r) {hijos.add(r);}
}
