public class main {


	public static void main(String[] args) {
	
	Sprint fullCaracteristicas = new Sprint(9999);
	fullCaracteristicas.carga();

	//fullCaracteristicas.mostrar();
	Sprint asd = new Sprint(20);

	asd= asd.mejorSprint(fullCaracteristicas,0,30);

	asd.mostrar();
	System.out.println(asd.tamanio());

	}

}
