public class Caracteristica {
    
    private String nombre; 
    private float prioridad;
    private float tiempo;
    private float relacion;
    
    public Caracteristica (String n, float p, float t) {
        nombre= n;
        prioridad= p;
        tiempo= t;
        relacion = p/t;
    }
    
    public float tiempo () {
    	return tiempo;
    }
    
    public float prior () {
    	return prioridad;
    }
    
    public String name () {
    	return nombre;
    }

    public float getRelacion() {
        return relacion;
    }
    
}
