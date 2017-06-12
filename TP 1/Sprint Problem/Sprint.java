import java.util.ArrayList;

/**
    * Clase que representa un Sprint con un tiempo limite y backlog especificos.
    * @author Santiago Maria
    * @version 1.0
*/
class Sprint {
    int limTiempo;
    CFuncional[] backlog;

    /**
        * Constructor de un Sprint sin caracteristicas a completar.
    */

    public Sprint(int lim) {
        limTiempo = lim;
        backlog = null;
    }

    /**
        * Constructor de un Sprint con caracteristicas funcionales a completar.
    */

    public Sprint(int lim, CFuncional[] caracteristicas) {
        limTiempo = lim;
        backlog = cargarSprint(caracteristicas);
    }

    // Funcion que devuelve el maximo entre dos enteros.
    private int max(int a, int b) { 
        return (a > b)? a : b; 
    }
      
    /**
        * Funcion que devuelve en forma de arreglo el backlog del sprint, segun la lista de caracteristicas que se le pase como parametro.
        * @param caracteristicas lista de caracteristicas funcionales que se desean completar.
    */
    public CFuncional[] cargarSprint (CFuncional[] caracteristicas)
    {
        int cantCaracteristicas = caracteristicas.length;
        int K[][] = new int[cantCaracteristicas+1][limTiempo+1];
        ArrayList<CFuncional> backlog = new ArrayList<CFuncional>(cantCaracteristicas);

        for (int i = 0; i <= cantCaracteristicas; i++)
        {
            for (int w = 0; w <= limTiempo; w++)
            {
                if (i==0 || w==0) {
                    K[i][w] = 0;
                }
                else if (caracteristicas[i-1].getCosto() <= w) {
                    K[i][w] = max(caracteristicas[i-1].getPrioridad() + K[i-1][w-(caracteristicas[i-1].getCosto())],  K[i-1][w]);
                }
                else {
                    K[i][w] = K[i-1][w];
                }
            }
        }

        int i = cantCaracteristicas;
        int j = limTiempo;
        while ((i > 0) && (j > 0)) {
            if (K[i][j] != K[i-1][j]) {
                backlog.add(caracteristicas[i-1]);
                j = j - caracteristicas[i-1].getCosto();
            }
            i = i-1;
        }

        CFuncional[] backlogResult = new CFuncional[backlog.size()];
        
        for (i = 0; i < backlog.size(); i++) {
            backlogResult[i] = backlog.get(i);
        }
        return backlogResult;
    }

    public void mostrarBacklog() { 
        for (int i = 0; i < backlog.length; i++) {
            System.out.println(backlog[i].getName());
            System.out.println("    prioridad: "+backlog[i].getPrioridad());
            System.out.println("    Costo de Tiempo: "+backlog[i].getCosto());
            System.out.println();
        }
    }
}