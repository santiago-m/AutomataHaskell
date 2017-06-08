import java.util.Arrays;

public class Sprint {
	
	private float limiteTiempo;
	
	public Sprint(float lim){
		limiteTiempo = lim;
	}
	
	public void completarSprint(Caracteristica[] caracteristicas){

		// Sort ordena los elementos en forma descendente, segun la relacion de peso y prioridad
		// Segun el comparador de caracteristicas
		Arrays.sort(caracteristicas, new ComparadorDeCaracteristicas());
		
		float tiempoSprint = 0; 			// Tiempo que lleva el sprint
		
		int i = 0;
		String[] solucion = new String[caracteristicas.length];
		
		while((i < caracteristicas.length) && (tiempoSprint + caracteristicas[i].tiempo() <= limiteTiempo)){
			// Si tenemos tiempo, podemos agregar caracteristicas al sprint
			tiempoSprint += (float)caracteristicas[i].tiempo();
			solucion[i] = caracteristicas[i].name();
			i++;
		}
		if(i <= caracteristicas.length && tiempoSprint < limiteTiempo){ 
			// Quedan candidatos por considerar y hay hueco en el sprint
			// Porque en la relacion que usamos para comparar, puede que exista uno con menos horas y que aun asi, pueda entrar..
			float capacidadRestante = limiteTiempo - tiempoSprint;
			tiempoSprint = limiteTiempo;
		}
		
		
		System.out.println("Limite de tiempo del Sprint: " + limiteTiempo);
		System.out.println("Tiempo que lleva completar el Sprint final: " + tiempoSprint);
		System.out.println("Caracteristicas realizadas durante el Sprint: ");
		for(int j = 0; j < i; j++){
			System.out.println(solucion[j] + " ");
		}
	}
}