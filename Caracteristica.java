public class Caracteristica {
    
    private String nombre; 
    private int prioridad;
    private int tiemp;
    
    public Caracteristica (String n, int p, int t) {
        nombre= n;
        prioridad= p;
        tiemp= t;
    }
    
    public int tiempo () {
    	return tiemp;
    }
    
    public int prior () {
    	return prioridad;
    }
    
    public String name () {
    	return nombre;
    }
    
}