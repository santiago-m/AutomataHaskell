public class Main {
    public static void main(String[] args) {
	Sprint sprint;

	int prioridades[] = new int[]{60, 100, 120, 30, 45, 50, 200, 35, 40, 55, 90};
        int costosTiempo[] = new int[]{10, 20, 30, 30, 35, 55, 10, 12, 30, 50, 40};
        CFuncional[] elementosSprint = new CFuncional[prioridades.length];

        for (int i = 0; i < prioridades.length; i++) {
            elementosSprint[i] = new CFuncional("Caracteristica "+i, prioridades[i], costosTiempo[i]);
        }
        sprint = new Sprint(50, elementosSprint);

        sprint.mostrarBacklog();
    }
}