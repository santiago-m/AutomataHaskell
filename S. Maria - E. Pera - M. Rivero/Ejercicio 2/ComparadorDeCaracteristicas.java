import java.util.Comparator;

public class ComparadorDeCaracteristicas implements Comparator<Caracteristica>{

	@Override
	/*
	 * Devuelve un numero negativo, cero o un numero positivo si el primer argumento es menor, igual
	 * que, o mayor que el segundo.
	 * 
	 */
	public int compare(Caracteristica o1, Caracteristica o2) {
		return Float.compare(o2.getRelacion(), o1.getRelacion());
	}

}