import java.util.*;

public class Sprint {
	private ArrayList<Caracteristica> lista;
	private ArrayList<Integer> pasado;
	private int tiempoLim; 		// tiempo maximo posible del Sprint
	private int tiempoAcum= 0; 	// tiempo que lleva acumulado
	private int cantPrior= 0; 	// suma de prioridades
	
	public Sprint (int lim) {
		tiempoLim = lim;
		lista = new ArrayList<Caracteristica>();
		pasado = new ArrayList<Integer>();
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

	public void usado (Integer i) {
		pasado.add (i);
	}

	public boolean existe (int i) {
		return ((this.pasado).indexOf(i) == -1 );
	}

	public Sprint mejorSprint (Sprint original, int pos, int prof) {
		
		Sprint aux  = new Sprint(tiempoLim);
		Sprint aux2 = new Sprint(tiempoLim);
		Sprint aux3 = new Sprint(tiempoLim);
		if (prof >0) {
		int i = pos;

		while ((original.tamanio() > i+1) && (original.tiempoLim != original.tiempoAcum)) {
			Caracteristica op1 = original.corriente(i);

			if (aux.esPosible(op1) && (original.existe(i)) ) {
				aux.newElement(op1);
				original.usado(i);
			}

			i++;
		}

		aux2 = mejorSprint(original, pos+1, prof-1);

		aux3 = mejorSprint(original, i, prof)

		if ( aux.sumPrior() > aux2.sumPrior() ) {
			return aux;
		} else {
			return aux2;
		}}
		return aux;
	}

	

	public void mostrar () {
		for (int i=0 ; i<lista.size() ; i++)
			System.out.println( corriente(i).name());
	}

	public void carga() {
		//	("Nombre" , Prioridad, Horas)
		this.newElement("a",1,7);//
		this.newElement("b",2,10);
		this.newElement("c",3,6); //
		this.newElement("d",3,11);
		this.newElement("e",1,8);
		this.newElement("f",2,13);
		this.newElement("g",1,6); 
		this.newElement("h",1,9);
		this.newElement("i",2,5); //
		this.newElement("j",1,1); //
		this.newElement("k",3,7);
		this.newElement("l",1,5);


	}

}
