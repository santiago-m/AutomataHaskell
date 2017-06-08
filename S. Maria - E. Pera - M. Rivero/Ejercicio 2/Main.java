public class Main {

	/*
	 * Main de prueba para encontrar el mejor sprint
	 */
	public static void main(String[] args){
		
		final int NUM_OBJETOS = 8;		// numero de caracteristicas totales
		final float TIEMPO_MAXIMO = 25;	// tiempo maximo del sprint
		
		Caracteristica[] caracteristicas = new Caracteristica[NUM_OBJETOS];
		
		float[] tiempos = {2, 2, 4, 1, 2, 3, 12, 6};
		int[] prioridades = {4, 6, 8, 3, 6, 9, 12, 8};
		
		
		for(int i = 0; i < NUM_OBJETOS; i++){
			caracteristicas[i] = new Caracteristica("caracteristica "+String.valueOf(i), tiempos[i], prioridades[i]);
		}
		
		Sprint sprint = new Sprint(TIEMPO_MAXIMO);
		
		sprint.completarSprint(caracteristicas);
	}
}	