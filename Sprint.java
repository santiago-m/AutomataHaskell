import java.util.*;

public class Sprint {
	private ArrayList<Caracteristica> lista;
	private int tiempoLim; 		// tiempo maximo posible del Sprint
	private int tiempoAcum= 0; 	// tiempo que lleva acumulado
	private int cantPrior= 0; 	// suma de prioridades
	
	public Sprint (int lim) {
		tiempoLim = lim;
		lista = new ArrayList<Caracteristica>();
	}
	
	public void newElement (String nombre, int prioridad, int tiempo) {
		
		Caracteristica aux = new Caracteristica (nombre, prioridad, tiempo);
		
		if ((tiempoAcum + tiempo) <= tiempoLim) {
			lista.add(aux);
			tiempoAcum+= tiempo;
			cantPrior+= prioridad;
		}
	}

	public void newElement (Caracteristica nueva) {
		
		if ((tiempoAcum + nueva.tiempo()) <= tiempoLim) {
			lista.add(nueva);
			tiempoAcum+= nueva.tiempo();
			cantPrior+= nueva.prior();
		}
	}

	public boolean esPosible (Caracteristica revisar){
		return ((tiempoAcum + revisar.tiempo()) <= tiempoLim);
	}


	public Caracteristica corriente (int i) {
		return lista.get(i);
	}

	public int tamanio (){
		return lista.size();
	}

	public int sumPrior () {
		return cantPrior;
	}

	public void eliminarElem (int i) {
		tiempoAcum-= corriente(i).tiempo();
		cantPrior-= corriente(i).prior();
		lista.remove(i);
	}

	@SuppressWarnings("unchecked")
	private ArrayList<Caracteristica> cop () {
		ArrayList<Caracteristica> devolver = new ArrayList<Caracteristica>();
		devolver = (ArrayList<Caracteristica>)lista.clone();
		return devolver;
	}

	public void copiar (Sprint asd) {
		this.lista = asd.cop();
	}


	public Sprint mejorSprint (Sprint original, int pos, int prof) {
		
		Sprint aux  = new Sprint(tiempoLim);
		Sprint aux2 = new Sprint(tiempoLim);
		if (prof >0) {
		int i = pos;

		while ((original.tamanio() > i+1) && (original.tiempoLim != original.tiempoAcum)) {
			Caracteristica op1 = original.corriente(i);

			if (esPosible(op1)) {
				aux.newElement(op1);
			}

			i++;
		}

		//  La idea es que no vuelva a sumar todos hasta el elemento corriente, sino que solamente saca el primero, 
		// y sigue viendo que otra cosa se puede agregar
		aux2.copiar(aux);

		if (aux.tamanio()> 0) {
			aux2.eliminarElem(0);
		}

		aux2 = memoSprint(original, aux2, i, prof-1);

		if ( aux.sumPrior() > aux2.sumPrior() ) {
			return aux;
		} else {
			return aux2;
		}}
		return aux;
	}

	private Sprint memoSprint (Sprint original, Sprint actual, int pos, int prof) {
		
		Sprint aux  = new Sprint(tiempoLim);
		Sprint aux2  = new Sprint(tiempoLim);
		if (prof >0) {
		int i = pos;
		aux2 = actual;

		while ((original.tamanio() > i+1)) {
			Caracteristica op1 = original.corriente(i);

			if (esPosible(op1)) {
				aux2.newElement(op1);
			}

			i++;
		}

		aux.copiar(actual);
		if (actual.tamanio()> 0) {
			aux.eliminarElem(0);
		}

		aux = memoSprint(original, aux, i, prof-1);

		if ( aux2.sumPrior() > aux.sumPrior() ) {
			return aux2;
		} else {
			return aux;
		}}
		return aux;
	}


	public void mostrar () {
		for (int i=0 ; i<lista.size() ; i++)
			System.out.println( corriente(i).name());
	}

	public void carga() {
		//	("Nombre" , Prioridad, Horas)
		this.newElement("a",1,2);
		this.newElement("b",2,3);
		this.newElement("c",3,7);
		this.newElement("d",3,11);
		this.newElement("e",1,4);
		this.newElement("f",2,13);
		this.newElement("g",1,5);
		this.newElement("h",1,5);
		this.newElement("i",2,5);
		this.newElement("j",1,1);
		this.newElement("k",3,7);
		this.newElement("l",1,5);


	}

}
