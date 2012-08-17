class PagesController < ApplicationController
  def home
  	@title = 'Inicio'
  end

  def about
  	@title = 'Acerca'
  end

  def help
  	@title = 'Ayuda'
  end

  def contact
  	@title = 'Contacto'
  end
end
