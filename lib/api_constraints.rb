class ApiConstraints

#inicializamos los valores de versión y si es default de la API
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end
   
  #Aquí vemos si los parámetros especifican alguna versión de la API 
  def matches?(req)
    @default || req.headers['Accept'].include?("application/vnd.kanbantt.v#{@version}")
  end
end