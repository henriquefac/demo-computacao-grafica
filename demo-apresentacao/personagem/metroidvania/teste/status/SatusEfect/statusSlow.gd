extends StatusEfect
class_name StatusSlow

  # Chama o método 'start' da classe base

func Ready():
	super()
	Velocidade(-100)  # Reduz a velocidade
	Jump(200)         # Modifica o pulo
