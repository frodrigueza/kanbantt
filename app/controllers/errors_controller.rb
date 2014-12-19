class ErrorsController < ApplicationController
  def file_not_found
  	@explanation = set_explanation
  	@number = "404"
  end

  def unprocessable
  	@explanation = set_explanation
  	@number = "422"
  end

  def internal_server_error
  	@explanation = set_explanation
  	@number = "500"
  end

  private
  def set_explanation
  	@explanation = "Lo sentimos, algo salió mal. Por favor vuelve al inicio."
  end

end
