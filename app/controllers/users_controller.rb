class UsersController < ApplicationController
  require 'aws-sdk-dynamodb'

  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:nombre, :email, :telefono)

    if save_dynamo(user_params)
      redirect_to users_path, notice: 'Usuario creado exitosamente.'
    else
      flash.now[:alert] = 'Error al crear el usuario.'
      render :new
    end
  end

  private

    def save_dynamo (user_params)
      dynamodb_client = Aws::DynamoDB::Client.new(
        credentials: Aws::Credentials.new('k0etxc', '6d1nbr'),
        region: 'localhost',  
        endpoint: 'http://localhost:8000'
        )
        table_name = 'users'

        dynamodb_client.put_item({
          table_name: table_name,
          item: {
            'email' => user_params[:email],
            'telefono' => user_params[:telefono],
            'nombre' => user_params[:nombre],
          }
        })
        puts "El usuario se ha registrado"
        return true
        
        raise "Error"
      rescue Aws::DynamoDB::Errors::ServiceError => e
        puts "Error de DynamoDB: #{e.message}"
        return false
      end
    end