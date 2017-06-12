/**
	* Clase que representa una caracteristica funcional de la metodologia scrum.
*/

public class CFuncional {
	String nombre;
	int prioridad;
	int costoDeTiempo;

	public CFuncional(String name, int p, int c) {
		nombre = name;
		prioridad = p;
		costoDeTiempo = c;
	}

	public String getName() {
		return nombre;
	}

	public int getPrioridad() {
		return prioridad;
	}

	public int getCosto() {
		return costoDeTiempo;
	}
}